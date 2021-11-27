# Intro

AllMyIT est un module Powershell permettant de configurer Windows et Windows Server avec un fichier JSON.

## Documentation

The documentation is build master branch. [HiteaFR.github.io/AllMyIT](https://HiteaFR.github.io/AllMyIT)

## Prérequis

Windows 10+ / Windows Server 2016+

## Installation

### PowerShell Gallery

```powershell
    Install-Module -Name AllMyIT
```

Page du Module: [powershellgallery.com/packages/AllMyIT](https://www.powershellgallery.com/packages/AllMyIT)

### Dépot Git

```powershell
    Git clone https://github.com/HiteaFR/AllMyIT.git

    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_LE_MODULE] -Force -Verbose
```

### Téléchargement

Télécharger la dernière version : [github.com/HiteaFR/AllMyIT/releases/latest](https://github.com/HiteaFR/AllMyIT/releases/latest)

```powershell

    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_LE_MODULE] -Force -Verbose
```

## Usage

```powershell
    # Lancer la confifuration à partir du fichier Json
    Ami -PSPath "CHEMIN_VERS_LE_FICHIER_JSON"
```

Voir toute la doc :: [HiteaFR.github.io/AllMyIT](https://HiteaFR.github.io/AllMyIT)
