API V2
0 Diagram Files
1 COMMON ACTIVITIES
1.1 MapCommercialOfferItemToOfferItem
1.1.1 Inputs
1.1.2 Outputs
1.1.3 Treatment
1.1.3.3 Mapping Additional fields
1.2 AggregationOffersDetailsV2WithCache
1.2.0 Flow Diagram
1.2.1 Inputs
1.2.2 Outputs
6.6.3 Treatment
1.3UpdateOfferItemBaseV2ListWithCache
1.3.1 Inputs
1.3.2 Outputs
1.3.3 Treatment
2 COMMON OBJECTS API
2.1 Offer API Model V2
2.1.1 OfferItem
2.1.1.1 OfferItemBase
2.1.1.2 BouquetOfferItem
7.3.1.3 ApplicationOfferItem
7.3.1.4 ServiceOfferItem
7.3.1.5 MultiOfferItem
7.3.1.3 UnmanagedApplicationOfferItem
7.3.2 CommercialOffer
7.3.2.1 CommercialOfferBase
7.3.2.2 CommercialOfferUnSubscribe ==> subscriptionStatus == UNSPECIFIED
7.3.2.3 CommercialOfferSubscribe ==> subscriptionStatus != UNSPECIFIED
7.3.3 Options
7.3.4 AllOfferItems
7.3.5 Links
7.3.5.1 GetLink
7.3.5.2 PostLink
9 PROCESS DESCRIPTION V2
9.1 Common API Definition
9.1.1 Request Headers
9.2 GET
9.2.1 Operation : Get Offer
9.2.1.1 API Request
9.2.1.1.1 Headers
9.2.1.1.2 Query Parameters
9.2.1.2 API Response
9.2.1.3 Activity Diagram
9.2.1.4 Validate Data Request
9.2.1.4.1 Input
9.2.1.4.2 Output
9.2.1.4.3 Treatment
9.2.1.6 Format Response
9.2.1.6.1 Input
9.2.1.6.2 Output
9.2.1.6.3 Treatment
9.2.2 Operation : List
9.2.2.1 API Request
9.2.2.1.1 Headers
9.2.2.1.2 Query Parameters
9.2.2.2 API Response
9.2.2.2.1 Response headers
9.2.2.2.2 Response Schema
9.2.2.3 Activity Diagram
9.2.2.4 Validate Data Request
9.2.2.4.1 Input

9.2.2.4.2 Output
9.2.2.4.3 Treatment
9.2.2.7 Format Response
9.2.2.7.1 Input
9.2.2.7.2 Output
9.2.2.7.3 Treatment
9.2.3 Operation : Check Offer
9.2.2.1 API Request
9.2.2.1.1 Headers
9.2.2.1.2 Query Parameters
9.2.3.2 API Response
8.2.4.1.3 Treatment
9.3 POST
9.3.1 Operation : Subscribe Offer
9.3.1.1 API Request
9.3.1.1.1 Header
9.3.1.1.2 Query Parameters
9.3.1.2 API Response
9.3.1.3 Activity Diagram
9.3.1.4 Validate Data Request
9.3.1.4.1 Input
9.3.1.4.2 Output
9.3.1.4.3 Treatment
9.3.1.5 Format Response
9.3.1.5.1 Input
9.3.1.5.2 Output
9.3.1.5.3 Treatment
9.4 DELETE
9.4.1 Operation : Unsubscribe Offer
9.4.1.1 API Request
9.5.1.1.1 Header
9.4.1.1.2 Query Parameters
9.4.1.2 API Response
9.4.1.3 Activity Diagram
9.4.1.4 Validate Data Request
9.4.1.4.1 Input
9.4.1.4.2 Output
9.4.1.4.3 Treatment
9.4.1.5 Format Response
9.4.1.5.1 Input
9.4.1.5.2 Output
9.4.1.5.3 Treatment
0 Diagram Files
Diagram Name Versio Files
n
call Flow API GET OFFER
call Flow API LIST OFFER 3
LIST_OFFERS_V3.vsdx
27 sept. 2024, 02:41 PM
call Flow API UNSUBSCRIBE 2
OFFER
UNSUBSCRIBE…V2.vsdx
27 sept. 2024, 02:41 PM
call Flow API SUBSCRIBE OFFER 7.1

SUBSCRIBE_O….1.vsdx
10 oct. 2024, 01:16 PM
Call Flow Aggregation Offers Detail
With Cache
1 COMMON ACTIVITIES
1.1 MapCommercialOfferItemToOfferItem
1.1.1 Inputs
| Parameter       | Type                    | Description | Constraints |     |
| --------------- | ----------------------- | ----------- | ----------- | --- |
| CommercialOffer | Object Commercial offer |             | MANDATORY   |     |
1.1.2 Outputs
| Parameter  | Type             | Description                   | Constraints |     |
| ---------- | ---------------- | ----------------------------- | ----------- | --- |
| oOfferItem | Object OfferItem | Offer aggregation for devices |             |     |
OPTIONAL
1.1.3 Treatment
See mapping Table
| Parameter |                            | Mapping Object CommercialOffer |     | Traitment |
| --------- | -------------------------- | ------------------------------ | --- | --------- |
| id        | OffreAdditionnelle.idOffre |                                |     |           |
subscriptionStatus if offer from DSI.offres-additionnelles-souscriptibles, subscriptionStatus = "ACTIVE" => "ACTIVE"
"UNSPECIFIED" "EN_COURS_RESILIATION" =>
else, subscriptionStatus = OffreAdditionnelle.statut "DEACTIVATING"
"EN_COURS_SOUSCRIPTION" =>
"ACTIVATING"
commercialType OffreAdditionnelle.typeOffre "BONUS" => "BONUS"
"OPTION" => "OPTION"
"SERVICE_OFFERT" =>
"OFFERED_SERVICE"
"SERVICE_PARTENAIRE" =>
"PARTNER_SERVICE"
| name             | OffreAdditionnelle.libelleCommercial                             |     |     |     |
| ---------------- | ---------------------------------------------------------------- | --- | --- | --- |
| originalAmount   | OffreAdditionnelle.montantTTC                                    |     |     |     |
| customPriceLabel | CustomLabelConfig(matchByDeviceType contenu dans headers.x-user- |     |     |     |
agent).customPriceLabel
| finalAmount            | OffreAdditionnelle.montantPayeTTC               |     |     |     |
| ---------------------- | ----------------------------------------------- | --- | --- | --- |
| promotions             | OffreAdditionnelle.remises                      |     |     |     |
| promotions.price       | OffreAdditionnelle.remises.montantTTC           |     |     |     |
| promotions.customPromo | If OffreAdditionnelle.montantPayeTTC != null && |     |     |     |
Label OffreAdditionnelle.montantPaye != null && OffreAdditionnelle.montantTTC >
OffreAdditionnelle.montantPayeTTC && OffreAdditionnelle.remises != null ou
vide && OffreAdditionnelle.remise.duree.duree =! null
   CustomLabelConfig(matchByDeviceType contenu dans headers.x-user-
agent).customPromoLabel
EndIf

promotions.order OffreAdditionnelle.remises.ordre
promotions.applyTill
promotions.expirationDat OffreAdditionnelle.remises.dateFin
e
promotions.duration OffreAdditionnelle.remises.duree.duree
promotions.duration.durat 'limited_period'
ionType
promotions.duration.perio OffreAdditionnelle.remises.duree.duree
d
promotions.duration.perio OffreAdditionnelle.remises.duree.uniteeDuree
dUnit
promotionalDescription OffreAdditionnelle.libellePromotionnel
startDate OffreAdditionnelle.dateDebut
endDate OffreAdditionnelle.dateFin
partner OffreAdditionnelle.infoPartenaire object
Not present if offer from DSI.offres-additionnelles-souscriptibles
partner.id OffreAdditionnelle.infoPartenaire.idPartenaire
partner.status OffreAdditionnelle.infoPartenaire.statutPartenaire "ACTIVE" => "ACTIVE"
ANNULEE => "CANCELED"
CREEE => "CREATED"
INACTIVE => "INACTIVE"
INEXISTANTE => "NON-EXISTENT"
RESILIEE => "UNSUBSCRIBED"
1.1.3.3 Mapping Additional fields
Parameter Mapping Object offerItem Traitment
finalActivationLink if ApplicationOfferItem.subscriptionType=2,
finalActivationLink = QRCODE_ACTIVATION_LINK +
ApplicationOfferItem.commercialOffer.id
endif
See Subscribe, Get, List Format Response
1.2 AggregationOffersDetailsV2WithCache
1.2.0 Flow Diagram

1.2.1 Inputs
| Parameter | Type    | Description               | Constraints |
| --------- | ------- | ------------------------- | ----------- |
| ksBeDali  | objet   | Kaltura secret of BE DALI | MANDATORY   |
| idContrat | String  |                           | MANDATORY   |
|  category | OfferIt |                           | OPTIONAL    |
emCat
egory
| entitlementState | Entitle |     | OPTIONAL |
| ---------------- | ------- | --- | -------- |
mentS
tate
1.2.2 Outputs
| Parameter      | Type        | Description              | Constraints |
| -------------- | ----------- | ------------------------ | ----------- |
| oExecutionResu | ExecutionRe | Represents the execution |             |
MANDATORY
| lt             | sult         | state of an operation. |     |
| -------------- | ------------ | ---------------------- | --- |
| oOfferItemList | List<OfferIt |                        |     |
OPTIONAL
emBase>
6.6.3 Treatment
List<OfferItemBase> oOfferItemList = new ArrayList<>();
if (entitlementState == null || EntitlementState.NOT_ENTITLED == entitlementState)
 {oResultatExecution,oResponse} = dsiMagentoConnector.getOffresSouscriptibles(idContrat)
if oResultatExecution.resultat == NOK

throw DPPSExeception(oResultatExecution)
else
     for oOffresAdditionnelle in  oResponse.getOffresAdditionnelles()
if isNotEmpty(offreAdditionnelle.getServicesTv())
         oOfferItemList.add(mapCommercialOfferItemToOfferItem(offreAdditionnelle))
endIf
endFor
endIf
endIf
if (entitlementState == null || EntitlementState.NOT_ENTITLED == entitlementState) {
{oResultatExecution,oResponse} = dsiMcubeConnector.getOffresAdditionnelles(idContrat)
if oResultatExecution.resultat == NOK
  throw DPPSExeception(oResultatExecution)
else
   for oOffresAdditionnelle in oResponse.getOffresAdditionnelles()
if isNotEmpty(offreAdditionnelle.getServicesTv())
         oOfferItemList.add(mapCommercialOfferItemToOfferItem(offreAdditionnelle))
endIf
endFor
offerItemBaseList = updateOfferItemV2ListWithCache(offerItemBaseList, category);
return offerItemBaseList;
1.3UpdateOfferItemBaseV2ListWithCache
1.3.1 Inputs
| Parameter | Type    | Description | Constraints |
| --------- | ------- | ----------- | ----------- |
|  category | OfferIt |             | OPTIONAL    |
emCat
egory
| oOfferItemV2Lis | List<O  |     | MANDATORY |
| --------------- | ------- | --- | --------- |
| t               | fferIte |     |           |
mBase
>
1.3.2 Outputs
| Parameter      | Type         | Description              | Constraints |
| -------------- | ------------ | ------------------------ | ----------- |
| oExecutionResu | ExecutionRe  | Represents the execution | MANDATORY   |
| lt             | sult         | state of an operation.   |             |
| oOfferItemV2Li | List<OfferIt |                          |             |
OPTIONAL
| st  | emBase> |     |     |
| --- | ------- | --- | --- |
1.3.3 Treatment
List<OfferItemBase> resultOfferItemBaseList = new ArrayList<>();
Map<Pair<String, EntitlementState>, OfferItemBase> offerItemsMissingFromCache ;

for offerItemBase in offerItemBaseList
CacheOfferItemBaseV2 offerItemBaseFromCacheV2 = offerCache.getOfferItemBaseFromCacheV2(offerItemBase.getId());
if (offerItemBaseFromCache == null) {
offerItemsMissingFromCache.add(SimpleEntry<>(Pair.of(offerItemBase.getId(),
offerItemBase.getEntitlementState()),offerItemBase));
}
OfferItemBase fromOfferItemCache = merge data of (offerItemBase,offerItemBaseFromCache);
if (offerItemCategoryFilter == null || offerItemCategoryFilter.equals(fromOfferItemCache.getCategory())) {
resultOfferItemBaseList.add(fromOfferItemCache);
}
return null;
enFor
//Manage FallBack Offer no exist in hazelcast cache
List<String> serviceTVsNotInCache = extract key of map offerItemsMissingFromCache
if (!serviceTVsNotInCache.isEmpty()) {
PDSData pdsData = kalturaService.getPDSDataFromCache();
offerCacheService.queryAndAddToCacheV2(serviceTVsNotInCache, pdsData);
}
forEach offerItemBase in offerItemsMissingFromCache
CacheOfferItemBaseV2 offerItemBaseFromCacheV2 =
offerCacheService.getOfferItemBaseFromCacheV2(offerItemBase.getId());
if (offerItemBaseFromCache != null) {
OfferItemBase fromOfferItemCache = merge data of (offerItemBase, offerItemBaseFromCacheV2);
if (offerItemCategoryFilter == null || offerItemCategoryFilter.equals(fromOfferItemCache.getCategory())) {
resultOfferItemBaseList.add(fromOfferItemCache);
}
}
endFor
return resultOfferItemBaseList;
2 COMMON OBJECTS API
2.1 Offer API Model V2
2.1.1 OfferItem
2.1.1.1 OfferItemBase
Parameter Type Cardinalit Description
y
internalId String M Offer Id on PFS Shapira
id String M Offer identifier, known from commercial and Shapira PFS (ie tv_service)

| category | String/Enum | M DPPS category for Offer |
| -------- | ----------- | ------------------------- |
Values :
BOUQUET
APPLICATION
SERVICE
MULTIOFFER
UNMANAGED_APPLICATION
images Array Of Object O Table of images associated with the offer : logo offer, editorial image of the offer for a
Image customer subscribed to the offer, editorial image of the offer for a customer not
subscribed to the offer.
Présent même si vide
| id   | String | M Image ID        |
| ---- | ------ | ----------------- |
| type | String | M Image type name |
à traiter gestion unicité du type dans la liste retournée, une règle de gestion
declaration
| allowResize | Boolean | M Resize allowed ? |
| ----------- | ------- | ------------------ |
Value True
| height           | Int    | O Image height            |
| ---------------- | ------ | ------------------------- |
| width            | Int    | O Image width             |
| aspectRatio      | Double | M Image aspect ratio      |
| url              | String | M Image URL               |
| shortDescription | String | O Short description offer |
editorialWeight Int O Default position of the offer relative to the others in the TV interface (increasing order
and valid for both SMVOffers and PartnerOffers files)
| catalogStartDateTim | Long | O Subscription date |
| ------------------- | ---- | ------------------- |
e
| shortTitle | String | M Offer name in Shapira |
| ---------- | ------ | ----------------------- |
Can be different from commercial name offer
| shortName | String                 | O Short Name              |
| --------- | ---------------------- | ------------------------- |
| genres    | Array of String        | O Genres in the offer     |
| options   | Array of object Option | O Table of offer options  |
| links     | OfferItemModelLinks    | O OfferItem Links HATEOAS |
self: Always available
| self | GetLink | O Get this offer informations |
| ---- | ------- | ----------------------------- |
Only present for offers with category BOUQUET or APPLICATION or SERVICE or
MULTIOFFER
| actions | OfferItemModelActio | O OfferItem Actions HATEOAS |
| ------- | ------------------- | --------------------------- |
nsLinks
unsubscribe: Available only for ENTITLED offerItems
subscribe : Available only for NOT_ENTITLED offerItems

Can only be present for offers with category BOUQUET or APPLICATION or SERVICE
or MULTIOFFER
| unsubscribe | PostLink | O   | Unsubscribe to the offer |     |     |
| ----------- | -------- | --- | ------------------------ | --- | --- |
Present only if entitlementState == ENTITLED
| subscribe | Postlink | O   | Subscribe to the offer |     |     |
| --------- | -------- | --- | ---------------------- | --- | --- |
Present only if entitlementState == NOT_ENTITLED
2.1.1.2 BouquetOfferItem
Extends OfferItemBase, the field must be set with value"BOUQUET".
|     | Parameter |     | Type | Cardinali | Description |
| --- | --------- | --- | ---- | --------- | ----------- |
ty
| entitlementState |     |     | String/Enum | M Allowed values : |     |
| ---------------- | --- | --- | ----------- | ------------------ | --- |
ENTITLED
NOT_ENTITLED
| parentalRating |     |     | String | M CSA level of the offer. |     |
| -------------- | --- | --- | ------ | ------------------------- | --- |
Possible values :
CSA1, CSA2, CSA3, CSA4, CSA5
trailerNonSubcribedOffer String O Video stream link for a non-subscribed customer
commercial CommercialOffer M Commercial Informations about offer
Object
| replayShop |     |     | Object       | M Replay Shop Object    |     |
| ---------- | --- | --- | ------------ | ----------------------- | --- |
| total      |     |     | Int          | M Total of Replay Shops |     |
| items      |     |     | Array Object | O List of Replay Shops  |     |
ReplayShopItem
Présent même si vide
|     | id         |     | String          | M Shop id                          |     |
| --- | ---------- | --- | --------------- | ---------------------------------- | --- |
|     | providerId |     | String          | M Trigram unique shop Identifier   |     |
|     | name       |     | String          | M Shop name                        |     |
|     | channels   |     | Array Of Object | M List of all channels in the shop |     |
LiveShopBucketIte
mBase
|          |     | id   | String          | M Channel id          |     |
| -------- | --- | ---- | --------------- | --------------------- | --- |
|          |     | name | String          | M Channel name        |     |
|          |     | lcn  | Int             | O Channel number      |     |
| svodShop |     |      | Object          | M sVod Shop Object    |     |
| total    |     |      | Int             | M Total of sVod Shops |     |
| items    |     |      | Array of Object | O List of sVod Shops  |     |
SvodShopItem
Présent même si vide
|     | id         |     | string | M Shop id                        |     |
| --- | ---------- | --- | ------ | -------------------------------- | --- |
|     | providerId |     | String | M Trigram unique shop Identifier |     |
|     | name       |     | String | M Shop name                      |     |

liveShop Object M Aggregation of all linear channels providing from
cup shop or live shop
| total |     |     | Int             | M   | Total of Linear Channels |     |
| ----- | --- | --- | --------------- | --- | ------------------------ | --- |
| items |     |     | Array of Object | O   | List of Linear Channels  |     |
LiveShopBucketIte
Présent même si vide
m extends
LiveShopBucketIte
mBase
|     | id   |     | string | M   | Linear Channel id |     |
| --- | ---- | --- | ------ | --- | ----------------- | --- |
|     | lcn  |     | Int    | O   | Channel number    |     |
|     | name |     | String | M   | Channel name      |     |
collections Array Object M List of all the shops the channel is included in
CollectionBase
|     |     | id   | String      | M   | Shop id   |     |
| --- | --- | ---- | ----------- | --- | --------- | --- |
|     |     | type | String/Enum | M   | Shop type |     |
Possible values : CUP_SHOP, VOD_SHOP,
LIVE_SHOP
|     |     | name | String | M   | Shop name |     |
| --- | --- | ---- | ------ | --- | --------- | --- |
7.3.1.3 ApplicationOfferItem
Extends OfferItemBase, the field must be set with value "APPLICATION".
|                  | Parameter |             | Type | Cardinality |                  | Description |
| ---------------- | --------- | ----------- | ---- | ----------- | ---------------- | ----------- |
| entitlementState |           | String/Enum |      | M           | Allowed values : |             |
ENTITLED
NOT_ENTITLED
commercial CommercialOffer M Commercial Informations about offer
Object
| parentalRating |     | String |     | M   | CSA level of the offer. |     |
| -------------- | --- | ------ | --- | --- | ----------------------- | --- |
Possible values :
CSA1, CSA2, CSA3, CSA4, CSA5
| partnerOfferUrl |     | String |     | O   | Partner's application url          |     |
| --------------- | --- | ------ | --- | --- | ---------------------------------- | --- |
| partnerOfferApk |     | String |     | O   | Partner's application package name |     |
trailerNonSubcribedOffer String O Video stream link for a non-subscribed customer
relatedBoutique String O Link between a collection and the offer
subscriptionType Double O Type of subscription for application offer
1 : Partner offer without account creation
2 : Partner offer with fluent account creation
3 : Partner offer with non-fluent account creation
finalActivationLink String O Activation Link to be called by devices
Computed by DALI
| activationLink |     | String |     | O   | Shapira activation link |     |
| -------------- | --- | ------ | --- | --- | ----------------------- | --- |

| infoPageTemplate |     | Double  | O   |     |     |
| ---------------- | --- | ------- | --- | --- | --- |
| hide             |     | Boolean | O   |     |     |
7.3.1.4 ServiceOfferItem
Extends CacheOfferItemBase, the field must be set with value "SERVICE".
|                  | Parameter | Type        | Cardinality |                  | Description |
| ---------------- | --------- | ----------- | ----------- | ---------------- | ----------- |
| entitlementState |           | String/Enum | M           | Allowed values : |             |
ENTITLED
NOT_ENTITLED
commercial CommercialOffer M Commercial Informations about offer
Object
relatedBoutique String O Link between a collection and the offer
7.3.1.5 MultiOfferItem
Extends CacheOfferItemBase, the field must be set with value "MULTIOFFER".
|                  | Parameter | Type        | Cardinality |                  | Description |
| ---------------- | --------- | ----------- | ----------- | ---------------- | ----------- |
| entitlementState |           | String/Enum | M           | Allowed values : |             |
ENTITLED
NOT_ENTITLED
commercial CommercialOffer M Commercial Informations about offer
Object
| parentalRating |     | String | M   | CSA level of the offer. |     |
| -------------- | --- | ------ | --- | ----------------------- | --- |
Possible values :
CSA1, CSA2, CSA3, CSA4, CSA5
relatedBoutique String O Link between a collection and the offer
7.3.1.3 UnmanagedApplicationOfferItem
Extends OfferItemBase, the field must be set with value "UNMANAGED_APPLICATION".
|                | Parameter | Type   | Cardinality |                         | Description |
| -------------- | --------- | ------ | ----------- | ----------------------- | ----------- |
| parentalRating |           | String | M           | CSA level of the offer. |             |
Possible values :
CSA1, CSA2, CSA3, CSA4, CSA5
| partnerOfferUrl |     | String | O   | Partner's application url          |     |
| --------------- | --- | ------ | --- | ---------------------------------- | --- |
| partnerOfferApk |     | String | O   | Partner's application package name |     |
trailerNonSubcribedOffer String O Video stream link for a non-subscribed customer
relatedBoutique String O Link between a collection and the offer
| hide |     | Boolean | O   |     |     |
| ---- | --- | ------- | --- | --- | --- |
7.3.2 CommercialOffer
7.3.2.1 CommercialOfferBase

|     | Parameter |     | Type | Cardinali | Description |
| --- | --------- | --- | ---- | --------- | ----------- |
ty
| id  |     |     | String | M Commercial offer id |     |
| --- | --- | --- | ------ | --------------------- | --- |
subscriptionStatus String M Status of the subscription, one of the following :
ACTIVE
ACTIVATING
DEACTIVATING
UNSPECIFIED
| commercialType |     |     | String/Enum | M Commercial type :  |     |
| -------------- | --- | --- | ----------- | -------------------- | --- |
BONUS
OPTION
OFFERED_SERVICE
PARTNER_SERVICE
| name |     |     | String | O Commercial name |     |
| ---- | --- | --- | ------ | ----------------- | --- |
originalAmount Float O The amount of the original transaction (before the Promotion
discount).
| customPriceLabel |     |     | String | O Price label |     |
| ---------------- | --- | --- | ------ | ------------- | --- |
Calculated by DALI
finalAmount Float O The final amount, after the Promotion discount has been applied.
You should use this sum to charge the card.
| promotions[] |     |     | Array of | O List of discounts on the offer |     |
| ------------ | --- | --- | -------- | -------------------------------- | --- |
promotion
Object
price Float M Amount of discount applicable for a specific Promotion (includes
decimal).
|     | customPromoLabel |     | String | O Promotion label |     |
| --- | ---------------- | --- | ------ | ----------------- | --- |
Calculated by DALI
|     | order          |     | Integer | O The order to apply multiple discounts  |     |
| --- | -------------- | --- | ------- | ---------------------------------------- | --- |
|     | applyTill      |     | Long    | O Duration the discount is still active  |     |
|     | expirationDate |     | Long    | O Discount expiration date               |     |
|     | duration       |     | Object  | O Discount duration                      |     |
PromotionDura
tion
|     |     | durationType | String/Enum | O Default value = forever |     |
| --- | --- | ------------ | ----------- | ------------------------- | --- |
Specifies the time duration for which this discount is attached to the
subscription.
Possible values are :
one_time => The discount stays attached to the subscription till it is
applied on an invoice once. It is removed after that from the
subscription.
forever => The discount is attached to the subscription and applied
on the invoices till it is explicitly removed.
limited_period => The discount is attached to the subscription and
applied on the invoices for a limited duration. This duration starts
from the point it is applied to an invoice for the first time and expires
after a period specified by period and period_unit

|     |     |     | period |     | Integer | O min=1 |     |     |
| --- | --- | --- | ------ | --- | ------- | ------- | --- | --- |
The duration of time for which the discount is attached to the
subscription, in period_units. Applicable only when duration_type is
limited_period.
periodUnit String/enum M The unit of time for period. Applicable only when duration_type is
limited_period.
Possible values are :
day – A period of 24 hours.
month – A period of 1 calendar month.
year – A period of 1 calendar year.
7.3.2.2 CommercialOfferUnSubscribe ==> subscriptionStatus == UNSPECIFIED
|     |     | Parameter |     |     | Type | Cardinalit |     | Description |
| --- | --- | --------- | --- | --- | ---- | ---------- | --- | ----------- |
y
| promotionalDescription |     |     |     | String |     | O Promotional Description |     |     |
| ---------------------- | --- | --- | --- | ------ | --- | ------------------------- | --- | --- |
7.3.2.3 CommercialOfferSubscribe ==>  subscriptionStatus != UNSPECIFIED
|           |     | Parameter |      | Type | Cardinality |            |     | Description |
| --------- | --- | --------- | ---- | ---- | ----------- | ---------- | --- | ----------- |
| startDate |     |           | Long |      | O           | Start date |     |             |
| endDate   |     |           | Long |      | O           | End date   |     |             |
partner Partner Object O Informations about the partner. Should be only present for
ApplicationOfferItem objects
|     |     | id     | String |     | O   |                    |     |     |
| --- | --- | ------ | ------ | --- | --- | ------------------ | --- | --- |
|     |     | status | String |     | M   | Possible values :  |     |     |
ACTIVE, CANCELED, CREATED, INACTIVE, NON-EXISTENT,
UNSUBSCRIBED
7.3.3 Options
|     | Parameter |     | Type | Cardinalit |     |     | Description |     |
| --- | --------- | --- | ---- | ---------- | --- | --- | ----------- | --- |
y
| entitledOptions |     | Array of |     | M   | List of entitled options |     |     |     |
| --------------- | --- | -------- | --- | --- | ------------------------ | --- | --- | --- |
EntitledOptions
|      | name   | String  |     | M   | Option Name    |     |     |     |
| ---- | ------ | ------- | --- | --- | -------------- | --- | --- | --- |
|      | status | Boolean |     | O   | Option status  |     |     |     |
|      | value  | String  |     | O   | Option value   |     |     |     |
| type |        | String  |     | M   | Type of option |     |     |     |
7.3.4 AllOfferItems
|     | Parameter |     | Type |     | Cardinali |     | Description |     |
| --- | --------- | --- | ---- | --- | --------- | --- | ----------- | --- |
ty
| data |     | Array of Objects |     |     | O   | List of offers |     |     |
| ---- | --- | ---------------- | --- | --- | --- | -------------- | --- | --- |
OfferItem

| totalElements | Integer               | M Number of elements in data array |     |     |     |
| ------------- | --------------------- | ---------------------------------- | --- | --- | --- |
| totalPages    | Integer               | M Total number of pages returned   |     |     |     |
| currentPage   | Integer               | M Number of the page returned      |     |     |     |
| links         | object OfferItemLinks | O Links                            |     |     |     |
| first         | object GetLink        | O First page of results            |     |     |     |
| self          | object GetLink        | M Current page of results          |     |     |     |
| next          | object GetLink        | O Next page of results             |     |     |     |
| last          | object GetLink        | O Last page of results             |     |     |     |
| offer         | object GetLink        | M Get all offers for this contract |     |     |     |
7.3.5 Links
7.3.5.1 GetLink
| Parameter | Type | Cardinalit |     | Description |     |
| --------- | ---- | ---------- | --- | ----------- | --- |
y
| href     | String | O href     |     |     |     |
| -------- | ------ | ---------- | --- | --- | --- |
| endpoint | String | O Endpoint |     |     |     |
| type     | String | O Type     |     |     |     |
Default : "GET"
7.3.5.2 PostLink
| Parameter | Type | Cardinalit |     | Description |     |
| --------- | ---- | ---------- | --- | ----------- | --- |
y
| href     | String | O href     |     |     |     |
| -------- | ------ | ---------- | --- | --- | --- |
| endpoint | String | O Endpoint |     |     |     |
| type     | String | O Type     |     |     |     |
Default : "POST"
9 PROCESS DESCRIPTION V2
9.1 Common API Definition
9.1.1 Request Headers
| Parameter      | Type                              |     | Description |     | Constraints |
| -------------- | --------------------------------- | --- | ----------- | --- | ----------- |
| x-kaltura-api- | String Kaltura API Version Number |     |             |     | MANDATORY   |
version
| x-Dpps-Trace- | String Contract Id of the user |     |     |     |     |
| ------------- | ------------------------------ | --- | --- | --- | --- |
MANDATORY
| idcontracts   | Filled by APIM        |     |     |     |     |
| ------------- | --------------------- | --- | --- | --- | --- |
| x-Dpps-Trace- | String Id of the user |     |     |     |     |
MANDATORY
pfsnocompte
| x-version | String DALI Offer API Version Number |     |     |     | OPTIONAL |
| --------- | ------------------------------------ | --- | --- | --- | -------- |
x-request-id String Request identifier on the IS (unique identifier generated during the call to each
resource if not present at the input and provided to each service called synchronousl

x-source String Name of the sender of the request
x-message-id String Unique for each interaction between ST (it can be used to manage anti-replay on
power supplies for example)
9.2 GET
9.2.1 Operation : Get Offer
Gets an offer for a user :
by commercialId
9.2.1.1 API Request
9.2.1.1.1 Headers
Input Description Constraints
x-dsi-atk-basic Access ToKen DSI MANDATORY
Filled by APIM
9.2.1.1.2 Query Parameters
Input Description Constraints
commercialId Commercial Offer Id MANDATORY
9.2.1.2 API Response
HTTP Description Schema
Code
200 OK List of BouquetOfferItem,
ApplicationOfferItem, ServiceOfferItem,
MultiOfferItem
400 Bad Request (with error = Bad Request) ApiError
401 INVALID_TOKEN : Invalid Token ApiError
404 Not Found ApiError
Possible resultMessage values:
- CUSTOMER_NOT_FOUND : Customer Not Found
405 Method Not Allowed ApiError
500 Internal error (with error INTERNAL_SERVER_ERROR : Internal Server Error) ApiError
502 External error (with error EXTERNAL_SERVER_ERROR : External Server Error) ApiError
9.2.1.3 Activity Diagram

9.2.1.4Validate Data Request
9.2.1.4.1 Input
| Parameters | Type |     | Description |     | Constraints |
| ---------- | ---- | --- | ----------- | --- | ----------- |
oRequest Object Abstract and technical object grouping all the informations provided in input service trueRedMANDATORY
9.2.1.4.2 Output
| Parameter |     | Type |     | Description | Constraints |
| --------- | --- | ---- | --- | ----------- | ----------- |
oExecutionResult ExecutionResult Represents the operation execution state MANDATORY
9.2.1.4.3 Treatment
1 Perform surface checks using document [R1]
| 2 if (The interface | specification not respected) |     |     |     |     |
| ------------------- | ---------------------------- | --- | --- | --- | --- |
3 Return Error and Exit processing : NOK/CAT-3/BAD_REQUEST/The label must specify the name of the field in error as well as an indication of the err
4 End
9.2.1.6 Format Response
9.2.1.6.1Input
| Parameter | Type |     | Description |     | Constraints |
| --------- | ---- | --- | ----------- | --- | ----------- |
oResponseIN Object Abstract and technical object grouping all the information provided
CONDITIONAL
in input service
MANDATORY : When
oExecutionResultIN.status = KO

| oExecutionResult ExecutionR | Represents the operation execution state |     |     |
| --------------------------- | ---------------------------------------- | --- | --- |
MANDATORY
IN esult
9.2.1.6.2 Output
| Parameter        | Type                                              | Description | Constraints |
| ---------------- | ------------------------------------------------- | ----------- | ----------- |
| oExecutionResult | Executio Represents the operation execution state |             |             |
MANDATORY
nResult
9.2.1.6.3 Treatment
1 If oExecutionResult.status == KO
2 return error
3 Else
4 if oCommercialOfferItem != null AND oCommercialOfferItem.commercialType is not included in COMMERCIAL_TYPES_BLACKLIST
5 oOfferItem = MapCommercialOfferItemToOfferItem(oCommercialOfferItem)
6
7 if oOfferItem.category == APPLICATION and oOfferItem.subscriptionType == 2 // Application partenaire non fluide avec création de compte
8 if oOfferItem.entitledmentState ==  ENTITLED && oOfferItem.activationLink != null
9 oOfferItem.finalActivationLink = oOfferItem.activationLink + oCommercialOfferItem.id
10 endif
11 endif
12
13 oResponse.add(oOfferItem)
14 endif
15 Endif
9.2.2 Operation : List
Gets all offers for a user. The list of obtained offers can by filtered by :
offer item category
entitlementState
paging
9.2.2.1 API Request
9.2.2.1.1 Headers
| Input                            | Description | Constraints |     |
| -------------------------------- | ----------- | ----------- | --- |
| x-dsi-atk-basic Access ToKen DSI |             |             |     |
MANDATORY
Filled by APIM
| If-None-Match |     | OPTIONAL |     |
| ------------- | --- | -------- | --- |
9.2.2.1.2 Query Parameters
| Input                                              |     | Description | Constraints |
| -------------------------------------------------- | --- | ----------- | ----------- |
| categories Array of String - Offer item categories |     |             |             |
OPTIONAL
Possible values :
BOUQUET
APPLICATION
SERVICE
MULTIOFFER
UNMANAGED_APPLICATION
| entitlementState Entitlement state |     |     |     |
| ---------------------------------- | --- | --- | --- |
OPTIONAL
| Possible values :  |     |     | Must be null |
| ------------------ | --- | --- | ------------ |
| ENTITLED           |     |     | when         |
| NOT_ENTITLED       |     |     | queryPara    |
ms
categori

es is
not
set.
queryPara
ms
categori
es
contains
UNMANAGE
D_APPLIC
ATION.
9.2.2.2 API Response
9.2.2.2.1 Response headers
Name Description Constraints
ETag String OPTIONAL
Entity tag for current customer records list.
Returned Only if pagination not used and HTTP Code == 200 or 304
9.2.2.2.2 Response Schema
HTTP Description Schema
Code
200 OK List of Objects AllOfferItem
304 Not Modified
400 Bad Request (with error = Bad Request) ApiError
401 INVALID_TOKEN : Invalid Token ApiError
404 Not Found ApiError
Possible resultMessage values:
- CUSTOMER_NOT_FOUND : Customer Not Found
405 Method Not Allowed ApiError
500 Internal error (with error INTERNAL_SERVER_ERROR : Internal ApiError
Server Error)
502 External error (with error EXTERNAL_SERVER_ERROR : External ApiError
Server Error)
9.2.2.3 Activity Diagram

9.2.2.4Validate Data Request
9.2.2.4.1 Input
Parameter Type Description Constraints
oRequest Object Abstract and technical object grouping all the informations provided in input service trueRedMANDATORY
9.2.2.4.2 Output
Parameter Type Description Constraints
oExecutionResult ExecutionResult Represents the operation execution state MANDATORY
9.2.2.4.3 Treatment
1 Perform surface checks using document [R1]
2 if (The interface specification not respected)
3 Return Error and Exit processing : NOK/CAT-3/BAD_REQUEST/The label must specify the name of the field in error as well as an indication of the err
4 End
5
6 If (categories null or categories contains 'UNMANAGED_APPLICATION') AND entitlementState != null
7 Return Error and Exit processing : NOK/CAT-3/BAD_REQUEST/EntitlementState is not consistant with unmanaged applications
8 End
9.2.2.7 Format Response
9.2.2.7.1Input
Parameter Type Description Constraints
oResponseIN objet Abstract and technical object grouping all the information CONDITIONAL
provided in input service
MANDATORY : When oExecutionResultIN.status =
KO

| oExecutionResult ExecutionR | Represents the operation execution state |     |     |
| --------------------------- | ---------------------------------------- | --- | --- |
MANDATORY
| IN esult |     |     |     |
| -------- | --- | --- | --- |
9.2.2.7.2 Output
| Parameter        | Type                                              | Description | Constraints |
| ---------------- | ------------------------------------------------- | ----------- | ----------- |
| oExecutionResult | Executio Represents the operation execution state |             |             |
MANDATORY
nResult
9.2.2.7.3 Treatment
1 If oExecutionResult.status == KO
2 return error
3 Else
| 4 If categories != | 'UNMANAGED_APPLICATION' |     |     |
| ------------------ | ----------------------- | --- | --- |
5 Foreach oCommercialOfferItem in oResponseOffresAdditionnelles
6 if oCommercialOfferItem.commercialType is not included in COMMERCIAL_TYPES_BLACKLIST
| 7 oOfferItem = | MapCommercialOfferItemToOfferItem(oCommercialOfferItem) |     |     |
| -------------- | ------------------------------------------------------- | --- | --- |
8
9 if oOfferItem.category == APPLICATION and oOfferItem.subscriptionType == 2 // Application partenaire non fluide avec création de comp
10 if oOfferItem.entitledmentState == ENTITLED && oOfferItem.activationLink != null
11 oOfferItem.finalActivationLink = oOfferItem.activationLink + oCommercialOfferItem.id
| 12 endif |     |     |     |
| -------- | --- | --- | --- |
| 13 endif |     |     |     |
14
| 15 oResponse.add(oOfferItem) |     |     |     |
| ---------------------------- | --- | --- | --- |
16 endif
17 EndFor
18 Endif
19
20 If categories == null OR categories contains 'UNMANAGED_APPLICATION'
21 Add CacheUnmanagedApplicationOfferItem[] objects from cache
22 EndIf
23
24 ETag.compute(oResponse)
25
26 If oSTI.If-None-Match != null and ETag == oSTI.If-None-Match
| 27 return 304 Not Modified |     |     |     |
| -------------------------- | --- | --- | --- |
28 EndIf
29 Endif
9.2.3 Operation : Check Offer
Check If offer
9.2.2.1 API Request
9.2.2.1.1 Headers
| Input           | Description      | Constraints |     |
| --------------- | ---------------- | ----------- | --- |
| x-dsi-atk-basic | Access ToKen DSI | MANDATORY   |     |
Filled by APIM
| x-kaltura-secret | Header containing Kaltura Secret  |     |     |
| ---------------- | --------------------------------- | --- | --- |
MANDATORY
If-None-Match
OPTIONAL
| X-Dpps-Trace- |     | MANDATORY |     |
| ------------- | --- | --------- | --- |
idcontracts
x-Dpps-Trace-
OPTIONAL
pfsnocompte
9.2.2.1.2 Query Parameters
| Input      |                                         | Description | Constraints |
| ---------- | --------------------------------------- | ----------- | ----------- |
| categories | Array of String - Offer item categories |             |             |
OPTIONAL
Possible values :
BOUQUET
APPLICATION

SERVICE
MULTIOFFER
UNMANAGED_APPLICATION
entitlementState Entitlement state
Possible values :
ENTITLED
NOT_ENTITLED
9.2.3.2 API Response
HTTP Description Schema
Code
204 OK
304 OK Etag
400 Bad Request (with error = Bad Request) ApiError
405 Method Not Allowed ApiError
500 Internal error (with error INTERNAL_SERVER_ERROR : Internal Server Error) ApiError
503 Internal error (with error INTERNAL_SERVER_ERROR : Internal Server Error) ApiError
502 External error (with error EXTERNAL_SERVER_ERROR : External Server Error) ApiError
8.2.4.1.3 Treatment
Contenu non pris en charge
if categories is empty
categories = oConfiguration.app.defaultCategories
endIf
oOfferEtagsThrottlingApiDsi = HazelCast.OfferEtagsThrottlingApiDsiCache [ {X-Dpps-Trace-idcontracts }-{x-etag-api-offers-list} ]
oThrottlingApiDsiContext =queryAndUpSertToOfferMetadataThrottlingApiDsiCachCache(idContract, ks, categories)
ifoThrottlingApiDsiContext!= null
if oCacheOfferCustomerValidity[ {X-Dpps-Trace-idcontracts }-{x-etag-api-offers-list}
].managedOffer.equals(oThrottlingApiDsiContext.managedOffer) || ( ( catagories.contain(UNMANAGED_APPLICATION) &&
oCacheOfferCustomerValidity[ {X-Dpps-Trace-idcontracts }-{x-etag-api-offers-list}
].unmanagedOffer.equals(oThrottlingApiDsiContext.unmanagedOffer))
return 304 with header ETag
endIf
endIf
Return 210
9.3 POST
9.3.1 Operation : Subscribe Offer

The purpose of this operation is to request the subscription or activation of a commercial offer from the DSI.
The objective is to restore the subscribed offer and its characteristics in the DALI return.
Limit cases :
In the event that the offer is already subscribed on the DSI side, DALI responds http code 200 with the subscribed offer and its characteristics
returned
9.3.1.1 API Request
9.3.1.1.1 Header
| Input              |                  | Description | Constraints |     |     |
| ------------------ | ---------------- | ----------- | ----------- | --- | --- |
| x-dsi-atk-moderate | Access ToKen DSI |             | MANDATORY   |     |     |
Filled by APIM
| x-Dpps-Trace-idcontracts | Contract Id |     |     |     |     |
| ------------------------ | ----------- | --- | --- | --- | --- |
MANDATORY
Filled by APIM
| x-Dpps-Trace- | Client Id |     | MANDATORY |     |     |
| ------------- | --------- | --- | --------- | --- | --- |
pfsnocompte
Filled by APIM
9.3.1.1.2 Query Parameters
| Input | Type | Description |     | Constraints |     |
| ----- | ---- | ----------- | --- | ----------- | --- |
force Boolean Force Call check Compatibility Offer Default Value False
| idCommercialOffer | String | idCommercialOffer |     |     |     |
| ----------------- | ------ | ----------------- | --- | --- | --- |
MANDATORY
9.3.1.2 API Response
| HTTP Code        |     | Description |     |                     | Schema |
| ---------------- | --- | ----------- | --- | ------------------- | ------ |
| 200 OK           |     |             |     | Object AllOfferItem |        |
| 400 Bad Request  |     |             |     | ApiError            |        |
Possible error values :
- Bad Request
- Invalid Offer
| 401 Invalid Token |     |     |     | ApiError |     |
| ----------------- | --- | --- | --- | -------- | --- |
Possible error value : Invalid Token
| 403 Forbidden |     |     |     | ApiError |     |
| ------------- | --- | --- | --- | -------- | --- |
Possible error values :
- Customer Suspended
- Unable Purchase Free
- Unable Purchase Offer Purchased
| 404 Not Found |     |     |     | ApiError |     |
| ------------- | --- | --- | --- | -------- | --- |
Possible error values :
- Customer Not Found
- Purchase Failed
- Offer Not Found
| 405 Method Not Allowed |     |     |     | ApiError |     |
| ---------------------- | --- | --- | --- | -------- | --- |
Possible error value : Method Not Allowed
| 409 Conflict |     |     |     | ApiError |     |
| ------------ | --- | --- | --- | -------- | --- |

Possible error value : Incompatible offer
500 Internal Server Error ApiError
Possible error value : Internal Server Error
502 External Server Error ApiError
Possible error value : External Server Error
9.3.1.3 Activity Diagram

9.3.1.4Validate Data Request
9.3.1.4.1 Input
| Parameter | Type | Description | Constraints |
| --------- | ---- | ----------- | ----------- |
oRequest Object Abstract and technical object grouping all the informations provided in input service trueRedMANDATORY

9.3.1.4.2 Output
|     | Parameter | Type |     | Description | Constraints |
| --- | --------- | ---- | --- | ----------- | ----------- |
oExecutionResult ExecutionResult Represents the operation execution state MANDATORY
9.3.1.4.3 Treatment
1 Perform surface checks using document [R1]
| 2 if (The interface | specification not respected) |     |     |     |     |
| ------------------- | ---------------------------- | --- | --- | --- | --- |
3 Return Error and Exit processing : NOK/CAT-3/BAD_REQUEST/The label must specify the name of the field in error as well as an indication of the err
4 End
9.3.1.5 Format Response
9.3.1.5.1Input
| Parameter | Type |     | Description |     | Constraints |
| --------- | ---- | --- | ----------- | --- | ----------- |
oResponseIN objet Abstract and technical object grouping all the information CONDITIONAL
provided in input service
MANDATORY : When oExecutionResultIN.status = KO
| oExecutionResul | Execution | Represents the operation execution state |     |     |     |
| --------------- | --------- | ---------------------------------------- | --- | --- | --- |
MANDATORY
| tIN | Result |     |     |     |     |
| --- | ------ | --- | --- | --- | --- |
9.3.1.5.2 Output
|                  | Parameter | Type                                              |     | Description | Constraints |
| ---------------- | --------- | ------------------------------------------------- | --- | ----------- | ----------- |
| oExecutionResult |           | Executio Represents the operation execution state |     |             |             |
MANDATORY
nResult
9.3.1.5.3 Treatment
1 if oExecutionResultIN.status == KO
2 return error
3 else
| 4 return | 200 OK + object oSubscribedOffer + objects oImpactedOffers |     |     |     |     |
| -------- | ---------------------------------------------------------- | --- | --- | --- | --- |
5
6 if oResponseOffreAdditionnelles[request.offrePanier.offresAdditionnelles.idOffre] != null
7 oSubscribedOffer = oResponseOffreAdditionnelles[request.offrePanier.offresAdditionnelles.idOffre]
8 oSubscribedOffer.commercial.commercialType = translate(oResponseImpactSouscriptionOffresAdditionnelles.impactOffresAdditionnelles.offresAddit
9 if oSubscribedOffer.category == APPLICATION and subscriptionType == 3 // Application partenaire fluide avec création de compte
10 if oResponseImpactSouscriptionOffresAdditionnelles[idOffre == request.offrePanier.offresAdditionnelles.idOffre] != null && oSubscribedOff
11 oSubscribedOffer.finalActivationLink = oSubscribedOffer.activationLink + oResponseImpactSouscriptionOffresAdditionnelles[idOffre == r
| 12  | endif |     |     |     |     |
| --- | ----- | --- | --- | --- | --- |
13 elseif oSubscribedOffer.category == APPLICATION and subscriptionType == 2 // Application partenaire non fluide avec création de compte
14 if oResponseImpactSouscriptionOffresAdditionnelles[idOffre == request.offrePanier.offresAdditionnelles.idOffre] != null && oSubscribedOff
15 oSubscribedOffer.finalActivationLink = oSubscribedOffer.activationLink + request.offrePanier.offresAdditionnelles.idOffre
| 16  | endif |     |     |     |     |
| --- | ----- | --- | --- | --- | --- |
17 endif
18
19 else
20 oSubscribedOffer = oResponseOffreAdditionnellesSouscriptibles[request.offrePanier.offresAdditionnelles.idOffre]
21 oSubscribedOffer.commercial.commercialType = translate(oResponseImpactSouscriptionOffresAdditionnelles.impactOffresAdditionnelles.offresAddit
| 22  | oSubscribedOffer.entitlementState =              | 'ENTITLED' |              |     |     |
| --- | ------------------------------------------------ | ---------- | ------------ | --- | --- |
| 23  | oSubscriberOffer.commercial.subscriptionStatus = |            | 'ACTIVATING' |     |     |
24 if oResponseCreerCommande != null
25 oSubscriberOffer.commercial.startDate = convertToDate(oResponseCreerCommande.offresAdditionnelles.dateEffet)
26 else
| 27  | oSubscriberOffer.commercial.startDate = null |     |     |     |     |
| --- | -------------------------------------------- | --- | --- | --- | --- |
28 endif
29 oSubscriberOffer.promotionalDescription = null
30 if oSubscribedOffer.category == APPLICATION and subscriptionType == 3 // Application partenaire fluide avec création de compte
31 if oResponseImpactSouscriptionOffresAdditionnelles[idOffre == request.offrePanier.offresAdditionnelles.idOffre] != null && oSubscribedOff
32 oSubscribedOffer.finalActivationLink = oSubscribedOffer.activationLink + oResponseImpactSouscriptionOffresAdditionnelles[idOffre == r
33     endif
| 34  | oSubscribedOffer.commercial.partner.status = |     | 'CREATED' |     |     |
| --- | -------------------------------------------- | --- | --------- | --- | --- |
35 elseif oSubscribedOffer.category == APPLICATION and subscriptionType == 2 // Application partenaire non fluide avec création de compte
36 if oResponseImpactSouscriptionOffresAdditionnelles[idOffre == request.offrePanier.offresAdditionnelles.idOffre] != null && oSubscribedOff
37 oSubscribedOffer.finalActivationLink = oSubscribedOffer.activationLink + request.offrePanier.offresAdditionnelles.idOffre
| 38  | endif                                        |     |           |     |     |
| --- | -------------------------------------------- | --- | --------- | --- | --- |
| 39  | oSubscribedOffer.commercial.partner.status = |     | 'CREATED' |     |     |
40 endif
41 endif
42
43 oImpactedOffers = list<oResponseImpactSouscriptionOffresAdditionnelles[action="RESILIATION" && idOffre != request.offrePanier.offresAdditionnelle
44 foreach oImpactedOffer de oImpactedOffers
| 45  | oImpactedOffer.entitlementState =                | 'NOT_ENTITLED' |               |     |     |
| --- | ------------------------------------------------ | -------------- | ------------- | --- | --- |
| 46  | oSubscriberOffer.commercial.subscriptionStatus = |                | 'UNSPECIFIED' |     |     |
47 oSubscriberOffer.commercial.startDate = null

48 oSubscriberOffer.commercial.endDate = null
49 end foreach
50
51 endif
9.4 DELETE
9.4.1 Operation : Unsubscribe Offer
The purpose of this operation is to request the unsubscription of a commercial offer from the DSI.
The objective is to restore the unsubscribed offer and its characteristics in the DALI return.
Limit cases :
In the event that the offer is already deleted on the DSI side, DALI responds http code 200 with the canceled offer and its characteristics returned
In the event that the offer is already being deleted on the DSI side, DALI responds http code 200 with the canceled offer and its characteristics
returned
In case the offer cannot be canceled, DALI responds http code 403 Cancellation Not Allowed
9.4.1.1 API Request
9.5.1.1.1 Header
| Input              | Description      |     | Constraints |     |     |
| ------------------ | ---------------- | --- | ----------- | --- | --- |
| x-dsi-atk-moderate | Access ToKen DSI |     | MANDATORY   |     |     |
Filled by APIM
| x-Dpps-Trace-idcontracts | Contract Id |     |     |     |     |
| ------------------------ | ----------- | --- | --- | --- | --- |
MANDATORY
Filled by APIM
| x-Dpps-Trace- | Client Id      |     | MANDATORY |     |     |
| ------------- | -------------- | --- | --------- | --- | --- |
| pfsnocompte   | Filled by APIM |     |           |     |     |
9.4.1.1.2 Query Parameters
| Input   | type                          | Description |             | Constraints |     |
| ------- | ----------------------------- | ----------- | ----------- | ----------- | --- |
| idOffer | String Not used at the moment |             | CONDITIONAL |             |     |
Mandatory : When idCommercialOffer is null or empty
| idCommercialOffer | String |     |     |     |     |
| ----------------- | ------ | --- | --- | --- | --- |
CONDITIONAL
Mandatory : When idOffer is null or empty
9.4.1.2 API Response
| HTTP |     | Description |     |     | Schema |
| ---- | --- | ----------- | --- | --- | ------ |
Code
| 200 OK                                    |     |     |     | List of Objects OfferItem |     |
| ----------------------------------------- | --- | --- | --- | ------------------------- | --- |
| 400 Bad Request (with error =Bad Request) |     |     |     | ApiError                  |     |
| 401 INVALID_TOKEN :  Invalid Token        |     |     |     | ApiError                  |     |
- INVALID_TOKEN : Token Expired
| 403 Forbidden |     |     |     | ApiError |     |
| ------------- | --- | --- | --- | -------- | --- |
Possible resultMessage values :
CANCELLATION_NOT_ALLOWED : Cancellation Not Allowed
| 404 Not Found |     |     |     | ApiError |     |
| ------------- | --- | --- | --- | -------- | --- |
Possible resultMessage values:
- CUSTOMER_NOT_FOUND : Customer Not Found

- CANCELLATION_FAILED : Cancellation Not Allowed with additionalInfo have keys
originalErrorCode, originalErrorReason
500 Internal error (with error INTERNAL_SERVER_ERROR :Internal Server Error) ApiError
9.4.1.3 Activity Diagram
9.4.1.4Validate Data Request
9.4.1.4.1 Input
Parameters Type Description Constraints
oRequest object Abstract and technical object grouping all the informations provided in input service trueRedMANDATORY
9.4.1.4.2 Output
Parameter Type Description Constraints
oExecutionResult ExecutionResult Represents the operation execution state MANDATORY
9.4.1.4.3 Treatment
1 Perform surface checks using document [R1]

| 2 if (The interface | specification not respected) |     |     |     |     |
| ------------------- | ---------------------------- | --- | --- | --- | --- |
3 Return Error and Exit processing : NOK/CAT-3/BAD_REQUEST/The label must specify the name of the field in error as well as an indication of the err
4 End
9.4.1.5 Format Response
DSI limitation : after a subscription or unsubscription return, there is a delay of update for offers. Although, we cannot call synchronously DSI to get
offers updated status.
Temporary behaviour while waiting for the project to implement Firebase DSI notifications :
DALI has to build itself an oUnsubscribedOffer object from :
enrichment by GET
unsubscription return
9.4.1.5.1Input
| Parameter | Type |     |     | Description | Constraints |
| --------- | ---- | --- | --- | ----------- | ----------- |
oResponseIN objet Abstract and technical object grouping all the information CONDITIONAL
provided in input service
MANDATORY : When oExecutionResultIN.status
= KO
| oResponseResiliati | objet | Abstract and technical object grouping all the datas from |     |     |     |
| ------------------ | ----- | --------------------------------------------------------- | --- | --- | --- |
OPTIONAL
| on  |     | unsubscription return |     |     |     |
| --- | --- | --------------------- | --- | --- | --- |
oExecutionResultI ExecutionRes Represents the operation execution state MANDATORY
| N   | ult |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
9.4.1.5.2 Output
| Parameter        |                 | Type |                                          | Description | Constraints |
| ---------------- | --------------- | ---- | ---------------------------------------- | ----------- | ----------- |
| oExecutionResult | ExecutionResult |      | Represents the operation execution state |             |             |
MANDATORY
9.4.1.5.3 Treatment
1 if oExecutionResultIN.status == KO
2 return error
3 else
| 4 return 200 OK + object oUnsubscribedOffer |     |     |     |     |     |
| ------------------------------------------- | --- | --- | --- | --- | --- |
5
6 oUnsubscribedOffer = oResponseIN
7 if oResponseResiliation != null
| 8 oUnsubscribedOffer.entitlementState =              |     |     | 'ENTITLED' |                |     |
| ---------------------------------------------------- | --- | --- | ---------- | -------------- | --- |
| 9 oUnsubscribedOffer.commercial.subscriptionStatus = |     |     |            | 'DEACTIVATING' |     |
10 oUnsubscribedOffer.commercial.endDate = oResponseResiliation.commande.dateResiliationEcheance
11 endif
12 endif