# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-${var.project}"
  location = var.location
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}