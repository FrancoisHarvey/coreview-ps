# Installation

## Prérequis

Avant de commencez, veuillez vous assurer que vous satisfaites les [prérequis].
<br>
Vous devez également avoir [téléchargé] le fichier zip du code source de
CoreView-PS.

## Décompression du module

Décompressez le fichier zip que vous avez téléchargé vers un répertoire de
votre choix.

> Dans cet exemple, nous utiliserons `C:\CoreView-PS` par simplicité, mais vous
> pouvez choisir un autre répertoire.

## Test de l'installation

Ouvrez une session PowerShell 7 et exécutez les commandes suivantes:

```powershell
# Importation du module CoreView-PS:
Import-Module 'C:\CoreView-PS\coreview-ps.psd1' -Force -Global  # modifiez le chemin au besoin

# Vérification de l'importation du module:
Get-Command -Module 'CoreView-PS'
```

En cas de succès, vous devriez voir la liste des commandes du module.

## Suite

Vous pouvez maintenant suivre le tutoriel pas à pas de CoreView-PS.

[Suite: tutoriel pas à pas](fr/tutoriel.md ":class=button")

[prérequis]: fr/prerequis.md
[téléchargé]: fr/telechargement.md
