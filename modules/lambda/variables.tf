variable "name" {
  type        = string
  description = "Name of the lambda"
}

variable "description" {
  type        = string
  description = "Description of the lambda"
  default     = null
}

variable "image_uri" {
  type        = string
  description = "Lambda ECR image URI"
}
