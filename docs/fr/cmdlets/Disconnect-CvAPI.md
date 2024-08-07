# Disconnect-CvAPI

## Résumé

Se déconnecte de l'API de CoreView.

## Description

Le cmdlet `Disconnect-CvAPI` ferme la connexion à l'API de CoreView. Une fois
déconnecté, les commandes qui nécessitent une connexion à l'API de CoreView
ne fonctionneront plus.

<br>

## Syntaxe

```powershell
Disconnect-CvAPI [<CommonParameters>]
```

## Paramètres

Aucuns.

<br>

## Sortie

Aucune.

<br>

## Exemples

### Exemple 1: Déconnexion de l'API de CoreView

```powershell
Disconnect-CvAPI
```

<br>

## Voir aussi

- [Connect-CvAPI](fr/cmdlets/Connect-CvAPI.md) pour se connecter

- [Get-CvSessionInfo](fr/cmdlets/Get-CvSessionInfo.md) pour obtenir des détails sur la
  session actuelle dans un format lisible.

- [Get-CvContext](fr/cmdlets/Get-CvContext.md) pour obtenir des détails sur la session
  actuelle dans un format machine.

- [Get-CvOperator](fr/cmdlets/Get-CvOperator.md) pour obtenir des détails sur
  l'opérateur actuellement connecté dans un format machine.

[\[SecureString\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7.4
