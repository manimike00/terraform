output "vpcArn" {
    value = aws_vpc.main.arn
}

output "vpcCidrBlock" {
    value = aws_vpc.main.cidr_block
}

output "vpcId" {
    value = aws_vpc.main.id
}

output "publicSubnetIds" {
    value = aws_subnet.publicsubnets.*.id
}

output "privateSubnetIds" {
    value = aws_subnet.privatesubnets.*.id
}

output "dBSubnetIds" {
    value = aws_subnet.dbsubnets.*.id
}
output "internetGatewayId" {
    value = aws_internet_gateway.gw.id
}

output "natGatewayId" {
    value = aws_nat_gateway.natgw.*.id
}