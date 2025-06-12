output "this" {
  value = merge(
    {
      # url = aws_lambda_function_url.this.function_url
      url = "https://${aws_cloudfront_distribution.this.domain_name}"
    },
    module.lambda,
    module.lambda_base,
  )
}
