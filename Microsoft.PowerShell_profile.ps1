Clear-Host

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

# Reload the Shell
function Reload-Powershell {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "pwsh";
    $newProcess.Arguments = "-nologo";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
}

function get-path {
	($Env:Path).Split(";")
}

# Extract a .zip file
function Unzip-File {
    <#
    .SYNOPSIS
       Extracts the contents of a zip file.
    .DESCRIPTION
       Extracts the contents of a zip file specified via the -File parameter to the
    location specified via the -Destination parameter.
    .PARAMETER File
        The zip file to extract. This can be an absolute or relative path.
    .PARAMETER Destination
        The destination folder to extract the contents of the zip file to.
    .PARAMETER ForceCOM
        Switch parameter to force the use of COM for the extraction even if the .NET Framework 4.5 is present.
    .EXAMPLE
       Unzip-File -File archive.zip -Destination .\d
    .EXAMPLE
       'archive.zip' | Unzip-File
    .EXAMPLE
        Get-ChildItem -Path C:\zipfiles | ForEach-Object {$_.fullname | Unzip-File -Destination C:\databases}
    .INPUTS
       String
    .OUTPUTS
       None
    .NOTES
       Inspired by:  Mike F Robbins, @mikefrobbins
       This function first checks to see if the .NET Framework 4.5 is installed and uses it for the unzipping process, otherwise COM is used.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$File,

        [ValidateNotNullOrEmpty()]
        [string]$Destination = (Get-Location).Path
    )

    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    if (($PSVersionTable.PSVersion.Major -ge 3) -and
       ((Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -like "4.5*" -or
       (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -like "4.5*")) {

        try {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    } else {
        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
}

#######################################################
# Aliases
#######################################################

Set-Alias trash Remove-ItemSafely

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Navigation Shortcuts
${function:dt} = { Set-Location ~\Desktop }
${function:docs} = { Set-Location ~\Documents }
${function:dl} = { Set-Location ~\Downloads }
${function:proj} = { Set-Location D:\Projects }
${function:croot} = { Set-Location C:\ }

# linux aliases
function touch($file) { "" | Out-File $file -Encoding ASCII }
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function open($file) {
	ii $file
}

# Create a new directory and enter it
Set-Alias mkd CreateAndSet-Directory
# Reload the shell
Set-Alias reload Reload-Powershell

#######################################################
# Shell startup tasks
#######################################################
