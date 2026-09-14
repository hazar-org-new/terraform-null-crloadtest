variable "delay_seconds" {
  description = "How long the apply should take before completing. Drives the deadline probe."
  type        = number
  default     = 60
}

variable "fail_probability" {
  description = "Fraction of applies that exit non-zero on purpose, 0.0 to 1.0. Exercises the error path."
  type        = number
  default     = 0

  validation {
    condition     = var.fail_probability >= 0 && var.fail_probability <= 1
    error_message = "fail_probability must be between 0 and 1."
  }
}

variable "label" {
  description = "Free-form tag echoed into the outputs so a run can be identified in logs."
  type        = string
  default     = "crloadtest"
}
