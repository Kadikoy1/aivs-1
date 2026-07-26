# Implementer notes

Detail that changes faster than the specification. Where this conflicts with the specification,
the specification governs.

## Canonicalisation

All records are canonicalised with **JCS (RFC 8785)** and hashed with **SHA-256** by default,
matching AAS-1 § 6.2 and the rest of the stack. The signature object is structurally identical to
AAS-1 § 6.3, so verification tooling is shared.

Monetary amounts are decimal **strings**, not JSON numbers. A float has no canonical
serialisation and would produce different bytes — and therefore different hashes — for the same
value across implementations.

## Timestamps

All timestamps are **RFC 3339**. RFC 3339 is a profile of ISO 8601 that pins a single
representation of an instant, always with an explicit offset or `Z`. ISO 8601 alone permits many
representations of the same moment, which would break canonicalisation. Emit an explicit offset.

## Identifiers

| Field | Form | Source |
|---|---|---|
| `producerRef`, `committerRef`, `triggerAuthority` | `did:ais1:{chain}:{id}` / `did:ais1:sponsor:{id}` | AIS-1 § 7 |
| `subjectRef` | URI of an AAS-1 record | AAS-1 § 3–4 |
| `mintingEnclaveRef` | `aes1:{chain}:{address}` | AES-1 Enclave Certificate |
| `recordId` | ULID or UUID, unique within producer | — |
| `commitmentId` | Stable identifier for a commitment, chosen by the committer | — |

## Resolution order for a verifier

1. Fetch the IVR and validate against `schemas/aivs-1-ivr.schema.json`.
2. Resolve `producerRef` via the AIS-1 § 7.1 algorithm; verify the signature against the declared
   verification method; confirm the bond was active at `timestamp`.
3. Confirm the occurrence evidence supports the declared tier — a stated tier is not a proved
   tier.
4. For each attribution, test qualification:
   `committerRef ≠ producerRef`, `irrevocable === true`, and `triggerAuthority` present and equal
   to neither the committer nor the producer.
5. Resolve `evidenceRef`. For `insurance`, confirm the AIPS-1 Policy Certificate status was
   `Active` over the relevant period.
6. Partition qualifying attributions on `relatedParty`.
7. Recompute the transfer tier. **Do not trust the field.**
8. Confirm the AAS-1 Class A record referenced by `aas1RecordRef` exists and reconciles.

## Transfer tier derivation

```js
function qualifies(a, producerRef) {
  return a.committerRef !== producerRef
      && a.irrevocable === true
      && !!a.triggerAuthority
      && a.triggerAuthority !== a.committerRef
      && a.triggerAuthority !== producerRef;
}

function deriveTransferTier(ivr, enclaveTier) {
  if (ivr.occurrence.tier === 'A0') return 'T0';
  if (!enclaveTier) return 'T0';

  const q = ivr.revealedValue.filter(a => qualifies(a, ivr.producerRef));
  if (q.length === 0) return 'T0';

  const capital = a => a.signal === 'insurance' || a.signal === 'posted_stake';
  const unrelatedCapital = q.some(a => !a.relatedParty && capital(a));

  if (enclaveTier === 'III' && unrelatedCapital) return 'T2';
  if (enclaveTier === 'II' || enclaveTier === 'III') return 'T1';
  return 'T0';
}
```

## Apportionment arithmetic

Where one commitment is contingent on several inferences, each attribution carries a
`commitmentId` and a `share` stated by the committer. The invariant a verifier or registry must
enforce:

> Shares across all attributions citing the same `commitmentId` MUST NOT exceed 1.

Absent `share`, the whole commitment is attributed to that inference.

## AAS-1 assertion mapping

An auditor examining IVRs under an AAS-1 Class E engagement:

| AAS-1 assertion | Evidenced in an IVR by |
|---|---|
| Existence | `occurrence.evidenceRef` at the declared tier |
| Accuracy | `revealedValue[].components` reconciled to `evidenceRef` |
| Authorisation | AIS-1 bond active at `timestamp` |
| Cutoff | RFC 3339 `timestamp` within the engagement period |
| Identity | Signature verifies against the AIS-1 verification method |
| Provenance | `occurrence.modelIdentityHash` |
| Independence | `committerRef` ≠ `producerRef`; `irrevocable`; `triggerAuthority`; `relatedParty` |
