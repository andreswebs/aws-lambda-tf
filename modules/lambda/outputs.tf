output "lambda_alias_arn" {
  value       = module.alias.lambda_alias_arn
  description = "Lambda alias ARN"
}

output "lambda_iam_role" {
  value       = module.lambda_base.iam_role
  description = "The Lambda execution IAM role"
}

output "lambda_log_group" {
  value       = module.lambda_base.log_group
  description = "The Lambda log group"
}
