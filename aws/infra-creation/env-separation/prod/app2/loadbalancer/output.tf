
output "id" {
    value = aws_elb.app2-prod-lb.id
}

output "arn" {
    value = aws_elb.app2-prod-lb.arn
}

output "name" {
    value = aws_elb.app2-prod-lb.name
}

output "dns_name" {
    value = aws_elb.app2-prod-lb.dns_name
}

output "instances" {
    value = aws_elb.app2-prod-lb.instances[*]
}

output "security-group" {
    value = aws_elb.app2-prod-lb.source_security_group_id
}
