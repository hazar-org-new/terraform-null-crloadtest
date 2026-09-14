terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

resource "random_id" "run" {
  byte_length = 8
}

resource "time_static" "started" {}

# Occupies wall-clock without touching any external API, so the only thing
# under test is how the platform behaves while an apply is in flight.
resource "time_sleep" "delay" {
  create_duration = "${var.delay_seconds}s"

  triggers = {
    run = random_id.run.hex
  }
}

# Writes to stderr before exiting non-zero. A failure here should surface its
# message in the caller's logs; if it does not, stderr is being dropped.
resource "null_resource" "outcome" {
  triggers = {
    run = random_id.run.hex
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = <<-EOT
      threshold=${floor(var.fail_probability * 1000)}
      dice=${random_integer.dice.result}
      if [ "$dice" -le "$threshold" ]; then
        echo "crloadtest: injected failure label=${var.label} run=${random_id.run.hex} dice=$dice threshold=$threshold" >&2
        exit 1
      fi
      echo "crloadtest: ok label=${var.label} run=${random_id.run.hex} delay=${var.delay_seconds}s"
    EOT
  }

  depends_on = [time_sleep.delay]
}

resource "random_integer" "dice" {
  min = 1
  max = 1000
}
