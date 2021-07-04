output "server" {
  value = aws_instance.postgres.public_ip
}