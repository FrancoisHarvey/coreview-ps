# Téléchargement

Le code source est distribué sous forme de fichier zip compressé.

?> Avant de commencer, veuillez vous assurer que vous satisfaites les prérequis.
   Voir l’article intitulé « [Prérequis](fr/prerequis.md) »

!> Avant de commencer, veuillez lire attentivement les conditions d'utilisation.
   Voir l’article intitulé « [Mises en garde](fr/mises-en-garde.md) »

## Licence

Ce projet (« CoreView-PS ») est distribué sous license
[MS-PL (Microsoft Public License)].

## Procéder au téléchargement

Numéro de build: v<span id="buildversion">~</span> (commit <a href="https://github.com/SanteQc/coreview-ps/commit/" id="commitid"></a>) <br>
Date de publication: <span id="builddate">~</span>

[Télécharger coreview-ps.zip](https://santeqc.github.io/coreview-ps/coreview-ps.zip ":class=button-primary")

<br>

## Suite

Vous pouvez maintenant procéder à l’installation de CoreView-PS.

[Suite: installation](fr/installation.md ":class=button")

<script>
    const buildversion = document.getElementById("buildversion");
    const builddate = document.getElementById("builddate");
    const commitid = document.getElementById("commitid");

    fetch("https://api.github.com/repos/SanteQc/coreview-ps/actions/workflows/wf_Windows_Core.yml/runs?per_page=1&branch=main&event=push&status=success")
        .then(response => response.json())
        .then(data => {
            const run = data.workflow_runs[0];
            buildversion.textContent = run.run_number;
            commitid.href += run.head_sha;
            commitid.textContent = run.head_sha.substring(0, 7);
            builddate.textContent = new Date(run.run_started_at).toLocaleDateString('fr-CA', { dateStyle: 'full' });
        });
</script>

[MS-PL (Microsoft Public License)]: https://opensource.org/licenses/MS-PL
