<!--
Modèle de spécification : remplacer les champs entre crochets.
Le bloc DATA PROTECTION est repris sans modification du document de référence.
Les sauts de page et la mise en forme PDF nécessitent un moteur HTML/CSS.
Export de référence (Pandoc puis Google Chrome) depuis ce répertoire :
pandoc template-specification.md --from=markdown-smart --standalone --embed-resources --metadata title="Spécifications Fonctionnelles" --output=/tmp/template-specification.html
google-chrome --headless --no-pdf-header-footer --print-to-pdf="$PWD/template-specification.pdf" file:///tmp/template-specification.html
Le sommaire est volontairement vide ; ne pas activer l'option --toc à ce stade.
-->

<style>
@page {
  size: A4;
  margin: 8mm 15mm 18mm;
  @bottom-left {
    content: "Propriété de Bouygues Telecom - Diffusion INTERNE";
    font: bold 8pt Arial, sans-serif;
    border-top: 1px solid black;
  }
  @bottom-right {
    content: "Page " counter(page) " sur " counter(pages);
    font: bold 8pt Arial, sans-serif;
    border-top: 1px solid black;
  }
}
html { color: #000; background: #fff; }
body {
  max-width: 180mm;
  margin: 0 auto;
  padding: 8mm 0;
  font: 10pt/1.25 Arial, sans-serif;
}
body > header#title-block-header { display: none; }
h1, h2 { color: #000; font-weight: bold; }
h1 { margin: 0 0 8mm; font-size: 15pt; }
h2 { margin: 0; padding: 2mm; font-size: 10pt; text-align: center; }
p { margin: 0 0 3mm; }
table { display: table; width: 100%; margin: 0; overflow: visible; border-collapse: collapse; table-layout: fixed; }
table, th, td { box-sizing: border-box; }
th, td { border: 1px solid #000; padding: 2mm; vertical-align: top; overflow-wrap: anywhere; }
th { font-weight: bold; text-align: center; }
thead { display: table-header-group; }
tr { break-inside: avoid; }
.document-header { margin-bottom: 5mm; }
.document-header td { padding: 1mm; text-align: center; vertical-align: middle; font-weight: bold; }
.document-header .brand { width: 22%; }
.document-header .brand img { display: block; width: 34mm; max-width: 100%; height: auto; margin: auto; }
.document-header .document-kind { width: 56%; font-size: 11pt; }
.document-header .document-title { font-size: 15pt; }
.document-header .metadata { width: 22%; font-size: 11pt; }
.data-protection { border: 1px solid #000; padding: 2mm; }
.data-protection h2 { padding-top: 1mm; }
.data-protection .classification { text-align: center; }
.data-protection p { font-weight: bold; font-size: 9pt; margin-bottom: 3mm; }
.data-protection p:last-child { margin-bottom: 1mm; }
.versions h2, .signing h2 { border: 1px solid #000; border-bottom: 0; }
.versions table { font-size: 8pt; }
.versions th, .versions td { padding: 1mm; }
.versions th:nth-child(1) { width: 7%; }
.versions th:nth-child(2) { width: 12%; }
.versions th:nth-child(3) { width: 42%; }
.versions th:nth-child(4), .versions th:nth-child(5), .versions th:nth-child(6) { width: 13%; }
.versions td { height: 7mm; }
.signing { margin-top: 8mm; break-inside: avoid; }
.signing h2 { font-size: 9pt; }
.signing table { font-size: 9pt; }
.signing td { height: 22mm; }
.next-page { break-before: page; page-break-before: always; }
.references th:first-child { width: 12%; }
.references th:nth-child(2) { width: 68%; }
.references th:last-child { width: 20%; }
.references > table td { height: 8mm; }
@media screen {
  .next-page { margin-top: 15mm; padding-top: 8mm; border-top: 1px solid #888; }
}
@media print {
  body { max-width: none; margin: 0; padding: 0; }
}
</style>

<header class="document-header">
<table aria-label="En-tête du document">
<tbody>
<tr>
<td class="brand" rowspan="4"><img src="assets/bouygues-telecom.png" alt="Bouygues Telecom"></td>
<td class="document-kind">Spécifications Fonctionnelles</td>
<td class="metadata"></td>
</tr>
<tr>
<td class="document-title" rowspan="3">[TITRE DU DOCUMENT]</td>
<td class="metadata">DPPS</td>
</tr>
<tr><td class="metadata">V[VERSION]</td></tr>
<tr><td class="metadata">[JJ/MM/AAAA]</td></tr>
</tbody>
</table>
</header>

::: {.data-protection}

## DATA PROTECTION

::: {.classification}

**This document is classified at "CONFIDENTIAL".**

:::

**Consequently:**

**Its distribution must be strictly limited to recipients who have an operational need, as listed on the cover page.**  
**The distribution of this document in paper or electronic form is subject to specific rules outlined in the classification procedure and protection of information.**  
**Its communication to third parties is subject to the prior signature of a confidentiality agreement.**  
**This document should be stored in a locked cabinet or equivalent strong when it is not used.**  
**The availability of this document on a shared server or a collection of documents on the intranet is subject to the establishment of an individualized management of access rights and protection by a strong password encryption and its.**  
**The impressions of this document should be retrieved immediately.**  
**The extracts of this document should keep the same classification markings.**  
**All obsolete copies of this document must be destroyed using a shredder.**

:::

::: {.versions}

## VERSIONS HISTORY

| INDICE | DATE | LIST OF MODIFICIATIONS | WRITING | VERIF. | APPRO. |
| :---: | :---: | :--- | :---: | :---: | :---: |
| | | | | | |

:::

::: {.signing}

## DOCUMENT ESTABLISHED UNDER THE RESPONSIBILITY OF SIGNING

| WRITING | VERIFICATION | APPROVAL |
| :--- | :--- | :--- |
| **Nom :** [NOM]<br>**Visa :**<br>**Date :** [JJ/MM/AAAA] | **Nom :** [NOM]<br>**Visa :**<br>**Date :** [JJ/MM/AAAA] | **Nom :** [NOM]<br>**Visa :**<br>**Date :** [JJ/MM/AAAA] |

:::

::: {.next-page}

<header class="document-header">
<table aria-label="En-tête du document">
<tbody>
<tr>
<td class="brand" rowspan="4"><img src="assets/bouygues-telecom.png" alt="Bouygues Telecom"></td>
<td class="document-kind">Spécifications Fonctionnelles</td>
<td class="metadata"></td>
</tr>
<tr>
<td class="document-title" rowspan="3">[TITRE DU DOCUMENT]</td>
<td class="metadata">DPPS</td>
</tr>
<tr><td class="metadata">V[VERSION]</td></tr>
<tr><td class="metadata">[JJ/MM/AAAA]</td></tr>
</tbody>
</table>
</header>

# Table of contents {style="text-align: center;"}

<!-- Sommaire volontairement vide. -->

:::

::: {.next-page .references}

<header class="document-header">
<table aria-label="En-tête du document">
<tbody>
<tr>
<td class="brand" rowspan="4"><img src="assets/bouygues-telecom.png" alt="Bouygues Telecom"></td>
<td class="document-kind">Spécifications Fonctionnelles</td>
<td class="metadata"></td>
</tr>
<tr>
<td class="document-title" rowspan="3">[TITRE DU DOCUMENT]</td>
<td class="metadata">DPPS</td>
</tr>
<tr><td class="metadata">V[VERSION]</td></tr>
<tr><td class="metadata">[JJ/MM/AAAA]</td></tr>
</tbody>
</table>
</header>

# 1. Références

| Ref | Document Name | Link |
| :---: | :--- | :--- |
| | | |

:::