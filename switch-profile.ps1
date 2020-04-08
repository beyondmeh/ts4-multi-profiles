
$Username = $env:UserName
$SimsDir = "C:\Users\$Username\Documents\Electronic Arts"

If (Test-Path "$SimsDir/The Sims 4") {
    If (-Not (Get-ChildItem -Directory | Where { $_.Attributes -match "ReparsePoint" } | Where { $_.Name -match 'The Sims 4'})) {
        $msg = -join(
                "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('", 
                $SimsDir, "\The Sims 4`n", 
                "already exists as a normal directory.`n`n",
                "To prevent data loss nothing has been changed.'",
                ", 'Error', 'OK', 'Error')"
            )
            PowerShell -Command $msg
            exit 1
    }
}


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Sims 4 Profile'
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a Sims 4 profile:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(360,20)
$listBox.Height = 80

# Get all the directories other than "The Sims 4" so we can display them as potential profiles
Set-Location -Path $SimsDir
$Dirs = Get-ChildItem -Directory -Name -Exclude 'The Sims 4'

# add each directory to the select box
foreach ($Dir in $Dirs) {
    [void] $listBox.Items.Add($Dir)
}

$form.Controls.Add($listBox)
$form.Topmost = $true

# Process the selected profile
$result = $form.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $x = $listBox.SelectedItem

    # If the Sims directory already exists, and it's a symlink, delete it so we can change it
    If (Test-Path './The Sims 4') {
        If ((Get-ChildItem -Directory | Where { $_.Attributes -match "ReparsePoint" } | Where { $_.Name -match 'The Sims 4'})) {
            cmd /c rmdir '.\The Sims 4\'
        } 
    }

    # Windows allows non-admins to create symlinks, but PS uses a old API that doesn't allow for that. 
    # Instead, call cmd.exe and run mklink, which doesn't need an elevated PS session
    #
    # Normally you would do this in an elevated PS session:
    #   New-Item -Path 'The Sims 4' -ItemType SymbolicLink -Value $x
    $cmd = -join('mklink /J "', $SimsDir, '/The Sims 4" "', $SimsDir, '/', $x, '"')
    cmd.exe /c "$cmd"
}
