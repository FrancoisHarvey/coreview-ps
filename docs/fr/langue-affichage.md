# Langue d'affichage du module

Le module CoreView-PS supporte présentement les langues d'affichage suivantes:

- Français
- Anglais

La langue d'affichage est utilisée pour les messages d'erreur et les messages
d'information.

Le module détecte automatiquement la langue d'affichage de votre système à
l'aide de la variable magique `$PSUICulture`. Si la langue détectée sur votre
système n'est pas supportée par le module CoreView-PS, le module utilisera
l'anglais par défaut, mais il vous est toujours possible de la changer.

## Modification de la langue d'affichage

Pour modifier la langue d'affichage du module, vous pouvez utiliser cette
commande dans une session PowerShell 7:

```powershell
# Pour le français:
[Cultureinfo]::CurrentUICulture = (Get-Culture 'fr')

# Pour l'anglais:
[Cultureinfo]::CurrentUICulture = (Get-Culture 'en')
```

Pour modifier la langue d'affichage de manière permanente, vous pouvez ajouter
la commande dans votre profil PowerShell. Pour ce faire, vous pouvez utiliser
la commande suivante:

```powershell
Add-Content -Path $PROFILE -Value "[Cultureinfo]::CurrentUICulture = (Get-Culture 'fr')"
```

Vous pouvez aussi changer la langue d'affichage de votre système d'exploitation
Windows.
