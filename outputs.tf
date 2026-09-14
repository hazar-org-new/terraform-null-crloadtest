output "run_id" {
  description = "Unique id for this apply, for correlating logs."
  value       = random_id.run.hex
}

output "label" {
  description = "The label this run was tagged with."
  value       = var.label
}

output "delay_seconds" {
  description = "The delay this run was configured with."
  value       = var.delay_seconds
}

output "started_at" {
  description = "RFC3339 timestamp captured at the start of the apply."
  value       = time_static.started.rfc3339
}
