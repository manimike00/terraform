## VPC

### Setup Environment variables

```shell
export BUCKETNAME=bucketname
export ENV=env
```
### Initialise Terraform
```shell
terraform init \
  -backend-config="bucket=$BUCKETNAME" \
  -backend-config="key=$ENV/VPC/terraform.state"
```

### Terraform Module Script
```terraform
module "vpc" {
  source      = "github.com/manimike00/terraform/vpc"
  name        = "demo"
  cidr_block  = "10.0.0.0/16"
  subnets     = 3
}
```


