# Mode débogage

Le mode débogage est un mode spécial qui permet de voir les détails des appels
HTTPS effectués par les cmdlets CoreView. Ce mode est utile pour comprendre
comment les cmdlets interagissent avec l'API de CoreView et pour déboguer les
problèmes de connexion.

## Commutateur `-Debug`

Pour activer le mode débogage, ajoutez le commutateur `-Debug` à n'importe
quelle commande PowerShell du module. Par exemple:

```powershell
Connect-CvAPI -APIKey $CleApiSS -Debug
```

Le mode débogage affichera les détails de chaque appel HTTPS effectué par le
cmdlet, ainsi que les données reçues en retour.

## Commutateur `-Verbose`

Le mode débogage est différent du mode verbeux (`-Verbose`). Le mode verbeux
affiche des messages supplémentaires sur les opérations effectuées par les
cmdlets, mais ne montre pas les détails des appels HTTPS. Pour activer le mode
verbeux, ajoutez le commutateur `-Verbose` à n'importe quelle commande
PowerShell du module. Par exemple:

```powershell
Connect-CvAPI -APIKey $CleApiSS -Verbose
```

<br>

?> Il est possible d'activer les deux modes en même temps. Dans ce cas, les
   messages verbeux et les détails des appels HTTPS seront affichés.
