output "app_runner_service_url" {
  description = "App Runner Service URL"
  value       = aws_apprunner_service.service.service_url
}

output "app_runner_service_id" {
  description = "App Runner Service ID"
  value       = aws_apprunner_service.service.id
}

output "app_runner_service_arn" {
  description = "App Runner Service ARN"
  value       = aws_apprunner_service.service.arn
}

output "vpc_connector_arn" {
  description = "VPC Connector ARN"
  value       = aws_apprunner_vpc_connector.connector.arn
} 