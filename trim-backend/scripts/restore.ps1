param(
    [Parameter(Mandatory = $true)]
    [string]$BackupFile,

    [string]$TargetDatabase = 'trimset_restore_test',

    # Restore ke database uji memerlukan akun yang boleh CREATE/DROP database.
    # Gunakan root/DBA lingkungan, bukan trim_app.
    [string]$User = 'root',

    [string]$Password = '',

    [switch]$DropAfterVerify
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $BackupFile)) {
    throw "File backup tidak ditemukan: $BackupFile"
}

$mysql = 'C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysql.exe'
if (-not (Test-Path $mysql)) {
    $cmd = Get-Command mysql -ErrorAction SilentlyContinue
    if (-not $cmd) { throw 'mysql client tidak ditemukan.' }
    $mysql = $cmd.Source
}

if ($TargetDatabase -eq 'trimset') {
    throw 'Target restore tidak boleh trimset (produksi). Gunakan database uji terpisah.'
}

$env:MYSQL_PWD = $Password

try {
    & $mysql -u $User -e "DROP DATABASE IF EXISTS ``$TargetDatabase``; CREATE DATABASE ``$TargetDatabase`` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    if ($LASTEXITCODE -ne 0) { throw 'Gagal membuat database target.' }

    $redirect = "`"$mysql`" -u $User $TargetDatabase < `"$BackupFile`""
    cmd /c $redirect
    if ($LASTEXITCODE -ne 0) { throw 'Restore gagal.' }

    $tableCount = & $mysql -u $User -N -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA='$TargetDatabase' AND TABLE_TYPE='BASE TABLE';"
    $triggerCount = & $mysql -u $User -N -e "SELECT COUNT(*) FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='$TargetDatabase';"
    $userCount = & $mysql -u $User -N -e "SELECT COUNT(*) FROM ``$TargetDatabase``.users;"
    $trxCount = & $mysql -u $User -N -e "SELECT COUNT(*) FROM ``$TargetDatabase``.transaksi_penimbangan;"

    Write-Host ("Restore OK -> {0}" -f $TargetDatabase)
    Write-Host ("  tables={0} triggers={1} users={2} transaksi={3}" -f $tableCount, $triggerCount, $userCount, $trxCount)

    if ($DropAfterVerify) {
        & $mysql -u $User -e "DROP DATABASE IF EXISTS ``$TargetDatabase``;"
        if ($LASTEXITCODE -ne 0) { throw 'Gagal menghapus database uji.' }
        Write-Host ("Database uji {0} dihapus setelah verifikasi." -f $TargetDatabase)
    }
}
finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
}
