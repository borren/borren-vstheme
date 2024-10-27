<#
    Buildscript used for local testing
    Sorry for the mess, but its all written ad-hoc, no real testing or prettyfing!
    /borren
#>
[CmdletBinding()]
param (
    $mode = 'dev',
    # Bootstrap if you wish to try installing any missing stuff
    [switch]$bootstrap
)

begin {
    # Init
    function Get-AppcmdVersion {
        param (
            [string]$appcmd
        )
        $appcmdPath = (Get-Command $appcmd -ErrorAction SilentlyContinue).Source
        if ($appcmdPath) {
            # try --version
            try {
                $version = & "$appcmd" --version
            }
            catch {
                write-error "--version not supported by '$($appcmd)'"
                # we can now return version from the actual executable if t has been set
                try {
                    $version = (Get-Command $appcmd -ErrorAction SilentlyContinue).Version.ToString()
                }
                catch {
                    write-error "cannot verify version on '$($appcmd)'"
                    return 0
                }
            }
            if ($version) {
                Write-Output "$appcmd Version: $version"
                return $version
            }
        }
        else {
            Write-Output "Command '$()' not found or installed"
            return 0
        }
    }
    function Get-VsCodeVersion {
        $vsCodePath = (Get-Command "code" -ErrorAction SilentlyContinue).Source
        if ($vsCodePath) {
            # Use VSCode command line tool to get the version
            $version = & "code" --version
            Write-Output "VSCode Version: $version"
        }
        else {
            Write-Output "Visual Studio Code is not installed."
        }
    }
    
    function Get-NodeJsVersion {
        $nodePath = (Get-Command "node" -ErrorAction SilentlyContinue).Source
        if ($nodePath) {
            # Get Node.js version
            $version = & "node" --version
            Write-Output "Node.js Version: $version"
        }
        else {
            Write-Output "Node.js is not installed."
        }
    }
    
    function Install-VsCode { 
        winget install XP9KHM4BK9FZ7Q -s msstore
    }
    function Get-fnmVersion {
        $fnmPath = (Get-Command "fnm" -ErrorAction SilentlyContinue).Source
        if ($fnmPath) {
            # Get fnm version
            $version = & "fnm" --version
            Write-Output "fnm Version: $version"
        }
        else {
            Write-Output "fnm is not installed, or you need to restart the shell/session"
        }
    }
    function Install-fnm {
        # fnm method
        # installs fnm (Fast Node Manager)
        winget install Schniz.fnm
        # Configuration steps needed in project folder
        # use Initialize-NodeJs
    }
    function Initialize-NodeJs {
        # requires fnm (Fast Node Manager)
        #winget install Schniz.fnm
        # configure fnm environment
        fnm env --use-on-cd | Out-String | Invoke-Expression
        # download and install Node.js
        fnm use --install-if-missing 20
        # verifies the right Node.js version is in the environment
        #node -v # should print `v20.18.0`
        # verifies the right npm version is in the environment
        #npm -v # should print `10.8.2`
    }
    function Install-NodeJs {
        # fnm method
        # installs fnm (Fast Node Manager)
        winget install Schniz.fnm
        # Configuration steps needed in project folder
        # use Initialize-NodeJs
    }
    function Install-NpmPackage {
        param (
            [Parameter(Mandatory = $true)]
            [string]$PackageName,
            [Parameter(Mandatory = $false)]
            [switch]$Global
        )
        # npm install -g @vscode/vsce
        if ($Global) {
            Write-Output "Installing npm package '$PackageName' globally..."
            npm install -g $PackageName
        }
        else {
            Write-Output "Installing npm package '$PackageName' locally..."
            npm install $PackageName
        }
    }
    
    function Update-NpmPackage { }
    function Test-NpmPackage { }
    function New-vsixPackage {
        & vsce package
        # myExtension.vsix generated
        
        # & vsce publish
        # <publisher id>.myExtension published to VS Code Marketplace
    }
    
    # Check prereqs and install them if not already installed.
    # Check for vscode and node
    if ((Get-AppcmdVersion -appcmd "code") -eq 0) {
        Write-Error "Could not find Visual Studio Code! Install it now with 'Install-VsCode'!"
        if ($bootstrap) {
            Install-VsCode
        }
    }
    # Check for npm package '@vscode/vsce'
    # Install-NpmPackage -PackageName '@vscode/vsce' -Global
    # if ($mode -eq 'prod') { $env:DOTNET_CLI_TELEMETRY_OPTOUT = 1 } else { $env:DOTNET_CLI_TELEMETRY_OPTOUT = 0 }
}
process {
    # The actual stuffing
}
end {
    # Cleanup
}
