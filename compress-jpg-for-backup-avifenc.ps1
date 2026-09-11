$source = "B:\src"
$dest = "B:\Compressed"
$threads = 12

# Encoder settings
$quality = 70      # 0-100
$speed = 6         # 0=slowestbest, 10=fastest
$jobs = 2         # Threads per encoder process
$encoder = "C:\Users\me\Downloads\windows-artifacts\avifenc.exe"

$files = Get-ChildItem $source -Recurse -File | Where-Object { $_.Extension -match '^\.(jpe?g)$' }

$files | ForEach-Object -Parallel {

    $source  = $using:source
    $dest    = $using:dest
    $quality = $using:quality
    $speed   = $using:speed
    $jobs    = $using:jobs

    $relative = $_.FullName.Substring($source.Length).TrimStart('\')
    $relative = [System.IO.Path]::ChangeExtension($relative, ".avif")

    $outFile = Join-Path $dest $relative
    $outDir = Split-Path $outFile

    if (!(Test-Path $outDir)) {
        New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    }

    if (Test-Path $outFile) {
        return
    }

    Write-Host "Converting $relative"

    & $using:encoder `
        --jobs $jobs `
        --speed $speed `
        -q $quality `
        --ignore-exif `
	--ignore-xmp `
        "$($_.FullName)" `
        "$outFile"

} -ThrottleLimit $threads
