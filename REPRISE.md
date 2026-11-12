# Reprise des travaux - Specifications des offres

Derniere mise a jour : 12/11/2026.

Ce fichier est une synthese de reprise de la conversation, pas une transcription
integrale. Il rassemble les decisions confirmees, les livrables et les questions
encore ouvertes. Les annotations presentes dans la specification restent la
reference detaillee pour les points a traiter.

## Archive des echanges

La conversation textuelle est sauvegardee dans
[offers/archive/echanges-2026-11-10.md](offers/archive/echanges-2026-11-10.md) :
35 demandes utilisateur et 221 segments de texte visibles de l'assistant,
depuis le depannage de MarkItDown jusqu'a la demande de sauvegarde.

Il s'agit d'un instantane, sans les sorties d'outils, les images ni les donnees
internes de l'assistant. Le dernier echange etait encore en cours lors de
l'export ; les messages posterieurs ne sont pas ajoutes automatiquement.
Pour reprendre les decisions en vigueur, lire d'abord le present fichier.

## Objectif

L'utilisateur est architecte de solutions. Il souhaite rediger et maintenir des
specifications en Markdown, puis generer des PDF partageables et exploitables par
les equipes de developpement et de test.

Le travail en cours porte sur le service d'offres de souscription STBL / nPFS /
DALI. La v2.2 sert a ameliorer le fond et l'organisation, a partir de la v2.1
validee.

## Fichiers et commandes

| Element | Emplacement et role |
| --- | --- |
| Template partage | [template/template-specification.md](template/template-specification.md) : presentation d'entreprise a reutiliser, sans la recreer. |
| Apercu du template | [template/template-specification.pdf](template/template-specification.pdf). |
| Reference validee | [offers/subscriptions-offers-v2.1.md](offers/subscriptions-offers-v2.1.md) et [PDF v2.1](offers/subscriptions-offers-v2.1.pdf) : a conserver inchanges. |
| Version de travail | [offers/subscriptions-offers-v2.2.md](offers/subscriptions-offers-v2.2.md) et [PDF v2.2](offers/subscriptions-offers-v2.2.pdf). |
| Brouillon de reorganisation | [offers/subscriptions-offers-v2.2-reorganisee.md](offers/subscriptions-offers-v2.2-reorganisee.md) et [PDF de comparaison](offers/subscriptions-offers-v2.2-reorganisee.pdf) : copie structurelle, sans remplacement de la v2.2 annotee. |
| Exemple d'API fourni | [offers/offers_list.json](offers/offers_list.json) : reponse reelle de offer/list, non equivalente a un contrat exhaustif. |
| Base de connaissance produit | [offers/knowledge-base/PRODUCT.md](offers/knowledge-base/PRODUCT.md) : synthese des comportements cote equipement, contrats exposes, sources, exclusions et points ouverts. |
| Sources API DALI | [PDF DPI API v2](offers/DPI-API%20V2-121126-175023.pdf) et [conversion MarkItDown](offers/knowledge-base/DPI-API-V2.markitdown.md). |
| Source architecture DALI | [PDF SAG DALI lot 2](offers/ETDDPPS-SAG%20-%20P01558%20-%20DALI%20lot%202%20nPFS%20-%20offers%20v2%20%5BIN%20PROGRESS%5D-121126-175006.pdf) et [conversion MarkItDown](offers/knowledge-base/DALI-lot-2-nPFS-offers-v2.markitdown.md) : document indique IN PROGRESS, contexte non contractuel. |
| Source Word archivee | [offers/archive/6 - STBL- NPFS - DALI - Subscriptions Offers - v2.1.docx](offers/archive/6%20-%20STBL-%20NPFS%20-%20DALI%20-%20Subscriptions%20Offers%20-%20v2.1.docx). |
| Illustrations | Repertoire `offers/assets/`, partage entre les versions. |
| Export PDF | [offers/export.sh](offers/export.sh). |
| Conversion initiale Word | [offers/improve-content.lua](offers/improve-content.lua) et [offers/normalize-offers.lua](offers/normalize-offers.lua). |
| Rendu du sommaire et des titres | [offers/format-contents.lua](offers/format-contents.lua). |

Depuis la racine du depot :

```bash
bash offers/export.sh v2.2
```

Sans argument, le script exporte egalement la v2.2. Pour reexporter explicitement
la v2.1 : `bash offers/export.sh v2.1`.

**Attention : ne pas utiliser `--from-word` pour continuer la v2.2.** Cette option
reconvertit le Word archive et ecrase le Markdown v2.1. Les modifications futures
doivent etre effectuees directement dans le Markdown v2.2, puis exportees sans
reconversion Word. Les filtres de conversion ne contiennent pas les annotations
et les arbitrages ajoutes ensuite a la v2.2.

L'export utilise Pandoc, Google Chrome headless et `pdfinfo`. Il effectue plusieurs
passes jusqu'a stabilisation des destinations PDF, pour calculer les vrais
numeros de page du sommaire. L'export final de la v2.2 a reussi apres les dernieres
precisions sur TRANSIENT.

## Cadre confirme par l'utilisateur

- Tous les equipements et tous les types d'offres sont dans le perimetre.
- La recherche d'offres est hors perimetre.
- Tout le contenu fonctionnel de la v2.1 est valide. Ne pas modifier une regle
  metier sur la base d'une supposition ou d'une incoherence apparente.
- Le Swagger n'est pas disponible pour l'instant ; l'utilisateur pourra le
  fournir plus tard.
- Les ambiguites sont annotees dans la v2.2 avec des identifiants stables
  `CLAR-OFF-xxx`, puis traitees avec l'utilisateur une par une.
- L'objectif de reorganisation est de clarifier, deplacer et dedupliquer les
  informations a comportement constant. Un premier brouillon de structure a ete
  genere a cote de la v2.2 annotee pour comparaison.
- Le template et les fichiers v2.1 doivent rester inchanges.
- La specification v2.2 decrit le service (donnees, contrats, traitements et
  resultats fonctionnels), pas la presentation de la UI. Maquettes, captures et
  exemples d'ecrans sont illustratifs uniquement ; l'interface peut evoluer
  independamment du service.

## Presentation deja mise en place

- Template d'entreprise repris depuis l'exemple Espace Kids fourni au debut.
- Bloc DATA PROTECTION conserve mot pour mot.
- Historique complet dans VERSIONS HISTORY : versions 1.0 a 1.12, 2.0 et 2.1,
  plus la ligne d'initialisation 2.2 dans la version de travail. Pas d'annexe
  d'historique en doublon.
- Colonnes INDICE et DATE centrees dans l'historique.
- Sommaire de style LaTeX dans la specification offres : titre a gauche,
  trois niveaux, retraits progressifs, points de conduite, vrais numeros de page
  alignes a droite et liens cliquables. Le titre reste centre dans le template
  d'origine, qui n'a pas ete modifie pour ces preferences propres aux offres.
- Corps : titres en casse normale, sigles et identifiants techniques preserves.
  Trois niveaux numerotes au maximum ; sous-titres plus profonds en gras sans
  numero ni italique. Tous les titres sur la meme marge gauche, espace regulier
  entre numero et texte, pas de tiret ni de point ajoute apres le numero.
- Hierarchie typographique du corps : 16 / 13 / 11 / 10 points.
- Phrase incomplete "It will deta" supprimee.
- Surlignages jaunes supprimes.
- Cinq appels HTTP et deux exemples JSON en blocs de code ; exemples JSON parses
  et indentes sans modification de leur contenu.
- 160 champs JSON des tableaux mis en code en ligne ; tableaux compactes et
  largeurs de colonnes adaptees. Les 29 occurrences d'illustrations et les liens
  techniques ont ete controles pendant la conversion.
- Annotations de relecture en encadres gris, distinctes des regles validees.

## Arbitrages deja traites

### CLAR-OFF-001 : section supprimee

L'utilisateur a demande de supprimer l'ancienne section 3.1.2 "Data recovery
triggers" et son annotation. Le sommaire et les quatre renvois vers "Global
management" ont ete corriges.

Les sections suivantes sont desormais : 3.1.2 "Life cycle of an offer", 3.1.3
"Global management" et 3.1.4 "Access to offer items". Les declencheurs de la
section "Retrieving the offer list" sont conserves. Ne pas recreer la section
supprimee ni renumeroter les identifiants CLAR-OFF restants.

### TRANSIENT : nature et cycle confirmes

Reponses de l'utilisateur :

1. C'est un statut transitoire gere localement dans le produit, entre
   "non-souscrit" et "souscrit", le temps du traitement de la souscription cote
   DSI.
2. La souscription demarre les 120 secondes.
3. La sortie de TRANSIENT se produit a la fin des 120 secondes.

Ces precisions sont integrees dans "Customer journey adaptation after
subscription" et dans les annotations 002 et 010. Le document conserve l'exigence
existante d'une duree configurable, de 120 secondes par defaut. Il distingue
l'etat local des statuts recus de DALI sans imposer de choix de stockage interne.
L'expiration de la temporisation ne constitue pas, a elle seule, une preuve de
propagation effective des droits.

Ne pas redemander qui produit TRANSIENT, ce qui le declenche ou quand il se
termine. La gestion du redemarrage et des echecs apres expiration reste ouverte.

## Etats deja documentes et observations API

Les listes d'etats sont deja presentes dans la specification validee : ne pas
demander a l'utilisateur de les reconstruire.

- Partenaire : ACTIVE, CANCELED, CREATED, INACTIVE, NON-EXISTENT, UNSUBSCRIBED.
- Commercial : Active, Activating, unspecified et, selon les tableaux, Desactive
  ou Desactivating. L'orthographe exacte des valeurs reste a rapprocher du
  contrat API ; ne pas inventer une normalisation.
- Droits : ENTITLED et NOT_ENTITLED.

La reponse `offers_list.json` contient 70 offres sur 70 : 55 BOUQUET, 8 APPLICATION,
4 SERVICE et 3 UNMANAGED_APPLICATION. Elle ne contient pas de MULTIOFFER ni de
subscriptionType=3. TRANSIENT y est absent, conformement a sa nature locale.

Chemins observes : `data[].commercial.subscriptionStatus`,
`data[].entitlementState`, `data[].commercial.partner.status`.

- `commercial.subscriptionStatus` decrit l'etat du processus de souscription,
  pas si le client est abonne.
- `entitlementState` indique si l'offre est souscrite (`ENTITLED`) ou non
  (`NOT_ENTITLED`).
- `commercial.partner.status` decrit l'etat d'activation de l'offre chez le
  partenaire ; une offre Disney+ souscrite peut encore necessiter la creation du
  compte partenaire.
- Le DPI v2 decrit une souscription reussie avec `ENTITLED` et `ACTIVATING`, et
  une resiliation en cours avec `ENTITLED` et `DEACTIVATING`. Pour une offre
  impactee et resiliee lors d'une souscription forcee, il decrit
  `NOT_ENTITLED` et `UNSPECIFIED`.
- Statuts commerciaux observes : UNSPECIFIED, ACTIVE, DEACTIVATING.
- Statuts partenaire observes : CREATED, ACTIVE.
- 59 offres UNSPECIFIED / NOT_ENTITLED proposent l'action subscribe.
- 8 offres ENTITLED proposent l'action unsubscribe.
- Le JSON partage montre aussi la combinaison DEACTIVATING / ENTITLED / CREATED.
  Les decisions produit sont confirmees : ACTIVATING/ENTITLED conduit a la
  gestion de l'abonnement apres TRANSIENT ; DEACTIVATING/ENTITLED affiche une
  resiliation en cours sans relance ; CREATED/ENTITLED affiche l'activation
  partenaire et la gestion. subscriptionStatus pilote seulement l'etat de
  transition affiche ; entitlementState et les liens DALI pilotent l'abonnement
  et les actions. Aucun fallback de champ absent n'est defini pour l'instant.
- Les 3 UNMANAGED_APPLICATION n'ont pas ces statuts ni ces actions dans cet exemple.
- Deux offres APPLICATION de subscriptionType=2 contiennent des chaines non vides
  pour activationLink ET finalActivationLink dans la reponse list. Le DPI v2
  decrit aussi la construction de finalActivationLink dans les formatages Get/List
  pour certains cas, alors que le texte produit la presente comme disponible apres
  souscription. Le moment et la formule exacts restent a confirmer dans Swagger.

Une reponse reelle illustre des combinaisons mais ne prouve ni l'exhaustivite du
contrat ni une regle UI universelle. Ne pas afficher les URL d'activation ou
d'autres donnees sensibles de cette reponse dans les comptes rendus.

## Points encore ouverts

Les 10 annotations restent visibles dans la v2.2 ; CLAR-OFF-002 est maintenant
confirmee et ses regles produit sont integrees. Neuf points conservent des
suites ouvertes. CLAR-OFF-010 est
partiellement clarifiee par les decisions TRANSIENT ci-dessus.

| Repere | Suite a donner |
| --- | --- |
| CLAR-OFF-003 | Strategie explicite par equipement pour pagination, recuperation complete, If-None-Match, 200/304, cache et rafraichissement force. |
| CLAR-OFF-004 | Verification des chemins, casse, types et categories avec le Swagger. Exemples : commercial.commercialType declare Integer avec OPTION ; commercial.name declare Integer ; APPLICATION_NON_MANAGE versus UNMANAGED_APPLICATION. |
| CLAR-OFF-005 | Role et disponibilite de activationLink/finalActivationLink, persistance, absence du cache et expiration ; tenir compte des liens effectivement presents dans list. |
| CLAR-OFF-006 | Forme de la reponse de GET /api/offers/by-commercial-id/{commercialId} : objet ou collection, metadonnees de pagination, chemin du statut partenaire. |
| CLAR-OFF-007 | Matrice des offres partenaires selon subscriptionType et statuts ; cas du type 3 non active, limite d'un appel toutes les 5 secondes et lien valable une heure. |
| CLAR-OFF-008 | Principe confirme : les ecrans sont illustratifs et non contractuels ; le service est normatif. L'objectif de la specification a ete recentre sur le service. Reste a verifier avec le Swagger les chemins `commercial.promotion` versus `commercial.promotions[]` et la semantique de `limited_period`, `one_time` et `forever`. Ne pas deduire des maquettes des exigences de presentation. |
| CLAR-OFF-009 | Reponse 409 decrite comme liste mais illustree par un objet additionalInfo.incompatibleOffers ; libelle compatible/incompatible ; confirmation, force=true et erreur de la seconde requete. |
| CLAR-OFF-010 | Cle de configuration effective, redemarrage pendant TRANSIENT, echec de rafraichissement ou droits absents apres expiration. Ne pas rouvrir les trois decisions deja confirmees. |
| CLAR-OFF-011 | Consequences UI et cache en cas d'erreur, resultat incertain d'une action, conditions de relance et coherence avec l'ETag. Le document source contient aussi trois liens vers l'ancre OAuth `#_Oauth_errors_when`, dont la cible est absente. Le brouillon conserve ce probleme preexistant sans ajouter de nouveau lien casse. |

Priorite de reprise : traiter les points encore ouverts avec l'utilisateur. Les
points 004 et 006 peuvent attendre le Swagger.

## Brouillon de reorganisation

Le brouillon [v2.2 reorganise](offers/subscriptions-offers-v2.2-reorganisee.md)
et son [PDF](offers/subscriptions-offers-v2.2-reorganisee.pdf) presentent une
premiere organisation alternative, a comparer avec la v2.2 annotee. Les grandes
parties sont desormais : vue d'ensemble du service, recuperation et modele de
donnees/API, puis parcours utilisateur. Les titres, renvois numeriques et le
sommaire ont ete adaptes au nouvel ordre. L'en-tete utilise une seule table HTML
du template avec le logo PNG reference comme fichier. Elle est placee dans un
`thead` repetitif pour apparaitre sur toutes les pages. Le Markdown ne contient
ni objet SVG ni image encodee en ligne ; le PNG reste une ressource fichier.
Le trait parasite en haut des pages venait de la bordure `tbody` par defaut de
Pandoc sur le tableau enveloppe ; cette bordure est neutralisee uniquement pour
le tableau enveloppe, sans toucher aux bordures des tableaux fonctionnels.
couverture, signatures, sommaire et references. Les 28 numeros de page du
sommaire ont ete controles contre les destinations du PDF.

Le contenu a ete deplace, pas reecrit : 14 tableaux, 29 illustrations, 7 blocs
de code et liens externes verifies. Le brouillon conserve un renvoi OAuth sans
cible qui existait deja dans la source. Il n'est pas valide comme nouvelle
version ; ne pas ecraser la v2.2 annotee avant revue par l'utilisateur.

Pour recreer le brouillon depuis la v2.2 source :

```bash
pandoc offers/subscriptions-offers-v2.2.md --from=markdown-smart-implicit_figures --lua-filter=offers/reorganize-offers.lua --standalone --to=markdown --wrap=none --output=offers/subscriptions-offers-v2.2-reorganisee.md
bash offers/export.sh v2.2-reorganisee
```

Les ameliorations de structure ci-dessous sont appliquees partiellement dans le
brouillon ; elles restent une proposition jusqu'a comparaison et validation.

1. Objet et perimetre.
2. Architecture et responsabilites.
3. Modele fonctionnel des offres et etats.
4. Regles fonctionnelles transverses.
5. Parcours utilisateur.
6. Synchronisation et stockage local.
7. Contrats d'interface et dictionnaire de donnees.
8. Erreurs et comportements degrades.
9. Criteres d'acceptation et tracabilite des regles.

L'idee est de separer les regles metier des descriptions d'API, de decrire chaque
parcours avec preconditions, scenario nominal, alternatives, erreurs et criteres
d'acceptation, et de definir les regles une seule fois avec des identifiants
stables. Cela reste une proposition a mettre en oeuvre progressivement, pas une
autorisation d'inventer de nouvelles regles.

## Contexte technique initial

Le serveur MCP microsoft/markitdown a ete repare au debut de la session : uvx
absent, puis incompatibilite Pydantic avec le SDK MCP utilise. Le lanceur installe
est `/home/etudestb/.local/bin/uvx` et la commande testee est :

```bash
/home/etudestb/.local/bin/uvx --with 'pydantic<2.11' markitdown-mcp@0.0.1a4
```

La configuration MCP utilisateur utilise ce chemin absolu. Le test
d'initialisation MCP et l'outil convert_to_markdown ont fonctionne. Une ancienne
erreur de demarrage restait affichee avant le rechargement du serveur dans VS Code.

## Consigne pour la prochaine session

Lire ce fichier puis le Markdown v2.2 et le brouillon reorganise. Comparer les
deux structures avec l'utilisateur avant toute promotion du brouillon. Ne pas
reconvertir le Word, ne pas refaire le template, ne pas modifier la v2.1 et ne pas
redemander les decisions deja confirmees. Demander les seuls arbitrages encore
necessaires. Apres une modification de la v2.2, reexporter le PDF depuis le
Markdown et verifier les points touches ainsi que la coherence du sommaire.