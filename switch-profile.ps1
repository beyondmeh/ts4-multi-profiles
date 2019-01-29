if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$Username = $env:UserName
Set-Location -Path "C:\Users\$Username\Documents\Electronic Arts"
$Dirs = Get-ChildItem -Directory -Name -Exclude 'The Sims 4'

##
## Sanity Tests
##
If (Test-Path './The Sims 4') {
  If (-Not (Get-ChildItem -Directory | Where { $_.Attributes -match "ReparsePoint" } | Where { $_.Name -match 'The Sims 4'})) {
    Write-Error "ERROR: 'The Sims 4' is a directory and not a link, refusing to run to prevent data loss! Hint: Rename 'The Sims 4' folder to whatever you want your profile to be called"
    pause
    Exit(1)
  }
}
Else {
  If (($Dirs).Count -lt 1) {
    Write-Error "ERROR: No profiles directories found!"
    Write-Error "Hint: Run the game then exit, then rename 'The Sims 4' folder to whatever you want your profile to be called"
    pause
    Exit(1)
  }
  Else {
    # Create a symbolic link so the below doesn't fail
    New-Item -Path 'The Sims 4' -ItemType SymbolicLink -Value $Dirs[0] | Out-Null
  }
}

## END OF SANITY CHECKS

If (($Dirs).Count -eq 1) {
  cmd /c rmdir '.\The Sims 4\'
  New-Item -Path 'The Sims 4' -ItemType SymbolicLink -Value $Dirs | Out-Null

  Write-Output ""
  Write-Output "Found only one profile, so it was automatically selected: $Dirs"
}
ElseIf (($Dirs).Count -eq 2) {
  $CurrentProfile = Split-Path ((Get-Item '.\The Sims 4\').Target) -Leaf
  $ChangeTo = $Dirs | where {$_ -notmatch $CurrentProfile}

  cmd /c rmdir '.\The Sims 4\'
  New-Item -Path 'The Sims 4' -ItemType SymbolicLink -Value $ChangeTo | Out-Null

  Write-Output ""
  Write-Output "Switched profile to $ChangeTo"
}
ElseIf (($Dirs).Count -gt 2) {
  $PrettyDirs = ($Dirs) -join ", "

  DO {
    If ($ChangeTo) {
      Write-Output "ERROR: That profile does not exist!"
      Write-Output ""
    }
            
    Write-Output "Select a profile: $PrettyDirs"
    $ChangeTo = Read-Host -Prompt 'Profile?'
  }
  While (-Not ($Dirs -match $ChangeTo))

  cmd /c rmdir '.\The Sims 4\'
  New-Item -Path 'The Sims 4' -ItemType SymbolicLink -Value $ChangeTo | Out-Null
  
  Write-Output ""
  Write-Output "Switched profile to $ChangeTo"
}

Write-Output ""
pause