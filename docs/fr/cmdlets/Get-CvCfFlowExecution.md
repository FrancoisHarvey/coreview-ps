# Get-CvCfFlowExecution

## Résumé

Obtient l'état et les données en retour d'une exécution de flux de travail
CoreView CoreFlow.

## Description

Le cmdlet `Get-CvCfFlowExecution` permet d'obtenir l'état d'une exécution de
flux CoreView CoreFlow, le message d'erreur, si applicable, et les données en
retour, le cas échéant.

<br>

## Syntaxe

```powershell
Get-CvCfFlowExecution [-ExecutionId] <guid> [<CommonParameters>]
```

## Paramètres

### `-ExecutionId <guid>`

L'identifiant unique de l'exécution du flux de travail CoreFlow à vérifier. Cet
identifiant est retourné lors du lancement du flux de travail à l'aide de la
commande [New-CvCfFlowExecution]. L'identifiant est une chaîne de caractères de
36 caractères, généralement sous la forme
`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

?> L'identifiant unique d'un flux de travail CoreFlow diffère de l'identifiant
   unique de l'exécution d'un flux. L'identifiant du flux est utilisé pour
   lancer le flux, tandis que l'identifiant de l'exécution est utilisé pour
   suivre l'exécution du flux.

<br>

## Sortie

Une table de hachage [\[Hashtable\]] contenant les propriétés suivantes:

```plaintext
Status           :  "Failed" | "Succeeded" | "Finished" | "Running"
Error            :  Cause de l'erreur, si le flux a échoué.
Input            :  Paramètres donnés en entrée au flux.
ExecutionHistory :  Liste des étapes de l'exécution du flux retournant des
                    données. Cette propriété peut être utilisée pour obtenir
                    les résultats de l'exécution du flux, tels que visibles dans
                    le portail de CoreView.
```

<br>

## Exemples

### Exemple 1: Flux qui a échoué

```powershell
$IdExecution = 'a0aa7a75-dfa3-4dff-9e65-8b0ef957aaae'

$Etat = Get-CvCfFlowExecution -ExecutionId $IdExecution
```

Cette commande retourne une table de hachage [\[Hashtable\]] contenant l'état de
l'exécution du flux, le message d'erreur et les données en retour. <br> Lorsque
convertit en JSON, le résultat ressemble à ceci:

```json
{
    "ExecutionId": "a0aa7a75-dfa3-4dff-9e65-8b0ef957aaae",
    "FlowId": "a3fe98e9-92e5-4576-ab9c-e01fcff85bba",
    "Status": "Failed",
    "Error": {
        "StepName": "Arrêter le flux si le nouvel établissement est interdit",
        "Details": "Action execution timed out",
        "Message": "States.Timeout",
        "Cause": "Workflow execution failed"
    },
    "Input": {
        "UserPrincipalName": "maxime.untel.med@ssss.gouv.qc.ca",
        "AcronymesEtablissements": "CISSSAT",
        "Action": "Ajout",
        "AdresseCourrielPourErreurs": "solange.untel@ssss.gouv.qc.ca"
    },
    "ExecutionHistory": [
        {
            "Output": {
                "NoPermis": "E12345678",
                "LstAncienNoPermis": [],
                "Identifiant": "EXT",
                "LstEtablissements": [
                    "CUSM"
                ],
                "Attribut11Canonique": "EXT-E12345678-CUSM-",
                "Etablissements": "CUSM",
                "NouvelleValeurAttribut11": "EXT-E12345678-CUSM-",
                "AncienNoPermis": ""
            },
            "StepName": "Extraire l'ancien attribut 11"
        },
        {
            "Output": {
                "Erreur": "Le code de médecin `EXT-E12345678-CISSSAT/CUSM-` est invalide : \nL'acronyme d'établissement `CISSSAT` n'est pas permis. Seuls les établissements suivants sont autorisés: CHUQ, CIUSSSECHUS, CHUM, CUSM.\nVeuillez consulter la nomenclature de l'attribut 11 pour connaître les modalités qui s'appliquent aux comptes externes."
            },
            "StepName": "Évaluer les problèmes avec l'ajout"
        }
    ]
}
```

<br>

## Voir aussi

- [Get-CvCfFlowInputParameters] pour obtenir les paramètres d'entrée d'un flux
  de travail CoreFlow.

- [New-CvCfFlowExecution] pour lancer un flux de travail CoreFlow.

- [Wait-CvCfFlowExecution] pour attendre la fin de l'exécution d'un flux de
  travail CoreFlow.

[Get-CvCfFlowInputParameters]: fr/cmdlets/Get-CvCfFlowInputParameters.md
[Wait-CvCfFlowExecution]: fr/cmdlets/Wait-CvCfFlowExecution.md
[New-CvCfFlowExecution]: fr/cmdlets/New-CvCfFlowExecution.md

[\[Hashtable\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4
