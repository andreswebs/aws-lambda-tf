data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
  dns_suffix = data.aws_partition.current.dns_suffix
}

module "lambda_base" {
  source  = "andreswebs/lambda-base/aws"
  version = "0.6.0"
  name    = var.name
}

module "lambda" {
  source    = "../lambda"
  name      = var.name
  image_uri = var.image_uri

  iam_role_arn   = module.lambda_base.iam_role.arn
  log_group_name = module.lambda_base.log_group.name

  # lambda_env = {}
}

resource "aws_lambda_function_url" "this" {
  function_name      = module.lambda.function.function_name
  qualifier          = module.lambda.alias.name
  authorization_type = "AWS_IAM" # this would be "NONE" if not using cloudfront
}

resource "aws_lambda_permission" "cloudfront" {
  statement_id           = "AllowCloudFrontServicePrincipal"
  function_url_auth_type = "AWS_IAM"
  function_name          = module.lambda.function.function_name
  qualifier              = module.lambda.alias.name
  action                 = "lambda:InvokeFunctionUrl"
  principal              = "cloudfront.${local.dns_suffix}"
  source_arn             = aws_cloudfront_distribution.this.arn
}
