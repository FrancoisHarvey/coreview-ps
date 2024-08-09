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

<section class="module-info">

Version du module: v<span class="module-version">0.0.0</span>+rev<span class="build-version">0</span>
(commit <a href="https://github.com/SanteQc/coreview-ps/commit/"></a>) <br>
Date de publication: <span class="build-date">samedi 28 juin 1969</span>

</section>

[Télécharger coreview-ps.zip](https://santeqc.github.io/coreview-ps/coreview-ps.zip ":class=button-primary")

<br>

## Suite

Vous pouvez maintenant procéder à l’installation de CoreView-PS.

[Suite: installation](fr/installation.md ":class=button")

<script>
(async () => {
    const moduleInfo = document.querySelector(".module-info");
    const moduleVersion = moduleInfo.querySelector(".module-version");
    const buildVersion = moduleInfo.querySelector(".build-version");
    const buildDate = moduleInfo.querySelector(".build-date");
    const commitId = moduleInfo.querySelector("a");

    const buildResultUrl = "https://api.github.com/repos/SanteQc/coreview-ps/actions/workflows/wf_Windows_Core.yml/runs?per_page=1&branch=main&event=push&status=success";
    const buildResult = await fetch(buildResultUrl).then(response => response.json());
    const run = buildResult.workflow_runs[0];

    buildVersion.textContent = run.run_number;
    commitId.href += run.head_sha;
    commitId.textContent = run.head_sha.substring(0, 7);
    buildDate.textContent = new Date(run.run_started_at).toLocaleDateString('fr-CA', { dateStyle: 'full' });

    const moduleManifestUrl = `https://raw.githubusercontent.com/SanteQc/coreview-ps/${run.head_sha}/src/coreview-ps/coreview-ps.psd1`;
    const manifestContent = await fetch(moduleManifestUrl).then(response => response.text());

    moduleVersion.textContent = manifestContent.match(/ModuleVersion += +'([0-9.]+)'/)[1];
})();
</script>

[MS-PL (Microsoft Public License)]: https://opensource.org/licenses/MS-PL
