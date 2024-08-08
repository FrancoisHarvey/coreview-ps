# New-CvCfFlowExecution

## Résumé

Lance un flux de travail CoreView CoreFlow.

## Description

Le cmdlet `New-CvCfFlowExecution` lance un flux de travail CoreView CoreFlow
en utilisant les paramètres d'entrée spécifiés. Les paramètres d'entrée sont
spécifiques à chaque flux de travail CoreFlow et doivent être obtenus à l'aide
de la commande [Get-CvCfFlowInputParameters].

<br>

## Syntaxe

```powershell
New-CvCfFlowExecution [-FlowId] <Guid> [-InputParameters] <Hashtable> [<CommonParameters>]
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

### `-InputParameters <Hashtable>`

La charge utile contenant les valeurs des paramètres d'entrée requis par le
flux de travail CoreFlow. Les paramètres d'entrée sont spécifiques à chaque flux
de travail CoreFlow et doivent être obtenus à l'aide de la commande
[Get-CvCfFlowInputParameters].

La charge utile est un [\[Hashtable\]] dans laquelle chaque clé correspond à un
paramètre d'entrée et chaque valeur correspond à la valeur du paramètre.

<br>

## Sortie

Un [\[Guid\]] qui identifie de manière unique l'exécution du flux de travail
CoreFlow. Cet identifiant peut être utilisé pour suivre l'exécution du flux à
l'aide de la commande [Get-CvCfFlowExecution] ou à partir du portail de
CoreView.

<br>

## Exemples

### Exemple 1: Lancer un flux de travail CoreFlow

```powershell
$IdFlux = 'a3fe98e9-92e5-4576-ab9c-e01fcff85bba'

$ChargeUtile = @{
    UserPrincipalName          = 'marcel.untel@ssss.gouv.qc.ca'
    AcronymesEtablissements    = 'CCOMTL'
    Action                     = 'Ajout'
    AdresseCourrielPourErreurs = 'martine.untel@msss.gouv.qc.ca'
}

$IdExecution = New-CvCfFlowExecution -FlowId $IdFlux -InputParameters $ChargeUtile
```

En cas de succès, la commande devrait lancer le flux de travail CoreFlow et
retourner l'identifiant unique de l'exécution du flux. Cet identifiant peut être
utilisé pour suivre l'exécution du flux à l'aide de la commande
[Get-CvCfFlowExecution] ou à partir du portail de CoreView.

<br>

## Voir aussi

- [Get-CvCfFlowInputParameters] pour obtenir les paramètres d'entrée d'un flux
  de travail CoreFlow.

- [Wait-CvCfFlowExecution] pour attendre la fin de l'exécution d'un flux de
  travail CoreFlow.

- [Get-CvCfFlowExecution] pour obtenir des informations sur l'exécution d'un
  flux de travail CoreFlow.

[Get-CvCfFlowInputParameters]: fr/cmdlets/Get-CvCfFlowInputParameters.md
[Wait-CvCfFlowExecution]: fr/cmdlets/Wait-CvCfFlowExecution.md
[Get-CvCfFlowExecution]: fr/cmdlets/Get-CvCfFlowExecution.md

[\[Hashtable\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4
[\[Guid\]]: https://learn.microsoft.com/fr-ca/dotnet/api/system.guid?view=net-8.0
