# VPC
### Terraform Module Script
```terraform
module "vpc" {
  source      = "github.com/manimike00/terraform/vpc"
  name        = "demo"          # Name of VPC
  cidr_block  = "10.0.0.0/16"   # CIDR Block for VPC 
  subnets     = 3               # Depends on Availability Zones
}
```

## Steps:
### 1. Setup Environment variables
```shell
export BUCKETNAME=bucketname
export ENV=env
```
### 2. Initialise Terraform
```shell
terraform init \
  -backend-config="bucket=$BUCKETNAME" \
  -backend-config="key=$ENV/VPC/terraform.state"
```
### 3. Deploy VPC
```shell
terraform plan
terraform apply --auto-approve
```
