# terraform-null-crloadtest

A Terraform module that does nothing except take a configurable amount of time
and, optionally, fail on purpose. It calls no external API, needs no
credentials, and creates nothing that has to be cleaned up.

Its purpose is load-testing a system that runs Terraform on your behalf: it
measures that system's own overhead — dispatch, module fetch, `terraform init`,
provider download, apply and state write — without a cloud provider's latency
mixed into the numbers. The `delay_seconds` knob makes it useful for finding
where a caller's timeout actually sits.

## Usage

```hcl
module "probe" {
  source  = "hazar-org-new/crloadtest/null"
  version = "1.0.0"

  delay_seconds    = 600
  fail_probability = 0
  label            = "deadline-probe"
}
```

## Inputs

| Name | Default | Purpose |
|------|---------|---------|
| `delay_seconds` | `60` | Wall-clock the apply occupies. |
| `fail_probability` | `0` | Fraction of applies that exit 1, `0.0`-`1.0`. |
| `label` | `crloadtest` | Tag echoed into outputs and log lines. |

On an injected failure the module writes a line to stderr before exiting
non-zero, so it doubles as a check for whether a caller is capturing stderr at
all.

## Outputs

`run_id`, `label`, `delay_seconds`, `started_at`.

## Publishing

The Terraform Registry derives the module address from the repository name, so
this must stay `terraform-null-crloadtest` to publish as
`hazar-org-new/crloadtest/null`.

    git tag v1.0.0 && git push origin v1.0.0

Then add the repo at registry.terraform.io.
