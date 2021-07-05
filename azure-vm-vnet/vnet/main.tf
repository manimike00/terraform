# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-${var.project}"
  resource_group_name = var.rg
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create a Subnet within the resource group
resource "azurerm_subnet" "public-subnet" {
  name                 = "${var.environment}-${var.project}-public"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Subnet within the resource group
resource "azurerm_subnet" "private-subnet" {
  name                 = "${var.environment}-${var.project}-private"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}

# Create IP Prefix within the resource group
resource "azurerm_public_ip_prefix" "public-ip-prefix" {
  name                = "${var.environment}-${var.project}-nat-ip-prefix"
  location            = var.location
  resource_group_name = var.rg
  prefix_length       = 30
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create NAT Gateway within the resource group
resource "azurerm_nat_gateway" "nat-gateway" {
  name                    = "${var.environment}-${var.project}-nat-gateway"
  location                = var.location
  resource_group_name     = var.rg
  public_ip_prefix_ids    = [azurerm_public_ip_prefix.public-ip-prefix.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Associate NAT with Private Subnet
resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  nat_gateway_id = azurerm_nat_gateway.nat-gateway.id
  subnet_id      = azurerm_subnet.private-subnet.id
}

# Create a Public Subnet Network Security Group
resource "azurerm_network_security_group" "pub-nsg" {
  name                = "${var.environment}-${var.project}-public-nsg"
  location            = var.location
  resource_group_name = var.rg

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create a Public Subnet Network Security Group
resource "azurerm_network_security_group" "pri-nsg" {
  name                = "${var.environment}-${var.project}-private-nsg"
  location            = var.location
  resource_group_name = var.rg

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Associate Network Security Group with Public Subnet
resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public-subnet.id
  network_security_group_id = azurerm_network_security_group.pub-nsg.id
}

# Associate Network Security Group with Private Subnet
resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private-subnet.id
  network_security_group_id = azurerm_network_security_group.pri-nsg.id
}

# Create Route Table for Public Subnet
resource "azurerm_route_table" "public-rt" {
  name                          = "${var.environment}-${var.project}-public-rt"
  location                      = var.location
  resource_group_name           = var.rg
  disable_bgp_route_propagation = false


  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create Route for Public Route Table
resource "azurerm_route" "pub-route" {
  name                = "${var.environment}-${var.project}-public-route-1"
  resource_group_name = var.rg
  route_table_name    = azurerm_route_table.public-rt.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

# Create Route for Private Route Table
resource "azurerm_route" "pub-route-2" {
  name                = "${var.environment}-${var.project}-public-route-2"
  resource_group_name = var.rg
  route_table_name    = azurerm_route_table.public-rt.name
  address_prefix      = "10.0.0.0/16"
  next_hop_type       = "None"
}


# Associate Subnets with Public Route table
resource "azurerm_subnet_route_table_association" "pub-rt-att" {
  subnet_id      = azurerm_subnet.public-subnet.id
  route_table_id = azurerm_route_table.public-rt.id
}

# Create Route Table for Private Subnet
resource "azurerm_route_table" "private-rt" {
  name                          = "${var.environment}-${var.project}-private-rt"
  location                      = var.location
  resource_group_name           = var.rg
  disable_bgp_route_propagation = false

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

# Create Route for Private Route Table
resource "azurerm_route" "pri-route" {
  name                = "${var.environment}-${var.project}-private-route"
  resource_group_name = var.rg
  route_table_name    = azurerm_route_table.private-rt.name
  address_prefix      = "10.0.0.0/16"
  next_hop_type       = "None"
}

# Associate Subnets with Private Route table
resource "azurerm_subnet_route_table_association" "pri-rt-att" {
  subnet_id      = azurerm_subnet.private-subnet.id
  route_table_id = azurerm_route_table.private-rt.id
}