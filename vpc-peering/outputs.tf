output "customer_vpc_id" { value = aws_vpc.customer.id }
output "account_vpc_id" { value = aws_vpc.account.id }
output "statement_vpc_id" { value = aws_vpc.statement.id }

output "customer_public_subnet_ids" { value = [for s in aws_subnet.customer_public : s.id] }
output "customer_private_subnet_ids" { value = [for s in aws_subnet.customer_private : s.id] }
output "account_public_subnet_ids" { value = [for s in aws_subnet.account_public : s.id] }
output "account_private_subnet_ids" { value = [for s in aws_subnet.account_private : s.id] }
output "statement_public_subnet_ids" { value = [for s in aws_subnet.statement_public : s.id] }
output "statement_private_subnet_ids" { value = [for s in aws_subnet.statement_private : s.id] }

output "bastion_public_ip" { value = aws_instance.bastion.public_ip }

output "customer_service_private_ips" { value = [aws_instance.customer_service_a.private_ip, aws_instance.customer_service_b.private_ip] }
output "account_service_private_ips" { value = [aws_instance.account_service_a.private_ip, aws_instance.account_service_b.private_ip] }
output "statement_service_private_ips" { value = [aws_instance.statement_service_a.private_ip, aws_instance.statement_service_b.private_ip] }

output "customer_lb_dns" { value = aws_lb.customer_lb.dns_name }
output "account_lb_dns" { value = aws_lb.account_lb.dns_name }
output "statement_lb_dns" { value = aws_lb.statement_lb.dns_name }

output "customer_profile_url" {
	value = "http://${aws_route53_record.customer_record.name}/"
	description = "URL to access the customer profile service"
}

output "account_service_url" {
	value = "http://${aws_route53_record.account_service_record.name}/"
	description = "URL to access the account service (alias for account ALB)"
}

output "statement_service_url" {
	value = "http://${aws_route53_record.statement_service_record.name}/"
	description = "URL to access the statement service (alias for statement ALB)"
}

output "customer_key_path" { value = local_file.customer_private_key.filename }
output "account_key_path" { value = local_file.account_private_key.filename }
output "statement_key_path" { value = local_file.statement_private_key.filename }

output "pcx_customer_to_account_id" { value = aws_vpc_peering_connection.customer_to_account.id }
output "pcx_account_to_statement_id" { value = aws_vpc_peering_connection.account_to_statement.id }
