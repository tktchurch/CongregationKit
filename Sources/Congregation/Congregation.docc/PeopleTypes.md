# People Types

Three distinct people models — members, seekers, and ops staff — plus family, RFID, and spiritual satellite records.

## Overview

| Type | Model | Typical source | Role |
|---|---|---|---|
| Congregation member | ``Member`` | Salesforce `Member__c` | Baptized / regular attendee |
| Seeker | ``Seeker`` | Salesforce `Lead__c` | Pre-membership follow-up |
| Ops staff | ``StaffUser`` | Salesforce `User` | Owns tasks, not congregation |

**Do not** use ``StaffUser`` for member profiles. **Do not** use ``Member`` for Salesforce `User` rows.

Congregation is framework-agnostic. Domain types are not limited to what Salesforce v2 currently returns.

### Family data

- ``Family`` / ``FamilyTree`` / ``FamiliesHandler`` — household graph (identity, relationships, tree). Apps or another backend implement the handler.
- ``FamilyRecord`` / ``FamilyRecordsHandler`` — Salesforce v2 `/families` person/dependent row from `Family_Information__c`.

These are different shapes. A v2 family row is not a household.

Migrating **Salesforce transport** from v1 lists to v2 does not drop Congregation ``Family`` or ``RFID``.

### RFID vs `cardIssued`

- ``RFID`` / ``RFIDsHandler`` — card identity, status, issue/activate/block, expiry.
- ``FamilyRecord/cardIssued`` — Salesforce boolean snapshot only (“has a card been issued?”). Not tag number, status, or lifecycle.

CongregationKit exposes `familyRecords` for v2. It does not implement RFID or household Family against Salesforce.

## See also

- ``OpsWorkQueue``
- ``FamilyRecord``
- ``RFID``
- ``SpiritualRecord``
