# -------------------------------------------------------
#  Automatic VirtioFS + WinFsp + SPICE setup for Windows
#  Downloads installers + installs
#  Run as Administrator
# -------------------------------------------------------

$VUrl          = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio"
$VGtUrl        = "$VUrl/virtio-win-gt-x64.msi"
$VGuessTUrl    = "$VUrl/virtio-win-guest-tools.exe"
$WinFspUrl     = "https://github.com/winfsp/winfsp/releases/download/v2.1/winfsp-2.1.25156.msi"
$SpiceToolsUrl = "https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe"

# Create temp dir
$dir = "$env:TEMP\virtio_setup"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

Write-Host "`nDownloading VirtIO GT..." -ForegroundColor Cyan
curl.exe -L "$VGtUrl" -o "$dir\virtio-win-gt-x64.msi"

Write-Host "`nInstalling VirtIO GT..." -ForegroundColor Cyan
$p1 = Start-Process "msiexec.exe" -Verb RunAs -ArgumentList "/i `"$dir\virtio-win-gt-x64.msi`"", "/quiet", "/passive", "/qn", "/norestart" -Wait -PassThru;
$p1.WaitForExit()
if( $p1.ExitCode -eq 0 ){
    Write-Host "VirtIO GT installation succeeded" -ForegroundColor Green
}else{
    Write-Host "VirtIO GT installation failed" -ForegroundColor Red
}

Write-Host "`nDownloading VirtIO Guest Tools..." -ForegroundColor Cyan
curl.exe -L "$VGuessTUrl" -o "$dir\virtio-win-guest-tools.exe"

Write-Host "`nInstalling VirtIO Guest Tools..." -ForegroundColor Cyan
$p2 = Start-Process "$dir\virtio-win-guest-tools.exe" -Verb RunAs -ArgumentList "/quiet", "/passive", "/S", "/s", "/qn", "/norestart" -Wait -PassThru;
$p2.WaitForExit()
if( $p2.ExitCode -eq 0 ){
    Write-Host "VirtIO Guest Tools installation succeeded" -ForegroundColor Green
}else{
    Write-Host "VirtIO Guest Tools installation failed" -ForegroundColor Red
}

Write-Host "`nDownloading WinFsp..." -ForegroundColor Cyan
curl.exe -L "$WinFspUrl" -o "$dir\winfsp.msi"

Write-Host "`nInstalling WinFsp..." -ForegroundColor Cyan
$p3 = Start-Process "msiexec.exe" -Verb RunAs -ArgumentList "/i `"$dir\winfsp.msi`"", "/quiet", "/passive", "/qn", "/norestart" -Wait -PassThru;
$p3.WaitForExit()
if( $p3.ExitCode -eq 0 ){
    Write-Host "WinFsp installation succeeded" -ForegroundColor Green
}else{
    Write-Host "WinFsp installation failed" -ForegroundColor Red
}

Write-Host "`nDownloading Spice Guest Tools..." -ForegroundColor Cyan
curl.exe -L "$SpiceToolsUrl" -o "$dir\spice-guest-tools.exe"

Write-Host "`nInstalling Spice Guest Tools..." -ForegroundColor Cyan
$p4 = Start-Process "$dir\spice-guest-tools.exe" -Verb RunAs -ArgumentList "/quiet", "/passive", "/S", "/s", "/qn", "/norestart" -Wait -PassThru;
$p4.WaitForExit()
if( $p4.ExitCode -eq 0 ){
    Write-Host "Spice Guest Tools installation succeeded" -ForegroundColor Green
}else{
    Write-Host "Spice Guest Tools installation failed" -ForegroundColor Red
}

Write-Host "`nEnabling and starting the VirtIO-FS Service..." -ForegroundColor Cyan
$serviceName = "VirtioFsSvc"
Set-Service   -Name $serviceName -StartupType Automatic -ErrorAction SilentlyContinue
Start-Service -Name $serviceName -ErrorAction SilentlyContinue
Write-Host "VirtIO-FS Service enabled and started successfully" -ForegroundColor Green

Write-Host "`nDone! VirtIO drivers + VirtIO Guest Tools + WinFsp + Spice Guest Tools installed.`n" -ForegroundColor Cyan
Write-Host "`nPlease reboot to apply the changes`n" -ForegroundColor Cyan
