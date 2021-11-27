# Intro

AllMyIT est un module Powershell permettant de configurer Windows et Windows Server avec un fichier JSON.

Venez nous soutenir sur les Réseaux et Youtube :)

- [Hitea.fr](https://hitea.fr/)
- [Youtube](https://www.youtube.com/channel/UCt30dovkjqINMeh0p5DUoVQ?sub_confirmation=1)
- [Facebook](https://www.facebook.com/hitea.fr)
- [Twitter](https://twitter.com/HiteaFR)
- [Linkedin](https://www.linkedin.com/company/hitea-fr)
- [GitHub](https://github.com/HiteaFR)

## Documentation

Toute la documentation: [HiteaFR.github.io/PsPassManager](https://HiteaFR.github.io/PsPassManager)

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
