param(
    [string]$CredentialFile = (Join-Path $PSScriptRoot '..\storage\security\credentials.local.json'),
    [string]$OutputFile = (Join-Path $PSScriptRoot '..\docs\security\06_test_results.txt')
)

$ErrorActionPreference = 'Stop'

$mysql = 'C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysql.exe'
if (-not (Test-Path $mysql)) {
    $cmd = Get-Command mysql -ErrorAction SilentlyContinue
    if (-not $cmd) { throw 'mysql client tidak ditemukan.' }
    $mysql = $cmd.Source
}

if (-not (Test-Path $CredentialFile)) {
    throw "File kredensial tidak ditemukan: $CredentialFile"
}

$creds = Get-Content $CredentialFile -Raw | ConvertFrom-Json
$rootPassword = ''
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$probeUser = "__app_probe_$stamp"
$probeAudit = "__audit_probe_$stamp"

$script:pass = 0
$script:fail = 0
$script:lines = New-Object System.Collections.Generic.List[string]

function Write-Result {
    param([string]$Line)
    Write-Host $Line
    $script:lines.Add($Line) | Out-Null
}

function Invoke-Mysql {
    param(
        [string]$User,
        [string]$Password,
        [string]$Sql
    )

    $previousErrorAction = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $env:MYSQL_PWD = $Password
        $output = & $mysql -u $User -N -e $Sql 2>&1
        $code = $LASTEXITCODE
    }
    finally {
        Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
        $ErrorActionPreference = $previousErrorAction
    }

    return [pscustomobject]@{
        Code   = $code
        Output = (($output | ForEach-Object { $_.ToString() }) -join ' | ')
    }
}

function Assert-Allowed {
    param([string]$Label, [string]$User, [string]$Password, [string]$Sql)

    $r = Invoke-Mysql -User $User -Password $Password -Sql $Sql
    if ($r.Code -eq 0) {
        $script:pass++
        Write-Result ("PASS allow  [{0}] {1} -> {2}" -f $User, $Label, $r.Output)
    } else {
        $script:fail++
        Write-Result ("FAIL allow  [{0}] {1} -> {2}" -f $User, $Label, $r.Output)
    }
}

function Assert-Denied {
    param([string]$Label, [string]$User, [string]$Password, [string]$Sql)

    $r = Invoke-Mysql -User $User -Password $Password -Sql $Sql
    if ($r.Code -ne 0) {
        $script:pass++
        Write-Result ("PASS deny   [{0}] {1} -> {2}" -f $User, $Label, $r.Output)
    } else {
        $script:fail++
        Write-Result ("FAIL deny   [{0}] {1} -> command unexpectedly succeeded" -f $User, $Label)
    }
}

function Invoke-RootSql {
    param([string]$Sql)
    return Invoke-Mysql -User 'root' -Password $rootPassword -Sql $Sql
}

# ---------------------------------------------------------------------
# Probe objects (dibuat root, dipakai untuk menguji DDL tanpa menyentuh
# tabel produksi).
# ---------------------------------------------------------------------
Invoke-RootSql "DROP TABLE IF EXISTS trimset.__ddl_probe__; CREATE TABLE trimset.__ddl_probe__ (id INT) ENGINE=InnoDB;" | Out-Null
Invoke-RootSql "DROP VIEW IF EXISTS trimset.__reader_probe_view__; CREATE VIEW trimset.__reader_probe_view__ AS SELECT 1 AS x;" | Out-Null

try {
    Write-Result ("Security tests {0}" -f (Get-Date).ToString('s'))
    Write-Result ''

    # -----------------------------------------------------------------
    # trim_app: allowed
    # -----------------------------------------------------------------
    Assert-Allowed 'SELECT warga' 'trim_app' $creds.app "SELECT COUNT(*) FROM trimset.warga;"
    Assert-Allowed 'SELECT saldo' 'trim_app' $creds.app "SELECT COUNT(*) FROM trimset.saldo;"
    Assert-Allowed 'SELECT personal_access_tokens' 'trim_app' $creds.app "SELECT COUNT(*) FROM trimset.personal_access_tokens;"
    Assert-Allowed 'INSERT users+warga (transaction rollback)' 'trim_app' $creds.app "START TRANSACTION; INSERT INTO trimset.users (username,password,role,status) VALUES ('$probeUser','x','warga','aktif'); SET @uid=LAST_INSERT_ID(); INSERT INTO trimset.warga (id_user,nama,no_hp,alamat,status_verifikasi) VALUES (@uid,'Grant Test','$stamp','Test','menunggu'); ROLLBACK; SELECT 'ok';"
    Assert-Allowed 'UPDATE warga (transaction rollback)' 'trim_app' $creds.app "START TRANSACTION; UPDATE trimset.warga SET nama=nama WHERE id_warga=1; ROLLBACK; SELECT 'ok';"
    Assert-Allowed 'INSERT transaksi+detail (transaction rollback)' 'trim_app' $creds.app "START TRANSACTION; INSERT INTO trimset.transaksi_penimbangan (id_antrian,id_pengurus,tanggal_transaksi) VALUES (3,1,NOW()); SET @tid=LAST_INSERT_ID(); INSERT INTO trimset.detail_transaksi (id_transaksi,id_kategori,berat) VALUES (@tid,1,1.00); ROLLBACK; SELECT 'ok';"
    Assert-Allowed 'INSERT pencairan (transaction rollback)' 'trim_app' $creds.app "START TRANSACTION; INSERT INTO trimset.pencairan (id_warga,id_jadwal_pencairan,jumlah,catatan,tanggal_pengajuan) VALUES (1,3,1000,'Test',NOW()); ROLLBACK; SELECT 'ok';"
    Assert-Allowed 'UPDATE pencairan (transaction rollback)' 'trim_app' $creds.app "START TRANSACTION; UPDATE trimset.pencairan SET status='disetujui', id_pengurus=1 WHERE id_pencairan=1; ROLLBACK; SELECT 'ok';"
    Assert-Allowed 'UPDATE antrian (transaction rollback)' 'trim_app' $creds.app "START TRANSACTION; UPDATE trimset.antrian SET status='batal' WHERE id_antrian=3; ROLLBACK; SELECT 'ok';"
    Assert-Allowed 'INSERT audit_log' 'trim_app' $creds.app "INSERT INTO trimset.audit_log (action,object_type,object_id,result) VALUES ('$probeAudit','security_test','probe','success'); SELECT 'ok';"

    # -----------------------------------------------------------------
    # trim_reader: allowed (view only)
    # -----------------------------------------------------------------
    Assert-Allowed 'SELECT v_warga_publik' 'trim_reader' $creds.reader "SELECT COUNT(*) FROM trimset.v_warga_publik;"
    Assert-Allowed 'SELECT v_kategori_aktif' 'trim_reader' $creds.reader "SELECT COUNT(*) FROM trimset.v_kategori_aktif;"
    Assert-Allowed 'SELECT v_transaksi_ringkas' 'trim_reader' $creds.reader "SELECT COUNT(*) FROM trimset.v_transaksi_ringkas;"
    Assert-Allowed 'SELECT v_pencairan_ringkas' 'trim_reader' $creds.reader "SELECT COUNT(*) FROM trimset.v_pencairan_ringkas;"
    Assert-Allowed 'SELECT v_rekap_kas' 'trim_reader' $creds.reader "SELECT COUNT(*) FROM trimset.v_rekap_kas;"

    # -----------------------------------------------------------------
    # trim_app: denied
    # -----------------------------------------------------------------
    Assert-Denied 'SELECT mysql.user' 'trim_app' $creds.app "SELECT * FROM mysql.user;"
    Assert-Denied 'DROP TABLE probe' 'trim_app' $creds.app "DROP TABLE trimset.__ddl_probe__;"
    Assert-Denied 'ALTER TABLE probe' 'trim_app' $creds.app "ALTER TABLE trimset.__ddl_probe__ ADD COLUMN x INT;"
    Assert-Denied 'CREATE TABLE' 'trim_app' $creds.app "CREATE TABLE trimset.__app_probe__ (id INT);"
    Assert-Denied 'CREATE VIEW' 'trim_app' $creds.app "CREATE VIEW trimset.__app_view_probe__ AS SELECT 1 AS x;"
    Assert-Denied 'CREATE USER' 'trim_app' $creds.app "CREATE USER '__app_probe__'@'localhost' IDENTIFIED BY 'x';"
    Assert-Denied 'DELETE warga' 'trim_app' $creds.app "DELETE FROM trimset.warga WHERE id_warga=-1;"
    Assert-Denied 'UPDATE saldo' 'trim_app' $creds.app "UPDATE trimset.saldo SET saldo_terakhir=saldo_terakhir WHERE id_saldo=1;"
    Assert-Denied 'UPDATE detail_transaksi' 'trim_app' $creds.app "UPDATE trimset.detail_transaksi SET berat=berat WHERE id_detail=1;"
    Assert-Denied 'SELECT audit_log' 'trim_app' $creds.app "SELECT * FROM trimset.audit_log;"
    Assert-Denied 'SELECT v_warga_publik' 'trim_app' $creds.app "SELECT * FROM trimset.v_warga_publik;"
    Assert-Denied 'UPDATE users' 'trim_app' $creds.app "START TRANSACTION; UPDATE trimset.users SET role='admin' WHERE id_user=1; ROLLBACK;"
    Assert-Denied 'INSERT pengurus' 'trim_app' $creds.app "START TRANSACTION; INSERT INTO trimset.pengurus (id_user,nama) VALUES (999999,'probe'); ROLLBACK;"
    Assert-Denied 'SELECT migrations' 'trim_app' $creds.app "SELECT * FROM trimset.migrations;"
    Assert-Denied 'SELECT password_reset_tokens' 'trim_app' $creds.app "SELECT * FROM trimset.password_reset_tokens;"

    # -----------------------------------------------------------------
    # trim_reader: denied (base tables / DDL)
    # -----------------------------------------------------------------
    Assert-Denied 'SELECT warga' 'trim_reader' $creds.reader "SELECT * FROM trimset.warga;"
    Assert-Denied 'SELECT pencairan' 'trim_reader' $creds.reader "SELECT * FROM trimset.pencairan;"
    Assert-Denied 'INSERT view' 'trim_reader' $creds.reader "INSERT INTO trimset.v_warga_publik (id_warga,nama,no_hp_masked,status_verifikasi) VALUES (999,'x','x','menunggu');"
    Assert-Denied 'UPDATE view' 'trim_reader' $creds.reader "UPDATE trimset.v_rekap_kas SET total_pemasukan=0;"
    Assert-Denied 'DROP VIEW probe' 'trim_reader' $creds.reader "DROP VIEW trimset.__reader_probe_view__;"
}
finally {
    Invoke-RootSql "DROP TABLE IF EXISTS trimset.__ddl_probe__; DROP VIEW IF EXISTS trimset.__reader_probe_view__; DROP TABLE IF EXISTS trimset.__app_probe__; DROP VIEW IF EXISTS trimset.__app_view_probe__; DROP USER IF EXISTS '__app_probe__'@'localhost'; DELETE FROM trimset.audit_log WHERE action='$probeAudit';" | Out-Null
}

Write-Result ''
Write-Result ("RESULT pass={0} fail={1}" -f $script:pass, $script:fail)

$dir = Split-Path -Parent $OutputFile
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
$script:lines | Set-Content -Encoding UTF8 $OutputFile

if ($script:fail -gt 0) { exit 1 }
