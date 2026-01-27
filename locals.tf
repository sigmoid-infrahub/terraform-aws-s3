locals {
  resolved_tags = merge({
    ManagedBy = "sigmoid"
  }, var.tags)

  versioning_status = var.versioning == null ? null : (try(var.versioning.enabled, false) ? "Enabled" : "Suspended")
}
