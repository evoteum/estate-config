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