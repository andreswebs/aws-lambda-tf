module "deno_test" {
  source      = "../../modules/lambda"
  name        = "deno-test"
  description = "Testing Deno on Lambda"
  image_uri   = var.image_uri_deno_test
}
