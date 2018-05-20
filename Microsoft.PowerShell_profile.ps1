#######################################################
# Modules for import
#######################################################

# iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/mattparkes/PoShFuck/master/Install-TheFucker.ps1'))
Import-Module PoShFuck

# Install-Module Get-ChildItemColor -Scope CurrentUser
# Ensure that Get-ChildItemColor is loaded
Import-Module Get-ChildItemColor

# Install-Module posh-git -Scope CurrentUser
# Ensure posh-git is loaded
Import-Module -Name posh-git

# Install-Module -Name oh-my-posh -Scope CurrentUser -AllowClobber
# Ensure oh-my-posh is loaded
Import-Module -Name oh-my-posh

# Default the prompt to custom oh-my-posh theme
Set-Theme Paradox-rl

#######################################################
# General useful Windows-specific commands
#######################################################

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Helper function to change directory to my development workspace
# Change c:\ws to your usual workspace and everytime you type
# in cws from PowerShell it will take you directly there.
function cws { Set-Location ~\Documents\Projects }

function crt { Set-Location C:\ }

# Helper function to set location to the User Profile directory
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

function Update-File
{
    $file = $args[0]
    if($file -eq $null) {
        throw "No filename supplied"
    }

    if(Test-Path $file)
    {
        (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else
    {
        Add-Content $file $null
    }
}

Set-Alias touch Update-File

Set-Alias trash Remove-ItemSafely
function open($file) {
	ii $file
}

function reload-powershell-profile {
	& $profile
}

function get-path {
	($Env:Path).Split(";")
}

#######################################################
# Shell startup tasks
#######################################################

cd C:\