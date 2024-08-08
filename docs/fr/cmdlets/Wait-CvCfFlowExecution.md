# Wait-CvCfFlowExecution

## Résumé

Attend la fin de l'exécution d'un flux de travail CoreView CoreFlow.

## Description

Le cmdlet `Wait-CvCfFlowExecution` attend la fin de l'exécution d'un flux de
travail CoreView CoreFlow. Le cmdlet bloque l'exécution du script courant
jusqu'à ce que le flux de travail CoreFlow soit terminé. Une fois le flux
terminé, le cmdlet cesse de bloquer l'exécution et le script continue.

<br>

## Syntaxe

```powershell
Wait-CvCfFlowExecution [-ExecutionId] <guid> [[-Interval] <int>] [[-Timeout] <int>] [<CommonParameters>]
```

## Paramètres

### `-ExecutionId <guid>`

L'identifiant unique de l'exécution du flux de travail CoreFlow à attendre. Cet
identifiant est retourné lors du lancement du flux de travail à l'aide de la
commande [New-CvCfFlowExecution]. L'identifiant est un GUID (Globally Unique
Identifier) qui identifie de manière unique l'exécution du flux. Cet identifiant
est une chaîne de caractères de 36 caractères, généralement sous la forme
`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

?> L'identifiant unique d'un flux de travail CoreFlow diffère de l'identifiant
   unique de l'exécution d'un flux. L'identifiant du flux est utilisé pour
   lancer le flux, tandis que l'identifiant de l'exécution est utilisé pour
   suivre l'exécution du flux.

### `-Interval <int>`

L'intervalle de temps en secondes entre chaque vérification de l'état de
l'exécution du flux. Par défaut, l'intervalle est de 5 secondes. L'intervalle
doit être un entier positif entre 5 et 600 secondes (10 minutes).

### `-Timeout <int>`

Le délai d'attente en secondes avant de considérer l'exécution du flux comme
échouée. Par défaut, le délai d'attente est de 1800 secondes (30 minutes). Le
délai d'attente doit être un entier positif entre 30 et 28800 secondes (8
heures).

<br>

## Sortie

Aucune.

<br>

## Exemples

### Exemple 1: Lancer un flux de travail CoreFlow et attendre la fin

```powershell
$IdFlux = 'a3fe98e9-92e5-4576-ab9c-e01fcff85bba'

$ChargeUtile = @{
    UserPrincipalName          = 'marcel.untel@ssss.gouv.qc.ca'
    AcronymesEtablissements    = 'CCOMTL'
    Action                     = 'Ajout'
    AdresseCourrielPourErreurs = 'martine.untel@msss.gouv.qc.ca'
}

$IdExecution = New-CvCfFlowExecution -FlowId $IdFlux -InputParameters $ChargeUtile

Wait-CvCfFlowExecution -ExecutionId $IdExecution

Write-Output "Le flux de travail CoreFlow a terminé de s'exécuter."
```

En cas de succès, la première commande devrait lancer le flux de travail
CoreFlow et retourner l'identifiant unique de l'exécution du flux. La deuxième
commande attendra ensuite la fin de l'exécution du flux avant de continuer
l'exécution du script.

<br>

## Voir aussi

- [New-CvCfFlowExecution] pour lancer un flux de travail CoreFlow.

- [Get-CvCfFlowExecution] pour obtenir des informations sur l'exécution d'un
  flux de travail CoreFlow.

[New-CvCfFlowExecution]: fr/cmdlets/New-CvCfFlowExecution.md
[Get-CvCfFlowExecution]: fr/cmdlets/Get-CvCfFlowExecution.md
