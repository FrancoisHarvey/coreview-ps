# Connect-CvAPI

## Résumé

Se connecte à l'API de CoreView à l'aide d'une clé d'API.

## Description

Le cmdlet `Connect-CvAPI` établit une connexion à l'API de CoreView en utilisant
une clé d'API. Cette clé d'API peut être obtenue en ouvrant un billet au Centre
de services: voir l'article [Obtention d'un compte d'API](fr/compte-api.md).

<br>

## Syntaxe

```powershell
Connect-CvAPI [-APIKey] <SecureString> [<CommonParameters>]
```

## Paramètres

### `-APIKey <SecureString>`

La clé d'API à utiliser pour se connecter à l'API de CoreView. La clé d'API
doit être une chaîne sécurisée [\[SecureString\]] pour protéger la
confidentialité de la clé. Pour convertir une chaîne en [\[SecureString\]] ,
utilisez la commande `ConvertTo-SecureString`:

```powershell
$CleApi = 'abcd1234efgh5678ijkl9012mnop3456qrst7890uvwx1234yzab5678cdef9012'
$CleApiSS = ConvertTo-SecureString -String $CleApi -AsPlainText -Force
```

<br>

## Sortie

Aucune.

<br>

## Exemples

### Exemple 1: Connexion à l'API de CoreView

```powershell
$CleApi = 'abcd1234efgh5678ijkl9012mnop3456qrst7890uvwx1234yzab5678cdef9012'
$CleApiSS = ConvertTo-SecureString -String $CleApi -AsPlainText -Force
Connect-CvAPI -APIKey $CleApiSS
```

<br>

## Voir aussi

- [Disconnect-CvAPI](fr/cmdlets/Disconnect-CvAPI.md) pour se déconnecter

- [Get-CvSessionInfo](fr/cmdlets/Get-CvSessionInfo.md) pour obtenir des détails sur la
  session actuelle dans un format lisible.

- [Get-CvContext](fr/cmdlets/Get-CvContext.md) pour obtenir des détails sur la session
  actuelle dans un format machine.

- [Get-CvOperator](fr/cmdlets/Get-CvOperator.md) pour obtenir des détails sur
  l'opérateur actuellement connecté dans un format machine.

[\[SecureString\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7.4
