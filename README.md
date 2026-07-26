# AIVS-1 — Agent Inference Value Standard

**The open standard for agent inference value.** Occurrence is attested. Value is revealed.

- Website: [aivs-1.org](https://aivs-1.org)
- Specification: [AIVS-1 Specification v0.1](docs/AIVS-1_Specification_v0_1.pdf)
- Status: **Draft for public comment** · v0.1
- Licence: **CC0 1.0 Universal** — no rights reserved

---

## What this standard does

AIVS-1 defines the unit in which the cognitive work an AI agent delivers — the inference — is
recorded, proved and valued. That unit is the **Inference Value Record (IVR)**.

The standard rests on one separation:

| | Question | How it is answered |
|---|---|---|
| **Occurrence** | Did the inference happen? | Attested, graded `A0`–`A3` |
| **Value** | What is it worth? | Revealed by an independent party's commitment |

It addresses the **Cost-Proxy Problem**: agent work is priced today in the currency of its
inputs — tokens, GPU-seconds, FLOPs. Those are the substrate, not the output. Cost is a property
of the producer and reveals nothing about worth.

AIVS-1 therefore does not ask the producer what an inference was worth. It records what somebody
else committed against it: a policy written, a stake posted, a reliance placed, collateral locked.

An attribution counts toward tiering only if it **qualifies** — the committer is not the
producer, the commitment is irrevocable, and forfeiture is determined by an independent party. A
sponsor standing behind its own agent qualifies; that is the ordinary case. A record resting only
on related-party commitments is capped at T1.

The specification is authoritative. This repository carries the machine-readable artefacts.

## Repository layout

```
docs/         Specification PDF, and implementer notes that change faster than the spec
              AIVS-1_Specification_v0_1.pdf  ·  interop.md
schemas/      JSON Schema 2020-12 for the IVR and the draft Outcome Record
examples/     Worked records, validated on every pull request
site/         Source of aivs-1.org
tools/        Local validation
```

## Composition with the open stack

| Standard | Layer | Relationship |
|---|---|---|
| [AIS-1](https://ais-1.org) | Identity | Producer and every committing party is an AIS-1 DID |
| [AAS-1](https://aas-1.org) | Auditability | The subject inference is normally an AAS-1 Class A or Class D record |
| [AES-1](https://aes-1.org) | Execution | IVRs are minted in a certified enclave; enclave tier bounds transferability |
| [AIPS-1](https://aips-1.org) | Insurance | Policy Certificate supplies the components of a written-cover attribution |
| ARMS-1 | Receivables | Carries the payment obligation. **AIVS-1 creates none** |
| [ARS-1](https://ars-1.org) | Remittance | Settles consideration once owed |
| [ADFACS-1](https://adfacs-1.org) | Disputes | An IVR is admissible in a Canonical Dispute Record in Native mode |

## Validating

```bash
npm install -g ajv-cli ajv-formats
./tools/validate.sh
```

CI validates every example against the schemas and separately checks three invariants the schema
cannot express: a producer never values its own inference, a trigger authority is independent of
both committer and producer, and apportioned shares of one commitment never exceed the whole.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Adversarial review of the revealed-value mechanism is
what we most want — reviewers from insurance, actuarial, audit and structured-finance
backgrounds especially.

## Authors

Kadikoy Limited, Bermuda (Reg. 202302362) · BDA Law; BDA AI Agent Services
· info@aiagentsservices.net
