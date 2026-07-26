# Contributing to AIVS-1

AIVS-1 is published CC0. Contributions are welcomed from anyone and no rights are asserted over
what you submit.

## How to contribute

| I want to… | Do this |
|---|---|
| Raise a defect in the specification | Open an issue using the **Feedback** template |
| Propose a change to a schema or a tier rule | Open an issue using the **Proposal** template |
| Answer an open question | Comment citing the question number from the specification |
| Contribute a worked example | Pull request adding to `examples/` — it must validate |

## Pull requests

Every PR is validated by GitHub Actions against the schemas in `schemas/`, and against three
invariants the schema cannot express. Run locally first:

```bash
npm install -g ajv-cli ajv-formats
./tools/validate.sh
```

Prose changes should match the register of the specification: plain, direct, and candid about
limits. The standard's credibility rests on saying what it does not do as clearly as what it
does.

## What we most want

Adversarial review of the revealed-value mechanism. It is the load-bearing claim and the one most
likely to be wrong. In particular:

- Whether the components-not-scalar treatment of written cover is sufficient to keep an insurer's
  loading and the market cycle out of the value signal.
- Whether irrevocability plus an independent trigger is the right qualification test.
- Whether committer-stated apportionment is adequate for multi-agent flows, or whether that case
  needs machinery this standard deliberately avoids.
