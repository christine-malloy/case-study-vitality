variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'vitality'"
  default     = "vitality"
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
  default     = "dev"
}

variable "name" {
  type        = string
  description = "Name of the frontend application"
  default     = "frontend"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (e.g. `1`)"
  default     = ["app"]
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. map('BusinessUnit',`XYZ`)"
  default     = {}
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}

variable "price_class" {
  type        = string
  description = "CloudFront distribution price class"
  default     = "PriceClass_100"
}

variable "s3_origin_id" {
  type        = string
  description = "Origin ID for S3 bucket"
  default     = "S3Origin"
}

variable "api_origin_id" {
  type        = string
  description = "Origin ID for API"
  default     = "APIOrigin"
}

variable "api_service_name" {
  type        = string
  description = "Name of the App Runner API service"
  default     = null
} 