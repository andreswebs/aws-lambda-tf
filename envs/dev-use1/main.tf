module "test" {
  source      = "../../modules/lambda"
  name        = "ado-ecs"
  description = "ADO pipeline runners endpoint"
  image_uri   = var.image_uri

  create_lambda_function_url = true
}

output "test_url" {
  value = module.test.lambda_function_url
}
