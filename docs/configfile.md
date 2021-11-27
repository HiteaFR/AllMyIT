# Fichier de Config

Attention, les mots de passe son en clair dans le fichier de configuration.

La documentation s'applique seulement à la version 4.X

La documentation pour la version 5.X + n'est pas encore disponible

## Nom du fichier

Utilisez seulement des caractères AlphaNumériques.

## Installer section

### Install-Features

    "Install-Features": {

    "Features": [

    "Hyper-V",

    "Hyper-V-PowerShell",

    "Windows-Server-Backup"

    ]

    }

### Install-NiniteApps

    "Install-NiniteApps":  {

    "Apps": [

    "Firefox",

    "7zip"

    ]

    }

### Install-ChocoApps

    "Install-ChocoApps":  {

    "Apps": [

    "Firefox",

    "7zip"

    ]

    }

### Copy-FileApp

    "Copy-FileApp":  {

    "Path":  "PATH_TO_THE_FILE",

    "DesktopLink":  true

    }

### Install-ExeApp

    "Install-ExeApp":  {

    "Path":  "PATH_TO_THE_EXE",

    "SetupArgs":  "/silent"

    }

### Install-MsiApp

    "Install-ExeApp":  {

    "Path":  "PATH_TO_THE_MSI",

    "SetupArgs":  "/silent"

    }

## Settings section

### New-LocalAdmin

    "New-LocalAdmin": {

        "NewLocalAdmin": "Name",

        "Password": "Password"

    }

### Set-Network

    "Set-Network":  {

    "IPAddress":  "192.168.1.100",

    "PrefixLength":  "24",

    "DefaultGateway":  "192.168.1.254",

    "Dns":  "8.8.8.8"

    }

### Set-ConfigMode

    "Set-ConfigMode": {

        "Statut": true

    }

### Set-Accessibility

    "Set-Accessibility": {

        "Statut": true

    }
