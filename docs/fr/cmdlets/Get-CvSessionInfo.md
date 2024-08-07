# Get-CvSessionInfo

## Résumé

Obtient des informations sur la session actuelle.

## Description

Le cmdlet `Get-CvSessionInfo` obtient des informations sur la session actuelle
de l'opérateur connecté à l'API de CoreView. Les informations obtenues incluent
l'ID de session, l'ID de l'opérateur, le nom de l'opérateur, les rôles attribués
à l'opérateur, l'heure de début de la session, l'heure de fin de la session et
des informations supplémentaires sur l'environnement d'exécution.

<br>

## Syntaxe

```powershell
Get-CvSessionInfo [<CommonParameters>]
```

## Paramètres

Aucuns.

<br>

## Sortie

Aucune, mais affiche les informations de la session actuelle dans la console.

<br>

## Exemples

### Exemple 1: Obtenir des informations sur la session actuelle

```powershell
Get-CvSessionInfo
```

En cas de succès, la commande devrait afficher les informations de la session
courante dans le terminal. Voici un apperçu de ce à quoi peut ressembler la
sortie:

```plaintext
[ Informations sur CoreView ]

Fichier de configuration statique : https://app.coreview.com/assets/configuration/environment.json
Nom du portail de gestion         : prodneu
Version du portail de gestion     : 1.0.2320.0001
API principale                    : https://caeapi.4ward365.com/
API CoreFlow                      : https://coreflowcaeapi.coreview.com/


[ Informations sur l'organisation ]

ID du locataire              : 06e18e28-5f8b-4075-bfff-ae24be1a7992
Nom de la compagnie          : Contoso
ID de la compagnie           : e4a76b95f2dffbb318afa19967b9229c
Centre de données CoreView   : CAE
Identité de l'organisation   : contoso.onmicrosoft.com
Type d'organisation          : Customer
Niveau d'abonnement CoreView : PRODUCTION
Rôles de l'organisation      : Reseller
SKUs du portail              : SKU:COREDISCOVERY, MGT:RUNSPACES:7, FT:EXONLINE, FT:SKIPPSRECONNECT, FT:GROUPSOPERATORSBULK, FT:RESEXONPREM, FT:USEREXENRICHMENT, FT:CSVEXPORT, FT:CUSTOMACTIONAPPROVAL,
                               FT:SKYPEPHONENUMBERSSYNC, FT:SPOONLINE, FT:USERCARDV2, FT:RABBITSTREAM, FT:EXIMPORTDATASTREAM, FT:BETAGRAPHMGMT, FT:MANAGEACTIONWFITEMFROMAPI, FT:CVWEBHOOK,
                               FT:GRAPHSERVICEMGMT, WF:RUNSPACES:500, FT:HYBRIDOS2019, FT:EXIMPORTUSER, FT:HOMEGOVERNANCE, FT:WFSHOWFILTER, FT:APIKEYOPERATOR, CSKU:ONPREM, SKU:ONPREM, FT:EDITPOLICY,
                               CSKU:ENTERPRISE, SKU:ENTERPRISE, FT:NEWUX, FT:PLAYBOOK, SKU:WFV2, SKU:PLAYBOOKS, FT:ROLESENTERPRISE, FT:SHOWPOLICYCREATION, FT:SHOWFILTERTAB, FT:SHOWGSEARCH,
                               FT:SHOWPERMISSIONS, FT:SHOWLPVT, FT:SHOWLTEMP, FT:SERVICENOW, FT:SIEMINTEGRATION, SKU:COREREPORTING, CSKU:CORETEAMS, SKU:CORETEAMS, CSKU:AUDIT, SKU:AUDIT, FT:ROLESAUDIT,
                               SKU:SEC, FT:MSAUDITLOG, FT:HASHVTENABLED, FT:CUSTOMREPORTS


[ Informations sur l'opérateur connecté ]

ID de l'utilisateur           : 1234
Nom d'utilisateur             : juliette.untel@ssss.gouv.qc.ca
Nom d'affichage               : Juliette Untel
Rôles attribués               : Management, User
Locataires virtuels attribués : 010000, 020000
Langue d'affichage            : English


[ Informations sur la session ]

ID de session : Bg9z8gpZxuT5Bvc9YjQ2
Expiration    : 8/8/2024 5:37:00 PM +00:00
Audience      : EU, EUS, CAE, AUS


[ Informations sur l'environnement ]

Version de l'hôte PowerShell : 7.4.4
Nom du module                : coreview-ps
Version du module            : 2.0.0
```

<br>

## Voir aussi

- [Connect-CvAPI](fr/cmdlets/Connect-CvAPI.md) pour se connecter.

- [Disconnect-CvAPI](fr/cmdlets/Disconnect-CvAPI.md) pour se déconnecter.

- [Get-CvContext](fr/cmdlets/Get-CvContext.md) pour obtenir des détails sur la session
  actuelle dans un format machine.

- [Get-CvOperator](fr/cmdlets/Get-CvOperator.md) pour obtenir des détails sur
  l'opérateur actuellement connecté dans un format machine.
