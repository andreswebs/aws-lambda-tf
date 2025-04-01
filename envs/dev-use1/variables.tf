variable "image_uri" {
  type = string
}

variable "lambda_env" {
  type    = map(string)
  default = {}
}
