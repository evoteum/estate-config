variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the infrastructure to."
  sensitive   = false
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
  sensitive   = true
}

variable "gcp_project_id" {
  description = "The ID of the GCP project we are deploying into"
  default     = "arctic-sentry-468900-g0"
  type        = string
}

variable "gcp_region" {
  default     = "europe-west2"
  description = "The GCP region to deploy the infrastructure to without the zone suffix; see https://cloud.google.com/compute/docs/regions-zones#available"
  type        = string
}

variable "gcp_service_account_opentofu_email" {
  description = "email address for the OpenTofu GCP Service Account"
  type        = string
  sensitive   = true
}

variable "gcp_service_account_opentofu_id" {
  description = "Unique ID of the OpenTofu GCP Service Account"
  type        = string
  sensitive   = true
}

variable "gcp_zone_suffix" {
  description = "The zone letter after the GCP region, usually a, b, c or d"
  default     = "a"
  type        = string
  validation {
    condition     = can(regex("^[A-Za-z]$", var.gcp_zone_suffix))
    error_message = "gcp_zone_suffix must be a single latin letter"
  }

}

variable "oidc_audience" {
  type        = string
  description = "Audience for the AWS OIDC provider"
  default     = "sts.amazonaws.com"
}

variable "org_slogan" {
  type        = string
  description = "The slogan of the organisation."
  sensitive   = false
  default     = "Innovation Evolution"
}

variable "organisation" {
  type        = string
  description = "The name of the organisation."
  sensitive   = false
}

variable "repository_name" {
  type        = string
  description = "The name of the repository."
  sensitive   = false
}

variable "repository_url" {
  type        = string
  description = "The HTML URL of this repository"
}
