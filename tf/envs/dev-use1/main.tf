module "example" {
  source    = "../../modules/app-cloudfront"
  name      = var.name
  image_uri = var.image_uri
}
