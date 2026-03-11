module "mock_api" {
  source    = "../../modules/app-cloudfront"
  name      = var.name
  image_uri = var.image_uri

  providers = {
    aws.use1 = aws.use1
  }
}

output "mock_api_url" {
  value = module.mock_api.this.url
}
