


Function Add-EnvPath {
    # Adds a path to the $ENV:Path list for a user or system if it does not already exist (in both the system and user Path variables)
    param (
        [string]$Location,
        [string]$NewPath
    )

    $AllPaths = $Env:Path -split ';'
    if ($AllPaths -notcontains $NewPath) {
        Write-Output "Adding Utilties bin directory path to the environmental path list: $UtilBinPath"

        $NewPaths = (@(([Environment]::GetEnvironmentVariables($Location).GetEnumerator() | Where-Object {$_.Name -eq 'Path'}).Value -split ';') + $UtilBinPath | Select-Object -Unique) -join ';'

        [Environment]::SetEnvironmentVariable("PATH", $NewPaths, $Location)
    }
}


function Get-ChocoPackages {
    if (get-command clist -ErrorAction:SilentlyContinue) {
        clist -lo -r -all | ForEach-Object {
            $Name,$Version = $_ -split '\|'
            New-Object -TypeName psobject -Property @{
                'Name' = $Name
                'Version' = $Version
            }
        }
    }
}

function Add-Folders{

    $RootPath = "$env:systemdrive\Relativiy_Env"
    if(-not(Test-Path $RootPath)){
        
        New-Item -ItemType "directory" $RootPath | Out-Null

        $paths  = @(

            'Recopilacion de Informacion',
            'Analisis de Vulnerabilidades',
            'Analisis Aplicaciones Web',
            'Analisis Bases de Datos',
            'Ataques de Contraseña',
            'Herramientas de Explotacion',
            'Herramientas para Sniffing/Spoofing',
            'Herramientas para Ing. Social'


        )

            if ($paths.Count -gt 0) {
              
                $paths | Foreach-Object {
                New-Item -ItemType "directory" "$RootPath\$_" | Out-Null
            }
        }     
    }
}


function Get-DownloadManual($UtilDownloadPath, $UtilBinPath)
{

    [Net.ServicePointManager]::SecurityProtocol=[System.Security.Authentication.SslProtocols] "tls, tls11, tls12"
    
    $FilesDownloaded = @()

    If (-not (Test-Path $UtilDownloadPath)) {
        mkdir $UtilDownloadPath -Force
    }

    If (-not (Test-Path $UtilBinPath)) {
        mkdir $UtilBinPath -Force
    }
    
    Push-Location $UtilDownloadPath
    
    Foreach($software in $ManualDownloadInstall.keys) {
    
    Write-Output "Downloading $software"
    if ( -not (Test-Path $software) ) {
        try {
                Invoke-WebRequest $ManualDownloadInstall[$software] -OutFile $software -UseBasicParsing
                $FilesDownloaded += $software
        }
        catch {}
    }
    else {

            Write-Warning "File is already downloaded, skipping: $software"
        }
    }

    # msi installs
    Write-Output 'Extracting self-contained binaries (zip files) to our bin folder'
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.zip' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
    Expand-Archive -Path $_.FullName -DestinationPath $UtilBinPath -Force
    }

    # msi installs
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.exe' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
    Start-Proc -Exe $_.FullName -waitforexit
    }

    # msi installs
    Get-ChildItem -Path $UtilDownloadPath -File -Filter '*.msi' | Where-Object {$FilesDownloaded -contains $_.Name} | ForEach-Object {
    Start-Proc -Exe $_.FullName -waitforexit
    }


}



