# terraform-null-crloadtest

A custom resource that does nothing except take a configurable amount of time and,
optionally, fail on purpose. It calls no external API, needs no credentials, and
creates nothing that has to be cleaned up.

Its purpose is to measure the Instruqt custom resource pipeline itself — gRPC
dispatch, module fetch from GCS, `terraform init`, provider download, apply, and
state write — without a cloud provider's latency mixed into the numbers.

## Inputs

| Name | Default | Purpose |
|------|---------|---------|
| `delay_seconds` | `60` | Wall-clock the apply occupies. |
| `fail_probability` | `0` | Fraction of applies that exit 1, `0.0`-`1.0`. |
| `label` | `crloadtest` | Tag echoed into outputs and log lines. |

## Publishing

The Terraform Registry derives the module address from the repository name, so
this must stay `terraform-null-crloadtest` to publish as `instruqt/crloadtest/null`.

    git tag v1.0.0 && git push origin v1.0.0

Then add the repo at registry.terraform.io under the `instruqt` namespace.
