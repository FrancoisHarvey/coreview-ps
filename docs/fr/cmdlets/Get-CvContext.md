# Get-CvContext

## Résumé

Obtient des informations sur la session actuelle dans un format machine.

## Description

Le cmdlet `Get-CvContext` obtient des informations sur la session actuelle
de l'opérateur connecté à l'API de CoreView. Les informations obtenues incluent
l'ID de session, l'ID de l'opérateur, le nom de l'opérateur, les rôles attribués
à l'opérateur, l'heure de début de la session, l'heure de fin de la session et
des informations supplémentaires sur l'environnement d'exécution. Ces
retournées au script appelant sous forme de [\[Hashtable\]]

<br>

## Syntaxe

```powershell
Get-CvContext [<CommonParameters>]
```

## Paramètres

Aucuns.

<br>

## Sortie

Une table de hachage contenant les clés suivantes:

- `ApiUrl`: L'URL de l'API principale de CoreView.
- `CompanyId`: L'ID de la compagnie sur CoreView.
- `CompanyName`: Le nom de la compagnie sur CoreView.
- `CoreFlowUrl`: L'URL de l'API pour CoreFlow.
- `ModuleName`: Le nom du module PowerShell.
- `OperatorDirectRoles`: Les rôles attribués directement à l'opérateur.
- `OperatorLanguage`: La langue d'affichage de l'opérateur.
- `OperatorName`: Le nom d'affichage de l'opérateur.
- `OperatorRoleGroups`: Les rôles attribués à l'opérateur par le biais de groupes.
- `OperatorRoles`: Tous les rôles attribués à l'opérateur.
- `OperatorUserId`: L'ID de l'opérateur CoreView.
- `OperatorUserName`: Le nom d'utilisateur de l'opérateur.
- `OperatorVTenants`: Les locataires virtuels attribués à l'opérateur.
- `OrgIdentity`: L'identité de l'organisation Microsoft sur CoreView.
- `OrgPortalSkus`: Les SKUs du portail de gestion attribués à la compagnie.
- `OrgRoles`: Les rôles de l'organisation sur CoreView.
- `OrgSubscriptionLevel`: Le niveau d'abonnement de l'organisation sur CoreView.
- `OrgType`: Le type d'organisation sur CoreView.
- `PortalAppName`: Le nom du portail de gestion CoreView.
- `PortalAppVersion`: La version du portail de gestion CoreView.
- `PSHostVersion`: La version de l'hôte PowerShell.
- `SessionAudience`: Les audiences de la session.
- `SessionExpiry`: L'heure d'expiration de la session.
- `SessionId`: L'ID de la session.
- `TenantId`: L'ID du locataire Microsoft.

<br>

## Exemples

### Exemple 1: Obtenir des informations sur la session actuelle

```powershell
$infos = Get-CvContext
```

En cas de succès, la commande devrait retourner une table de hachage contenant
les informations de la session courante.

<br>

## Voir aussi

- [Connect-CvAPI](fr/cmdlets/Connect-CvAPI.md) pour se connecter.

- [Disconnect-CvAPI](fr/cmdlets/Disconnect-CvAPI.md) pour se déconnecter.

- [Get-CvSessionInfo](fr/cmdlets/Get-CvSessionInfo.md) pour obtenir des détails
  sur la session actuelle dans un format lisible.

- [Get-CvOperator](fr/cmdlets/Get-CvOperator.md) pour obtenir des détails sur
  l'opérateur actuellement connecté dans un format machine.

[\[Hashtable\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4
