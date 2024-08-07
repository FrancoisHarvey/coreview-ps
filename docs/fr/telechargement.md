# Téléchargement

Le code source est distribué sous forme de fichier zip compressé.

?> Avant de commencer, veuillez vous assurer que vous satisfaites les prérequis.
   Voir l’article intitulé « [Prérequis](fr/prerequis.md) »

## Licence

Ce projet (« CoreView-PS ») est distribué sous license
[MS-PL (Microsoft Public License)].

## Procéder au téléchargement

Version actuelle: <span id="buildversion">~</span> <br>
Date de publication: <span id="builddate">~</span>

[Télécharger coreview-ps.zip](https://santeqc.github.io/coreview-ps/coreview-ps.zip ":class=button-primary")

<br>

## Suite

Vous pouvez maintenant suivre le tutoriel pas à pas pour installer et configurer
CoreView-PS.

[Suite: tutoriel pas à pas](fr/tutoriel.md ":class=button")

<script>
    const buildversion = document.getElementById("buildversion");
    const builddate = document.getElementById("builddate");

    fetch("https://api.github.com/repos/SanteQc/coreview-ps/actions/workflows/wf_Windows_Core.yml/runs?per_page=1&branch=main&event=push&status=success")
        .then(response => response.json())
        .then(data => {
            buildversion.textContent = data.workflow_runs[0].run_number;
            builddate.textContent = new Date(data.workflow_runs[0].run_started_at).toLocaleDateString('fr-CA', { dateStyle: 'full' });
        });
</script>

[MS-PL (Microsoft Public License)]: https://opensource.org/licenses/MS-PL
