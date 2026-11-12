# Offers Product Knowledge Base

Status: working knowledge base for the STB/device product specification. This is a synthesis of the documents below, the validated v2.1 product behavior, and decisions confirmed in the review. It is not a replacement for the current DALI Swagger.

## Sources and Authority

1. `subscriptions-offers-v2.1.md` is the validated product behavior baseline. Preserve its rules unless the user explicitly changes them.
2. `DPI-API-V2.markitdown.md` is the MarkItDown extraction of `DPI-API V2-121126-175023.pdf`. It contains the detailed DALI v2 interface and response model, mixed with DALI implementation flow. Use its device-facing contract as a working reference; the current Swagger is authoritative for exact paths, verbs, schemas, and errors.
3. `DALI-lot-2-nPFS-offers-v2.markitdown.md` is the extraction of `ETDDPPS-SAG - P01558 - DALI lot 2 nPFS - offers v2 [IN PROGRESS]-121126-175006.pdf`. The source is explicitly in progress and its document history says v0.1, May 2024. Use it for context and historical product requirements, not as the current API contract.
4. `../offers_list.json` is one real list response containing 70 offers. It demonstrates possible payloads and status combinations, but is not exhaustive and does not define universal behavior.
5. The current working product draft is `../subscriptions-offers-v2.2-reorganisee.md`. Screen layouts and UI illustrations are examples only; product requirements concern data, actions, and behavior.

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
- `commercial.partner.status` indicates partner-account activation state. Creating a Disney+ subscription can leave partner activation pending until the customer creates or activates the partner account. The DALI mapping lists `ACTIVE`, `CANCELED`, `CREATED`, `INACTIVE`, `NON-EXISTENT`, and `UNSUBSCRIBED`.

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

The device uses these DALI capabilities; use `actions` HATEOAS links from the offer response where provided:

- **List offers:** retrieve entitled and subscribable offer data and store/update it locally. The model supports category and entitlement filtering. The detailed v2 document describes optional `If-None-Match` and an ETag when pagination is not used. The existing product draft also has pagination parameters; the device strategy for pagination, ETag validation, and refresh remains open under CLAR-OFF-003.
- **Get one offer:** retrieve an offer by commercial ID, including current partner status for activation flows. The exact response shape and contract need confirmation against the current Swagger (CLAR-OFF-006).
- **Subscribe:** send the commercial offer ID, the purchase PIN in the required header, and the `force` flag. `force=false` is the normal first request. A successful response returns the updated offer and may return impacted offers.
- **Unsubscribe:** send the commercial offer ID and purchase PIN. Use the returned updated offer to update local data without an immediate extra list request, as specified in the product flow.

The two source documents disagree on some API surface details. The older SAG says `POST /api/offers/unsubscribe` and uses `entitlementState` values `SUBSCRIBABLE`, `SUBSCRIBED`, `ALL`; the detailed v2 model describes `DELETE` for unsubscription and `ENTITLED` / `NOT_ENTITLED` in the offer model. The real list sample also uses `ENTITLED` / `NOT_ENTITLED`. Confirm the current verb, parameter names, and query enums in Swagger; do not copy the in-progress SAG values into product requirements as current contract.

DALI's detailed API document describes a “Check Offer” operation with 204/304 responses but the MarkItDown extraction does not establish a product endpoint or complete device contract. Do not prescribe a device call to it until Swagger confirms it is product-facing.

## Product Workflows

### Retrieval and Local Data

The validated product behavior retrieves subscribed and subscribable offers, their metadata, and the associated linear, replay, and SVOD catalog information for local product use. The current draft records refresh on startup, periodically (six hours with the established jitter), on entry to the subscriptions menu, and after the documented entitlement/PDS events. The 2024 in-progress SAG also says six-hour refreshes spread across devices, but its timing wording differs; retain the validated product wording until explicitly changed.

The current product draft treats search as out of scope. Do not reintroduce search requirements from older material.

### Subscribe and Incompatible Offers

Subscribe and unsubscribe are protected by purchase-PIN validation. The first subscribe request uses `force=false`. On an incompatibility response, the device asks the user to confirm; only after confirmation does it retry with `force=true`. The response contains the subscribed and impacted offer data, which the product uses to update local state. Preserve the existing validated flow; the 409 body shape and precise retry/error handling remain subject to Swagger confirmation and CLAR-OFF-009.

### Partner Activation

The product draft uses subscription metadata and partner status to distinguish offers whose partner account still needs activation. For the established examples, Disney+ (`subscriptionType=2`) uses a QR/customer-portal flow, while Dorcel (`subscriptionType=3`) uses a partner-app/deep-link flow. The product consumes `finalActivationLink` returned by DALI; it should not reconstruct DALI activation URLs itself.

The two new documents contain inconsistent descriptions/formulas for `subscriptionType` and `finalActivationLink`; see Open Questions. Keep the validated product examples, but do not generalize the numeric type meanings or link formula beyond confirmed rules.

### TRANSIENT

`TRANSIENT` is a product-local state, not a DALI status. Subscription starts the timer; the default duration is 120 seconds; the product exits this state at expiry. Expiry alone does not prove that backend processing or entitlement propagation has completed. Existing playback and offer-info-sheet behavior during TRANSIENT remains in the validated product draft. Restart behavior, refresh failure, and still-missing entitlement after expiry remain open under CLAR-OFF-010.

## Exclude from Product Requirements

Do not bring the following DALI implementation details into product requirements unless a device behavior depends on them:

- DALI internal mapping from French DSI payload fields to the offer model.
- DALI's DSI basic/moderate token selection, APIM-populated internal headers, internal call order, service names, caches/Hazelcast, and retry/throttling implementation.
- Internal DSI capacity estimates and backend performance tables.
- DALI's internal ETag calculation, cache merges, or response assembly, except for the device-facing ETag contract and the product's refresh policy.
- DALI's implementation formula for constructing `finalActivationLink`; the product consumes the returned link.

## Open Questions and Source Conflicts

1. **CLAR-OFF-003:** settle pagination versus ETag use, treatment of 200/304, local updates, and refresh after mutations.
2. **CLAR-OFF-004:** validate field names, casing, enum values, and category handling with the current Swagger. The MarkItDown extraction and old diagrams have table/numbering defects.
3. **CLAR-OFF-005:** `finalActivationLink` timing conflicts: the product text says it is supplied after subscribe and should be cached; DPI v2 describes building it in get/list formatting for some cases, and the shared real list JSON includes it. Confirm the current contract and product cache behavior.
4. **CLAR-OFF-006:** confirm the exact shape of Get-by-commercial-ID response.
5. **CLAR-OFF-007:** reconcile `subscriptionType` meanings and partner activation matrix. DPI v2 model text calls type 2 fluent/type 3 non-fluent, while its processing comments and both product/older SAG examples associate Disney+ QR with 2 and Dorcel app/deep link with 3. The sample also contains `subscriptionType=0`; do not infer its behavior.
6. **CLAR-OFF-009:** confirm the exact 409 response schema and behavior after a failed forced retry.
7. **CLAR-OFF-010:** clarify timer configuration key, restart during TRANSIENT, refresh failure, and no entitlement after expiry.
8. **CLAR-OFF-011:** define product-visible outcomes and recovery for uncertain mutation results and DALI unavailability, without inventing retries.
9. **AIBO:** the diagram includes “Apps offers” and “Apps offers status” on the user's direction that DALI calls AIBO. Neither converted source defines those operations. The existing product text says partner activation status is obtained from DALI's Get Offer response, not from a dedicated AIBO status API. Keep the AIBO labels architectural and non-normative until an interface contract is provided.

## Source Files

- [DPI API v2 PDF](../DPI-API%20V2-121126-175023.pdf) and [MarkItDown conversion](DPI-API-V2.markitdown.md)
- [DALI lot 2 nPFS offers v2 PDF](../ETDDPPS-SAG%20-%20P01558%20-%20DALI%20lot%202%20nPFS%20-%20offers%20v2%20%5BIN%20PROGRESS%5D-121126-175006.pdf) and [MarkItDown conversion](DALI-lot-2-nPFS-offers-v2.markitdown.md)
- [Observed offers/list response](../offers_list.json)
- [Current product draft](../subscriptions-offers-v2.2-reorganisee.md)
