# Offers Product Knowledge Base

Status: working knowledge base for the STB/device product specification. This is a synthesis of the documents below, the validated v2.1 product behavior, and decisions confirmed in the review. It is not a replacement for the current DALI Swagger.

## Sources and Authority

1. `subscriptions-offers-v2.1.md` is the validated product behavior baseline. Preserve its rules unless the user explicitly changes them.
2. `DPI-API-V2.markitdown.md` is the MarkItDown extraction of `DPI-API V2-121126-175023.pdf`. It contains the detailed DALI v2 interface and response model, mixed with DALI implementation flow. Use its device-facing contract as a working reference; the current Swagger is authoritative for exact paths, verbs, schemas, and errors.
3. `DALI-lot-2-nPFS-offers-v2.markitdown.md` is the extraction of `ETDDPPS-SAG - P01558 - DALI lot 2 nPFS - offers v2 [IN PROGRESS]-121126-175006.pdf`. The source is explicitly in progress and its document history says v0.1, May 2024. Use it for context and historical product requirements, not as the current API contract.
4. `../swagger_offer_v2.json` is the current OpenAPI 3.1 contract supplied by the user. It is authoritative for published operations, parameters, schemas, and documented responses, while any contradictions or omissions within it remain explicit open questions.
5. `../offers_list.json` is one real list response containing 70 offers. It demonstrates possible payloads and status combinations, but is not exhaustive and does not define universal behavior.
6. The current product draft is `../subscriptions-offers-v2.3.md`, based on `../subscriptions-offers-v2.2-reorganisee.md` with review annotations removed. Screen layouts and UI illustrations are examples only; product requirements concern data, actions, and behavior.

The MarkItDown files are raw conversions. Their tables may be split or misaligned, and embedded diagrams are not reliably represented. Check the original PDFs or Swagger before relying on an ambiguous extraction.

## Product Boundary

The product/device owns local offer data, invokes DALI through the device API path, interprets the returned offer data and action links, validates the purchase PIN for subscribe/unsubscribe flows, and presents the resulting product behavior. It does not own DALI's DSI connectors, cache implementation, token exchange, backend aggregation, throughput limits, or internal call ordering.

Keep screen layout and visual choices non-normative. Product requirements may specify what data or action is available and the state-dependent behavior, but should not prescribe a particular screen design unless the user confirms that requirement.

## Offer Model

Offer categories in the v2 contract are `BOUQUET`, `APPLICATION`, `SERVICE`, `MULTIOFFER`, and `UNMANAGED_APPLICATION`.

The common offer data used by the product includes the offer identifiers, category, title/name and description, images, genres, editorial weight, commercial data, options, and HATEOAS links. Offer types add category-specific data:

- `BOUQUET` can contain live, replay, and SVOD shop/catalog data.
- `APPLICATION` can contain partner application identifiers/URLs, `subscriptionType`, `activationLink`, `finalActivationLink`, and partner status in `commercial.partner`.
- `SERVICE` and `MULTIOFFER` have their own category and commercial data.
- `UNMANAGED_APPLICATION` is partner metadata not managed by the DSI offer lifecycle. Its v2 model does not carry the normal entitlement state and subscribe/unsubscribe action links; do not infer those fields for it.

Commercial price and promotion data include `originalAmount`, `finalAmount`, `promotions[]`, promotion duration, and optional display labels. Use the actual response fields; do not derive missing fields by assumption.

## Status Dimensions

The user confirmed that these fields describe distinct dimensions:

- `commercial.subscriptionStatus` describes the state of the subscription process, not by itself whether the customer is subscribed. Values in the DALI v2 model include `ACTIVE`, `ACTIVATING`, `DEACTIVATING`, and `UNSPECIFIED`.
- `entitlementState` indicates whether the offer is subscribed/entitled (`ENTITLED`) or not (`NOT_ENTITLED`).
- `commercial.partner.status` indicates partner-account activation state. Creating a Disney+ subscription can leave partner activation pending until the customer creates or activates the partner account. Swagger lists `ACTIVE`, `CANCELED`, `CREATED`, `INACTIVE`, `NON_EXISTENT`, and `UNSUBSCRIBED`.

The DALI v2 response model exposes the subscribe action when `entitlementState == NOT_ENTITLED` and the unsubscribe action when `entitlementState == ENTITLED`. The product should use the action links returned by the offer rather than synthesize DALI endpoints. The API specification gives these transition examples:

- A successful subscription can return `ENTITLED` with `subscriptionStatus == ACTIVATING`.
- A subscription involving partner account creation can return `partner.status == CREATED` while the offer is entitled.
- A pending unsubscription can return `ENTITLED` with `subscriptionStatus == DEACTIVATING`, and an effective end date.
- Offers removed as an impact of a confirmed incompatible-offer flow can return `NOT_ENTITLED` and `UNSPECIFIED`.

The sample JSON includes `DEACTIVATING / ENTITLED / CREATED` for Disney+, confirming that the fields must not be collapsed into one status. The user-confirmed product behavior is:

- `ACTIVATING` with `ENTITLED`: after the local `TRANSIENT` period, stop offering “Subscribe” and show subscription management; allow unsubscribe only when DALI provides that action link.
- `DEACTIVATING` with `ENTITLED`: display “Résiliation en cours” and do not send another unsubscribe request.
- `partner.status=CREATED` with `ENTITLED`: show both partner activation and subscription management. Hide the activation flow when `partner.status=ACTIVE`.
- In a conflict, `subscriptionStatus` takes precedence only for the displayed process state. `entitlementState` and DALI action links govern entitlement and available API actions.

No fallback is defined for a missing status field; handling that case is out of scope for now.

## Device-Facing API Surface

The OpenAPI 3.1 file `../swagger_offer_v2.json` is the current device-facing contract. Use the HATEOAS `actions` links returned by offers rather than constructing action URLs.

- **GET `/api/offers`:** the product sends no `categories` filter and omits `entitlementState` to retrieve all categories and both entitled/unentitled offers; `fields` is optional and `If-None-Match` is sent when an ETag is stored. A `200` response is `OfferItemList` (`data`, `totalElements`, `totalPages`, `currentPage`, `links`); `304` is also documented. Product decision: make one List request, treat `data` as the full snapshot, and do not process `links.next` or page counters. On `304`, keep local data; on `200`, replace the local snapshot. Update the stored ETag only when a response ETag is present; if absent, retain the previous value. After subscribe/unsubscribe, apply the mutation response locally and leave the ETag unchanged until the next scheduled List call. Confirm with DALI that its runtime response contains the full set in one call despite the Swagger page metadata.
- **GET `/api/offers/by-commercial-id/{commercialId}`:** requires a commercial ID and returns `OfferItemList`, including the `data` array and pagination metadata. This resolves CLAR-OFF-006; consume the partner status from each item's `commercial.partner.status`.
- **POST `/api/offers/subscribe`:** requires `x-purchase-code`; its JSON body requires `idCommercialOffer` and optionally accepts `force`. The product's normal first request uses `force=false`; the confirmed incompatibility flow retries with `force=true` only after user confirmation.
- **POST `/api/offers/unsubscribe`:** requires `x-purchase-code`; the JSON body uses `idCommercialOffer`. The schema also declares `idOffer` but explicitly says it should not be used at the moment. The API returns `OfferItemList`.
- **409 Subscribe response:** Swagger references `ApiErrorIncompatibleOffer`, whose declared schema contains a top-level `incompatibleOffers` string array. It does not declare common `error`, `errorDescription`, or `errorSource` fields; verify runtime payload details if the product depends on them.

Swagger documents `403` responses for Subscribe and Unsubscribe. The product draft now lists these statuses, but the user-facing handling remains open under CLAR-OFF-011. Read/list operations document `304` for conditional retrieval and common read errors; Subscribe additionally documents `409`.

Swagger security offers Basic+Bearer for the public APIM gateway and API-key+mutual-TLS for private gateways. Each operation requires `x-kaltura-secret` and `x-kaltura-api-version`; APIM-specific DSI tokens are internal. Product credential provisioning for Basic/Bearer remains an integration detail. The Swagger does not define a “Check Offer” path even though the older DPI PDF describes one; do not add a device call without a published operation.

## Product Workflows

### Retrieval and Local Data

The validated product behavior retrieves subscribed and subscribable offers, their metadata, and the associated linear, replay, and SVOD catalog information for local product use. The current draft records refresh on startup, periodically (six hours with the established jitter), on entry to the subscriptions menu, and after the documented entitlement/PDS events. The 2024 in-progress SAG also says six-hour refreshes spread across devices, but its timing wording differs; retain the validated product wording until explicitly changed.

The current product draft treats search as out of scope. Do not reintroduce search requirements from older material.

### Subscribe and Incompatible Offers

Subscribe and unsubscribe are protected by purchase-PIN validation. The first subscribe request uses `force=false`. On an incompatibility response, the device asks the user to confirm; only after confirmation does it retry with `force=true`. The response contains the subscribed and impacted offer data, which the product uses to update local state. Preserve the existing validated flow; the 409 body shape and precise retry/error handling remain subject to Swagger confirmation and CLAR-OFF-009.

### Partner Activation

The product draft uses subscription metadata and partner status to distinguish offers whose partner account still needs activation. For the established examples, Disney+ (`subscriptionType=2`) uses a QR/customer-portal flow, while Dorcel (`subscriptionType=3`) uses a partner-app/deep-link flow. For type 2, DALI continues to return `finalActivationLink` and the device uses it as the QR target. For type 3, it uses `activationLink` as the activation deeplink instead of `finalActivationLink`; if `activationLink` is missing or empty, it launches the application identified by `partnerOfferApk`. Do not reconstruct activation URLs on the device. While `TRANSIENT` is active, fluid partner activation—including opening the deeplink or launching the partner application—is disabled.

For Netflix highlighted-offer interception, the STB retrieves the offer by `ID` and checks `entitlementState`, `commercial.subscriptionStatus`, and `commercial.partner.status`. If not entitled, it displays the Intercept screen; selecting an offer opens its information page and ends the flow, while Sign in launches Netflix. If entitled and partner status is `ACTIVE`, it launches Netflix directly. If entitled and partner status is not `ACTIVE`, type 2 opens the information page and ends the flow; type 3 checks `offers.config.cooldown_for_fluid_partners`, launching Netflix only when the cooldown expires and otherwise opening the information page and ending the flow. After launch, the app flow adapts to `GetAccountInfo()`.

The two source documents contain inconsistent descriptions of the numeric `subscriptionType` meanings; see CLAR-OFF-007. Follow the product-confirmed activation behavior above and do not reconstruct DALI activation URLs on the device.

### TRANSIENT

`TRANSIENT` is a product-local state, not a DALI status. Subscription starts the timer; defaults are `cooldown_in_seconds=120`, `cooldown_for_fluid_partners=30`, and `cooldown_for_non_fluid_partners=0` seconds. The product exits this state when the applicable cooldown expires. Partner activation is disabled while `TRANSIENT` is active. Expiry alone does not prove that backend processing or entitlement propagation has completed. Existing playback and offer-info-sheet behavior during TRANSIENT remains in the validated product draft. Restart behavior, refresh failure, and still-missing entitlement after expiry remain open under CLAR-OFF-010.

## Exclude from Product Requirements

Do not bring the following DALI implementation details into product requirements unless a device behavior depends on them:

- DALI internal mapping from French DSI payload fields to the offer model.
- DALI's DSI basic/moderate token selection, APIM-populated internal headers, internal call order, service names, caches/Hazelcast, and retry/throttling implementation.
- Internal DSI capacity estimates and backend performance tables.
- DALI's internal ETag calculation, cache merges, or response assembly, except for the device-facing ETag contract and the product's refresh policy.
- DALI's implementation formula for constructing `finalActivationLink`; the product consumes the returned link.

## Open Questions and Source Conflicts

1. **CLAR-OFF-003:** device policy is decided: no category/entitlement filters, one List call, ignore `links.next` and page counters, treat `data` as a full snapshot, keep the old ETag if 200 omits one, and refresh after mutations on the next scheduled List. Confirm with DALI that the runtime response is complete in one call.
2. **CLAR-OFF-007:** reconcile `subscriptionType` numeric meanings and expiry behavior. The schema describes type 2 as fluent/type 3 as non-fluent, while the validated product examples associate Disney+ QR with 2 and Dorcel app/deep link with 3. The sample also contains `subscriptionType=0`; do not infer its behavior.
3. **CLAR-OFF-009:** the product example now matches the Swagger's top-level `incompatibleOffers[]`; confirm any additional runtime error fields and how the product handles failure of the forced retry.
4. **CLAR-OFF-010:** clarify timer configuration key, restart during TRANSIENT, refresh failure, and no entitlement after expiry.
5. **CLAR-OFF-011:** define product-visible outcomes and recovery for uncertain mutation results and DALI unavailability, without inventing retries.
6. **APIM security:** Swagger requires Basic+Bearer for the public gateway, but the product header table previously represented the Bearer token only. Confirm which component supplies each credential.
7. **AIBO:** the diagram includes “Apps offers” and “Apps offers status” on the user's direction that DALI calls AIBO. Neither the Swagger nor converted PDFs define those operations. The current product text says partner activation status comes from DALI's Get Offer response, not a dedicated AIBO status API. Keep AIBO labels architectural and non-normative until an interface contract is provided.

## Source Files

- [DPI API v2 PDF](../archive/DPI-API%20V2-121126-175023.pdf) and [MarkItDown conversion](DPI-API-V2.markitdown.md)
- [DALI lot 2 nPFS offers v2 PDF](../archive/ETDDPPS-SAG%20-%20P01558%20-%20DALI%20lot%202%20nPFS%20-%20offers%20v2%20%5BIN%20PROGRESS%5D-121126-175006.pdf) and [MarkItDown conversion](DALI-lot-2-nPFS-offers-v2.markitdown.md)
- [Observed offers/list response](../offers_list.json)
- [Current product draft](../subscriptions-offers-v2.2-reorganisee.md)
