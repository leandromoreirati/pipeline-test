module "rg" {
  source = "git::https://github.com/leandromoreirati/tf-module-azure-resource-group?ref=0.1.0"

  name     = var.name
  location = var.location
  tags     = var.tags
}