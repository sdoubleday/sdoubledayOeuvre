PARAM([Switch]$SuppressBootstrap)
write-verbose "Setup (running $PsCommandPath)..." -Verbose

<#sdoubledayOeuvre has a script for git configuring username and email, and runs it for itself and all its direct submodules.#>
$usernamefilename = '.\gitignore_username.txt'
$useremailfilename = '.\gitignore_useremail.txt'
IF (-not (Test-Path $usernamefilename) ) {New-item -ItemType File -Name $usernamefilename -Value 'UserName'; Start-Process -Wait NotePad -ArgumentList $usernamefilename}
IF (-not (Test-Path $useremailfilename) ) {New-item -ItemType File -Name $useremailfilename -Value 'UserEmail'; Start-Process -Wait NotePad -ArgumentList $useremailfilename}

$username = Get-Content $usernamefilename
$useremail = Get-Content $useremailfilename

$gitUserConfigScriptPath = Get-ChildItem .\gitUserConfig.ps1 | Select-Object -ExpandProperty FullName

. $gitUserConfigScriptPath
If (-not $SuppressBootstrap.IsPresent) {
write-verbose "Running bootstrap..." -Verbose
. .\bootstrap.ps1
}
ELSE {write-verbose "Bootstrap suppressed." -Verbose}

Get-ChildItem -Directory | Get-ChildItem -filter setup.ps1 | ForEach-Object { Push-Location; Set-Location (Split-Path -Parent $_.Fullname); . $gitUserConfigScriptPath; . ".\$($_.Name)" -SuppressBootstrap ; Pop-Location }

write-verbose "Done ($PsCommandPath)." -Verbose
