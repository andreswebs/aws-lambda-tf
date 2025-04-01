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

variable "timeout_seconds" {
  type    = number
  default = 300
}

variable "memory_size_mb" {
  type    = number
  default = 256
}

variable "lambda_env" {
  type    = map(string)
  default = {}
}

variable "lambda_alias" {
  type    = string
  default = "default"
}

variable "create_lambda_function_url" {
  type    = bool
  default = false
}
