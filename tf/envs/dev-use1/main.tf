module "example" {
  source    = "../../modules/app-cloudfront"
  name      = var.name
  image_uri = var.image_uri

  providers = {
    aws.use1 = aws.use1
  }
}
