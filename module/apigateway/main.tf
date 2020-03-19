resource "aws_api_gateway_rest_api" "api-gateway" {
  name        = "api-gateway"
  description = "Terraform Serverless Application Example"
}

 resource "aws_api_gateway_resource" "demo-resource" {
   rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
   parent_id   = "${aws_api_gateway_rest_api.api-gateway.root_resource_id}"
   path_part   = "{proxyPath}"
}

resource "aws_api_gateway_method" "demo-method" {
   rest_api_id   = "${aws_api_gateway_rest_api.api-gateway.id}"
   resource_id   = "${aws_api_gateway_resource.demo-resource.id}"
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
   resource_id = "${aws_api_gateway_method.demo-method.resource_id}"
   http_method = "${aws_api_gateway_method.demo-method.http_method}"

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = "${var.lambda_arn}"
}

 resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = "${aws_api_gateway_rest_api.api-gateway.id}"
   resource_id   = "${aws_api_gateway_rest_api.api-gateway.root_resource_id}"
   http_method   = "ANY"
   authorization = "NONE"
}

 resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
   resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
   http_method = "${aws_api_gateway_method.proxy_root.http_method}"

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = "${var.lambda_arn}"
}

resource "aws_api_gateway_deployment" "api-gateway" {
   depends_on = [
     "aws_api_gateway_integration.lambda",
     "aws_api_gateway_integration.lambda_root",
   ]

   rest_api_id = "${aws_api_gateway_rest_api.api-gateway.id}"
   stage_name  = "test"
 }