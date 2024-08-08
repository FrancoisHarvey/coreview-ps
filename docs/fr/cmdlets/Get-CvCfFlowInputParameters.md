# Get-CvCfFlowInputParameters

## Résumé

Obtient les paramètres d'entrée pour un flux de travail CoreView CoreFlow.

## Description

Le cmdlet `Get-CvCfFlowInputParameters` obtient les paramètres d'entrée pour un
flux de travail CoreView CoreFlow. Les paramètres d'entrée correspondent aux
champs requis ou optionnels que l'utilisateur doit fournir pour exécuter un
flux de travail CoreFlow via le portail de CoreView.

<br>

## Syntaxe

```powershell
Get-CvCfFlowInputParameters [-FlowId] <Guid> [<CommonParameters>]
```

## Paramètres

### `-FlowId <Guid>`

L'identifiant unique du flux de travail CoreFlow pour lequel les paramètres
d'entrée doivent être obtenus. L'identifiant du flux de travail CoreFlow est
un GUID (Globally Unique Identifier) qui identifie de manière unique le flux.

Pour obtenir l'identifiant unique du flux, vous devez trouver le flux dans le
portail de CoreView et vous rendre sur la page de détails du flux. Vous y
trouverez le nom, la date de mise à jour et l'identifiant unique du flux. Pour
référence, l'identifiant unique d'un flux est une chaîne de caractères de 36
caractères, généralement sous la forme `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

<br>

## Sortie

Aucune, mais les paramètres d'entrée du flux de travail CoreFlow sont affichés
dans la console.

<br>

## Exemples

### Exemple 1: Obtenir les paramètres d'entrée pour un flux de travail CoreFlow

```powershell
Get-CvCfFlowInputParameters -FlowId 'a3fe98e9-92e5-4576-ab9c-e01fcff85bba'
```

Cette commande obtient les paramètres d'entrée pour le flux de travail CoreFlow
ayant l'identifiant unique `a3fe98e9-92e5-4576-ab9c-e01fcff85bba` et les affiche
en console:

```plaintext
[ UserPrincipalName ]

Nom du paramètre : UserPrincipalName
Nom d'affichage  : Nom d’utilisateur principal
Type             : chaîne de caractères de type userprincipalnames
Est obligatoire  : Oui


[ AcronymesEtablissements ]

Nom du paramètre         : AcronymesEtablissements
Description du paramètre : Veuillez sélectionner l'établissement à ajouter ou retirer
Valeurs autorisées       : 3CHUM, CCOMTL, CCSMTL, CEMTL, CHUM, CHUQ, CHUSJ, CISSSAT, CISSSBSL, CISSSCA, CISSSCN,
                           CISSSdesIles, CISSSG, CISSSLAN, CISSSLAU, CISSSLAV, CISSSM, CISSSMC, CISSSME, CISSSMO,
                           CISSSO, CIUSSSCN, CIUSSSECHUS, CIUSSSMCQ, CIUSSSSLSJ, CLSCNSKP, CNMTL, COMTL, Conseil-Cri,
                           CPNSSS, CRSSSBJ, CSFV, CSInuulitsivik, CSTulattavik, CUSM, ICM, INESSS, INPLPP, INSPQ,
                           IUCPQ-UL, MED, MSSS, MSSS-BSM, MSSS-RAMQ, MSSS-RFP, REGMTL, RRSSSNunavik, SanteQc
Type                     : chaîne de caractères parmi les valeurs autorisées
Est obligatoire          : Oui


[ Action ]

Nom du paramètre         : Action
Nom d'affichage          : Action
Description du paramètre : S'agit-t-il d'un ajout ou d'un retrait?
Valeurs autorisées       : Ajout, Retrait
Type                     : chaîne de caractères parmi les valeurs autorisées
Est obligatoire          : Oui


[ AdresseCourrielPourErreurs ]

Nom du paramètre         : AdresseCourrielPourErreurs
Description du paramètre : Inscrire une adresse courriel pour recevoir les messages d'erreur
Type                     : chaîne de caractères
Est obligatoire          : Oui
```

<br>

## Voir aussi

- [New-CvCfFlowExecution](fr/cmdlets/New-CvCfFlowExecution.md) pour exécuter un flux de
  travail CoreFlow.
