# Invoke-CvCfRestMethod

## Résumé

Permet d'envoyer une requête HTTP à l'API CoreView CoreFlow.

## Description

Le cmdlet `Invoke-CvCfRestMethod` permet d'envoyer une requête HTTP à l'API
CoreView CoreFlow. Ce cmdlet est principalement utilisé par les autres cmdlets
pour lancer des flux de travail CoreFlow, mais il peut également être utilisé
pour effectuer d'autres opérations sur l'API CoreFlow.

!> Il est fortement déconseillé d'utiliser ce cmdlet directement, sauf si vous
   savez exactement ce que vous faites. Pour lancer un flux de travail CoreFlow,
   utilisez plutôt la commande [New-CvCfFlowExecution]. Les APIs de CoreView
   CoreFlow sont complexes et très peu documentées, et il est facile de faire
   des erreurs si vous n'êtes pas familier avec elles.

<br>

## Syntaxe

```powershell
Invoke-CvCfRestMethod [-Endpoint] <Uri> [-Method {Get | Post | Put | Delete | Patch}] [-SearchParams <Hashtable>] [-Body <Hashtable>] [-AsText] [<CommonParameters>]
```

## Paramètres

### `-Endpoint <Uri>`

Le paramètre `-Endpoint` permet de spécifier le point de terminaison de l'API
REST à appeler. L'URI fournie est relative à l'URI de base de l'API CoreView
CoreFlow. Par exemple, si la région du centre de données est `CAE`, l'URI de
base de l'API CoreView CoreFlow sera `https://coreflowcaeapi.coreview.com/`. La
valeur fournie à ce paramètre sera concaténée à l'URI de base pour former l'URI
complète. Ainsi, si vous passez la valeur `abc/def` à ce paramètre, l'URI
complète de l'appel sera `https://coreflowcaeapi.coreview.com/abc/def`.

Pour référence, vous pouvez obtenir l'URI de base de l'API CoreView CoreFlow en
utilisant la commande [Get-CvSessionInfo] ou [Get-CvContext].

### `-Method {Get | Post | Put | Delete | Patch}`

Le paramètre `-Method` permet de spécifier la méthode HTTP, aussi appelée verbe
HTTP, à utiliser pour l'appel. Les méthodes HTTP les plus couramment utilisées
sont les suivantes:

- `Get`: Utilisée pour récupérer des données.
- `Post`: Utilisée pour envoyer des données.
- `Put`: Utilisée pour remplacer des données.
- `Patch`: Utilisée pour mettre à jour partiellement des données.
- `Delete`: Utilisée pour supprimer des données.

Toutefois, CoreView n'utilise pas ces méthodes de manière conventionnelle et
certains appels peuvent utiliser des méthodes qui ne sont pas très intuitives ou
qui font le contraire de ce à quoi on pourrait s'attendre.

### `-SearchParams <Hashtable>`

Le paramètre `-SearchParams` permet de spécifier des paramètres de requête à
inclure dans l'URL de l'appel. Les paramètres de requête sont des paires
clé-valeur qui sont ajoutées à l'URL après le point d'interrogation (`?`) et
séparées par des `&`. Par exemple, si vous passez la table de hachage suivante
à ce paramètre:

```powershell
@{
    'param1' = 'value1'
    'param2' = 'value2'
}
```

Les paramètres de requête seront ajoutés à l'URL de la manière suivante:
`<Uri>?param1=value1&param2=value2`.

### `-Body <Hashtable>`

Le paramètre `-Body` permet de spécifier le corps, aussi appelé charge utile, de
la requête HTTP. Le corps de la requête contient les données à envoyer au
serveur. La valeur fournie à ce paramètre doit être une table de hachage
[\[Hashtable\]] contenant les données à envoyer. Les données seront sérialisées
en JSON avant d'être envoyées au serveur.

### `-AsText`

Le paramètre `-AsText` permet de spécifier que la réponse de la requête ne doit
pas être désérialisée en tant qu'objet JSON, mais retournée sous forme de texte
brut. Cela peut être utile si la réponse n'est pas un objet JSON valide ou si
vous avez besoin de manipuler le texte brut de la réponse.

<br>

## Sortie

Si la requête est réussie, le cmdlet retourne une table de hachage
[\[Hashtable\]] contenant les données de la réponse de l'API. La structure de
cette table de hachage dépend de l'API appelée et des données retournées par
cette API. Si la requête échoue, le cmdlet génère une erreur.

Si le paramètre `-AsText` est spécifié, le cmdlet retourne une chaîne de
caractères contenant le texte brut de la réponse de l'API plutôt qu'une table de
hachage.

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

$execution = Invoke-CvCfRestMethod -Endpoint "api/executions/${IdFlux}" -Method Post -Body $InputParameters
```

### Exemple 2: Exporter un flux de travail CoreFlow

```powershell
$IdFlux = 'a3fe98e9-92e5-4576-ab9c-e01fcff85bba'

$Params = @{
    include = 'Actions'
    edit    = $true
}

$flux = Invoke-CvCfRestMethod -Endpoint "api/workflows/${IdFlux}" -SearchParams $Params -Method Get -AsText
```

<br>

## Voir aussi

- [Invoke-CvRestMethod] pour envoyer des requêtes HTTP à l'API principal de
  CoreView.

[New-CvCfFlowExecution]: fr/cmdlets/New-CvCfFlowExecution.md
[Invoke-CvRestMethod]: fr/cmdlets/Invoke-CvRestMethod.md

[\[Hashtable\]]: https://learn.microsoft.com/fr-ca/powershell/module/microsoft.powershell.core/about/about_hash_tables?view=powershell-7.4
