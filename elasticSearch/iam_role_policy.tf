resource "aws_elasticsearch_domain_policy" "main" {
  domain_name = aws_elasticsearch_domain.default.domain_name

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {"aws:SourceIp": "${var.sourceIp}"}
            },
            "Resource": "${aws_elasticsearch_domain.default.arn}/*"
        }
    ]
}
POLICIES
}
