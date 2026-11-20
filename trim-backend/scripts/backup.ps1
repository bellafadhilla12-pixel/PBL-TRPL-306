param(
    [string]$Database = 'trimset',
    [string]$OutputDir = (Join-Path $PSScriptRoot '..\storage\backups'),
    [string]$User = 'trim_admin',
    [string]$Password = $null,
    [int]$RetentionDays = 14
)

$ErrorActionPreference = 'Stop'

if (-not $Password) {
    $credFile = Join-Path $PSScriptRoot '..\storage\security\credentials.local.json'
    if (Test-Path $credFile) {
        $creds = Get-Content $credFile -Raw | ConvertFrom-Json
        if ($User -eq 'trim_admin') { $Password = $creds.admin }
        elseif ($User -eq 'trim_app') { $Password = $creds.app }
        elseif ($User -eq 'trim_reader') { $Password = $creds.reader }
    }
}

if (-not $Password -and $User -ne 'root') {
    throw "Password untuk user '$User' tidak ditemukan. Isi storage/security/credentials.local.json atau kirim -Password."
}

$mysqldump = 'C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysqldump.exe'
if (-not (Test-Path $mysqldump)) {
    $cmd = Get-Command mysqldump -ErrorAction SilentlyContinue
    if (-not $cmd) { throw 'mysqldump tidak ditemukan.' }
    $mysqldump = $cmd.Source
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outFile = Join-Path $OutputDir ("{0}_{1}.sql" -f $Database, $stamp)

$env:MYSQL_PWD = $Password
& $mysqldump --single-transaction --no-tablespaces --routines --triggers --events --default-character-set=utf8mb4 --result-file=$outFile -u $User $Database
$exitCode = $LASTEXITCODE
Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue

if ($exitCode -ne 0) {
    throw "mysqldump gagal dengan exit code $exitCode."
}

$file = Get-Item $outFile
$hash = Get-FileHash $outFile -Algorithm SHA256

$meta = [ordered]@{
    database   = $Database
    file       = $file.FullName
    bytes      = $file.Length
    sha256     = $hash.Hash
    created_at = (Get-Date).ToString('s')
    user       = $User
}
$meta | ConvertTo-Json | Set-Content -Encoding UTF8 ("{0}.json" -f $outFile)

# Retensi sederhana: hapus backup lebih lama dari RetentionDays.
$cutoff = (Get-Date).AddDays(-$RetentionDays)
Get-ChildItem $OutputDir -Filter ("{0}_*.sql" -f $Database) -File |
    Where-Object { $_.LastWriteTime -lt $cutoff } |
    Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem $OutputDir -Filter ("{0}_*.sql.json" -f $Database) -File |
    Where-Object { $_.LastWriteTime -lt $cutoff } |
    Remove-Item -Force -ErrorAction SilentlyContinue

Write-Host ("Backup OK: {0} ({1} bytes, SHA256 {2})" -f $file.FullName, $file.Length, $hash.Hash)
Write-Host ("Retensi: {0} hari" -f $RetentionDays)
