SAG - P01558 - DALI lot 2 nPFS - offers v2 [IN PROGRESS]
s dali
DOCUMENT HISTORY : DRAFT / Version 0.1 / Date : 2024-05
RE DATE OBSERVATIONS Writer VERIF BY APPROVED BY
V.
V0. 6 mai Document creation Zahra BENBADIS
1 2024 Filipe GOMES
Table of contents
1Table of contents
2Introduction
2.1Document objectives
3Related documents
4Context and scope
4.1nPFS project context
4.2Offer management v2 via DALI objectives
5Functional requirements
6High level design
6.1Global overview
6.2Technical solution
6.3Offer data model and mapping
6.4Get offers
6.4.1API
6.4.2Callflows
6.4.2.1Subscribable offers
6.4.2.2Subscribed offers
6.4.2.3All offers (subscribed and unsubscribed)
6.4.3Errors
6.5Subscribe
6.5.1API
6.5.2Errors
6.6Unsubscribe
6.6.1API
6.6.2Errors
6.7Open questions
6.7.1DSI related questions
6.7.2DSI related issues
Introduction
Document objectives
This document aims to describe the global architecture planned for the introduction of a mediation layer in the context of nPFS project. It will especially define the interactions of
the new mediation layer with the different technical components involved in the suggested solution.
Related documents
DALI swagger: DALI offer management v2 swagger (TB3)
SAG nPFS Souscription offres (before DALI): [SAG][DROP2&3] Souscription offres (OLD - Sans DALI)
SI swagger: https://gitlab.int.nbyt.fr/CatalogueInterfaces/referentiel/-/tree/NPFS_Lot2/apis
Context and scope
nPFS project context
nPFS project consists mainly of replacing the current TV platforms (SmartVision, Commscope CMS) with a new one prvided by Kaltura. This therefore implied a new integration for
the different device applications that must communicate with the new platform.
Offer management v2 via DALI objectives
This new version of offer API delivered by DALI aims to improve the first version with:
Support of unmanaged applications (e.g. Canal+) which are not known by DSI

Add commercial data to offer types: APPLICATION, MULTIOFFER, SERVICE
Support offers with "API partenaires" (e.g Dorcel and Disney+)
Functional requirements
REQ-FUN-01
The device shall be able to retrievel all entitled subscriptions with all related metadata (description, images, ..) and commercial details.
This data is intended to be stored in local device data base.
REQ-FUN-02
The device shall be able to retrieve all subscribable subscriptions with all related metadata (description, images, ..) and commercial details.
This data is intended to be stored in local device data base.
REQ-FUN-03
For each subscription, the device shall be able to display the list of linear channels, Replay and related sVoD catalogs included.
EPG to be added
REQ-FUN-04
The end-user shall be able to subscribe to a standard offer through his device UI.
a standard offer is an offer for which subscription process is managed only by Bouygues SI.
REQ-FUN-05
The end-user shall be able to subscribe to an offer linked to a partner application with inbox account creation from his device (e.g. Dorcel).
The end-user shall be able to activate his partner account using the partner application.
This type of offer needs the account creation on partner back-end before final activation in Bouygues SI.
REQ-FUN-06
The end-user shall be able to subscribe to an offer linked to a partner application with account creation in partner website through Bouygues customer portal.(e.g. Disney+)
The end-user shall be able to activate his partner account using the relevent QR code displayed in the UI.
For this type of offer, subscription is validated by Bouygues SI as soon as the subscribtion is requested. But the access to the service requires final activation after account
creation on partner side.
REQ-FUN-07
The end-user shall be able to unsubscribe any type of offer through his device UI.
REQ-FUN-08
The end-user shall be able to have access to the details of a specific offer.
This specific offer is selected by the user from an editorial row in the UI.
REQ-FUN-09
The subscription and unsubscription processes shall be protected by the purchase PIN validation.
REQ-FUN-10
The end-user shall be able to have access to the details of a specific offer.
This specific offer is selected by the user from an editorial row in the UI.
Subscription retrieval triggers
Every STB will trigger subscriptions retrieval process (both subscribable and subscribed) every 6 hours. In order to avoid an overload, the offer queries will be randomely
spread by STB application over a 6 hours window.
High level design
Global overview

Technical solution
Offer data model and mapping
To be updated with the final offer modelization.
 DALI swagger is up to date regarding the modelization and shall be used as reference.
Get offers
This service allows the user to retrieve all available offers: either already subscribed, subscribable or both of them.
API
 DALI swagger remains the reference for API details (errors included). This table aims only to explain the use of some parameters.
| Input  | Description / comments | Type |
| ------ | ---------------------- | ---- |
x-kaltura-secret Kaltura secret retrieved during authent process. string
| required | This is required for the identification of the customer/device on Kaltura platform |     |
| -------- | ---------------------------------------------------------------------------------- | --- |
(header)
| x-kaltura-api-version | Katura API version. | string |
| --------------------- | ------------------- | ------ |
required
(header)
entitlementState possible values : SUBSCRIBABLE, SUBSCRIBED, ALL. string
| optional      | If not filled → ALL                                     |        |
| ------------- | ------------------------------------------------------- | ------ |
| (query param) | Only offers with the indicated status will be returned. |        |
| categories    | Offer item categories to retrieve.                      | string |
optional Possible values: "BOUQUET", "APPLICATION", "SERVICE", "MULTIOFFER", "UNMANAGED_APPLICATION"
| (query param) | If not filled → ALL |     |
| ------------- | ------------------- | --- |
fields list of attributes to be returned in the offer object.  Array of strings
optional
(query param)
| x-version | DALI offer API version | string |
| --------- | ---------------------- | ------ |
optional
(header)
Callflows
 Intercation with DSI platform will be detailed later if needed.

Subscribable offers
Subscribed offers
After alignement with DSI teams, it has been decided to always retrieve subscribed offers from DSI. Dimensionning questions have been taken into account by DSI teams.

All offers (subscribed and unsubscribed)

Errors
HTTP Description Example
Code
400 Bad Request (with error = Bad Request) {
"error": "Bad Request",
"errorDescription": "Invalid format",
"errorSource": "string"
}
401 INVALID_TOKEN : Invalid Token {
"error": "Invalid Token",
"errorDescription": "Token is invalid",
"errorSource": "string"
}
403 Forbidden
Possible resultMessage values :
- INVALID_TOKEN : Token Expired
404 Not Found {
Possible resultMessage values:
"error": "Customer Not Found",
- CUSTOMER_NOT_FOUND : Customer Not Found
"errorDescription": "Customer wasn't found",
"errorSource": "string"
}
405 Method Not Allowed {
Possible error value : Method Not Allowed "error": "Method Not Allowed",

"errorDescription": "This HTTP Method is not available on this service",
"errorSource": "string"
}
500 Internal error (with error INTERNAL_SERVER_ERROR :Internal Server Error) {
"error": "Internal Server Error",
"errorDescription": "Internal Server Error",
"errorSource": "string"
}
502 Internal error (with error EXTERNAL_SERVER_ERROR :Internal Server Error) {
"error": "External Server Error",
"errorDescription": "External Server Error",
"errorSource": "string"
}
Subscribe
This service allows the user to subscribe to a subscribable offer.
API
DALI swagger remains the reference for API details (errors included). This table aims only to explain the use of some parameters.
1 POST /api/offers/subscribe
Input Description / comments Type
x-kaltura-secret Kaltura secret retrieved during authent process. string
required This is required for the identification of the customer/device on Kaltura platform
(header)
x-kaltura-api-version Katura API version. string
required
(header)
x-purchase-code purchase PIN string
required
(header)
idCommercialOffer commercial id of the offer that will be used to call DSI API. string
required
(body)
force Flag used by the device to indicate that the subscription shall be processed even if there is a incompatible offer. boolean
optional
(body)
x-version DALI offer API version string
optional
(header)
Callflow
Intercation with DSI platform will be detailed later if needed.

Errors
HTTP Description Example
Code
400 Bad Request (with error = Bad Request) {
"error": "Bad Request",
"errorDescription": "Invalid format",
"errorSource": "string"
}
401 INVALID_TOKEN : Invalid Token {
"error": "Invalid Token",
"errorDescription": "Token is invalid",
"errorSource": "string"
}
403 Forbidden
Possible resultMessage values :
- Customer Suspended
- Unable Purchase Free
- Unable Purchase Offer Purchased
404 Not Found
Possible resultMessage values:
-Customer Not Found
- Purchase Failed
- Offer Not Found
405 Method Not Allowed {
Possible error value : Method Not Allowed "error": "Method Not Allowed",
"errorDescription": "This HTTP Method is not available on this service",
"errorSource": "string"
}
409 Conflict
Possible error value : Incompatible offer
500 Internal error (with error INTERNAL_SERVER_ERROR :Internal Server Error) {
"error": "Internal Server Error",
"errorDescription": "Internal Server Error",
"errorSource": "string"
}
502 Internal error (with error EXTERNAL_SERVER_ERROR :Internal Server Error) {
"error": "External Server Error",
"errorDescription": "External Server Error",
"errorSource": "string"
}
Partner account activation
Depending on the subscription type (metadata retrieved from SHAPIRA platform), the parter account activation will be triggered either using a QR code or using the partner
application. The distinction will be managed by the subscription type metadata and the finalActivationLink returned by DALI to the device during subscribe process.
The finalActivationLink will be built by DALI as follows:
if subscription type is 2 (e.g. Disney+ use case): finalActivationLink = QRCODE_ACTIVATION_LINK+ commercialOfferId
QRCODE_ACTIVATION_LINK is configured on DALI side (given by DSI).
if subscription type is 3 (e.g Dorcel use case): finalActivationLink = activationLink+idServicePartenaire
activationLink: metadata retrieved from SHAPIRA platform
idServicePartenaire: info retrieved from DSI response (impactOffresAdditionnelles call)

Unsubscribe
This service allows the user to unsubscribe a subscribed offer.
API
 DALI swagger remains the reference for API details (errors included). This table aims only to explain the use of some parameters.
1 POST /api/offers/unsubscribe
| Input  | Description / comments | Type |
| ------ | ---------------------- | ---- |
x-kaltura-secret Kaltura secret retrieved during authent process. string
| required | This is required for the identification of the customer/device on Kaltura platform |     |
| -------- | ---------------------------------------------------------------------------------- | --- |
(header)
| x-kaltura-api-version | Katura API version. | string |
| --------------------- | ------------------- | ------ |
required
(header)
| x-purchase-code | purchase PIN | string |
| --------------- | ------------ | ------ |
required
(header)
idCommercialOffer commercial id of the offer that will be used to call DSI API. string
required
(body)
| x-version | DALI offer API version | string |
| --------- | ---------------------- | ------ |
optional
(header)
Callflow
 Intercation with DSI platform will be detailed later if needed.

Errors
HTTP Description Example
Code
400 Bad Request (with error = Bad Request) {
"error": "Bad Request",
"errorDescription": "Invalid format",
"errorSource": "string"
}
401 INVALID_TOKEN : Invalid Token {
"error": "Invalid Token",
"errorDescription": "Token is invalid",
"errorSource": "string"
}
403 Forbidden
Possible resultMessage values :
404 Not Found
Possible resultMessage values:
-Customer Not Found
500 Internal error (with error INTERNAL_SERVER_ERROR :Internal Server Error) {
"error": "Internal Server Error",
"errorDescription": "Internal Server Error",
"errorSource": "string"
}
502 Internal error (with error EXTERNAL_SERVER_ERROR :Internal Server Error) {

"error": "External Server Error",
"errorDescription": "External Server Error",
"errorSource": "string"
}
Open questions
DSI related questions
what are the limitations on DSI side to use DSI API for subscribed offers also ?
Here are details agreed with DSI teams (see comments from Filipe GOMES)
Ressource/Service Exposition ST Source Temps Interne Temps global Nombre d'appels/s
(hors appel externe) supplémentaires
grappes-contrats REFCLI M3 Offre 20ms 30ms 100 en nominal / 250 en Pic
grappes-formules-
400 en nominal / 500 en Pic
souscrites
grappes-historiques-
formules-souscrites
rechercherContexteClientId REFCLI FLORIDA 20ms 50ms 200 en nominal / 500 en Pic
entite (en cumul des sollicitation
AS DSI
Florida + AS DSI)
400 en nominal / 500 en
Pic
En complément pour les parcours de consultation / résiliation dʼoffres :
Ressource/Service Exposition ST Source Temps Interne Temps global Nombre d'appels/s
(hors appel externe) supplémentaires
grappes-contrats REFCLI M3 Offre 20ms 30ms 100 en nominal / 250 en pic
grappes-formules-
400 en nominal / 500 en Pic
souscrites
grappes-historiques-
formules-souscrites
Ce qui nous amène au global à 800 appels/s en nominal et 1000 en pics pour les grappes* et 400 en nominal / 500 en Pic pour le rechercherContexteClientIdentite
why "offre incluse" info is not returned in the new API offres-additionnelles ?
Only "offre incluse" included in principal offer is not returned by the new API. According to DSI, there is no plan to retrieve this information without Change Request.
is it possible to have synchronous mode for subscribe and unsubscribe actions ?
No. There is a delay of max 1 second that shall be supported.
what is the relevency of "IncompatibleType" attribute returned by offres-additionnelles-souscriptibles while it is not documented in the related Swagger ?
This information shall not be used.
error code expected for unsubscribing offer : an already unsubscribed offer or subscribable offer, an unsubscribing offer, a subscribing offer
error code expected for subscribing offer : an already subscribed offer, an unsubscribing offer, a subscribing offer.
Error codes are decribed in DSI swagger (/contrats/{idContrat}/impact-souscription-offres-additionnelle). For example, when the user tries to subscribe an already subscribed
offer, it will be returned as "incomatble offer".
serviceTv attribute and unsubscribe action (maybe others) are not returned anymore by the API GET offres-additionnelles (no problem if the offerId is specified)
in offer unsubscribe API return, dateEffet et dateResiliationEcheance are returned ; in API GET offres-additionnelles return, there is only one attribute dateFin => what is mapped in dateFin ?
We shall use dateResiliationEcheance which is mandatory.

During an offer subscription, what datas are updated by DSI for a related impacted offer with action "MODIFICATION" ?
shall we only use the HATEOS llinks returned by DSI or shall we build the query for subscribe/unsubscribe ?
We shall use DSI HATEOS links (validated by DSI with Filipe GOMES ).
does a call on offres-additionnelles-souscriptibles with moderate ACR or basic ACR is expected to give the same result ?
Moderate ACR is planned to be used only for a transaction action (subscribe or unsubscribe) and shall not be used for other queries. However, after alignement with DSI teams (
IMAD LAOUDINI ), it has been agreed to use the same moderate token for other API in the context of a global subscribe/unsubscribe callflow.
Can the DSI model two offers with distinct commercialIds but the same servicesTv (one is an option and the other is a service offered) ?
That could happen.
DSI related issues
During the tests, we noticed that one offer is both subscribed ("souscrite") and unsubscribed ("souscriptible").
→ to be fixed ?
No subscription can be done : the command is acquitted but not applied (offer still unsubscribed)