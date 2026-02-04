locals {
  resolved_tags = merge({
    ManagedBy = "sigmoid"
  }, var.tags)

  versioning_status = var.versioning ? "Enabled" : "Suspended"
}
