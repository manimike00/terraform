resource "azurerm_public_ip" "lb" {
  name                = "${var.environment}-${var.project}-lb"
  resource_group_name = var.rg
  location            = var.location
  allocation_method   = "Dynamic"
}

#&nbsp;since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.environment}-${var.project}-beap"
  frontend_port_name             = "${var.environment}-${var.project}-feport"
  frontend_ip_configuration_name = "${var.environment}-${var.project}-feip"
  http_setting_name              = "${var.environment}-${var.project}-be-htst"
  listener_name                  = "${var.environment}-${var.project}-httplstn"
  request_routing_rule_name      = "${var.environment}-${var.project}-rqrt"
  redirect_configuration_name    = "${var.environment}-${var.project}-rdrcfg"
}

resource "azurerm_application_gateway" "lb" {
  name                = "${var.environment}-${var.project}-lb"
  resource_group_name = var.rg
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.public_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.lb.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}