data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
  dns_suffix = data.aws_partition.current.dns_suffix
}

locals {
  lambda_alias = "default"
}

module "lambda_base" {
  source  = "andreswebs/lambda-base/aws"
  version = "0.3.0"
  name    = var.name
}

module "lambda" {
  depends_on = [module.lambda_base]
  source     = "terraform-aws-modules/lambda/aws"
  version    = "~> 7.9"

  architectures = ["arm64"]

  function_name = var.name
  description   = var.description

  create_role = false
  lambda_role = module.lambda_base.iam_role.arn

  attach_cloudwatch_logs_policy = false
  attach_dead_letter_policy     = false
  attach_network_policy         = false
  attach_tracing_policy         = false
  attach_async_event_policy     = false

  use_existing_cloudwatch_log_group = true
  logging_log_format                = "JSON"
  logging_log_group                 = module.lambda_base.log_group.name

  tracing_mode = "Active"

  create_package = false
  package_type   = "Image"
  image_uri      = var.image_uri

  publish     = true
  memory_size = 256
  timeout     = 30

  create_lambda_function_url = false

  # environment_variables = var.lambda_env
}

module "alias" {
  depends_on       = [module.lambda]
  source           = "terraform-aws-modules/lambda/aws//modules/alias"
  refresh_alias    = true
  name             = local.lambda_alias
  function_name    = module.lambda.lambda_function_name
  function_version = module.lambda.lambda_function_version
}
