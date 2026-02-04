variable "bucket" {
  type        = string
  description = "Bucket name"
}

variable "versioning" {
  type        = bool
  description = "Enable versioning"
  default     = false
}

variable "force_destroy" {
  type        = bool
  description = "Force destroy the bucket"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the bucket"
  default     = {}
}
