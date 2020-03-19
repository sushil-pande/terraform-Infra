provider "aws" {
    profile = "${var.profile}"
    region = "${var.region}"
}

module "vpc"{
    source = "./module/vpc"
    vpc_id = "${var.vpc_id}"
    env = "${var.env}"
    region = "${var.region}"
}

module "apigateway"{
    source = "./module/apigateway"
   # env = "${var.env}"
    region = "${var.region}"
    lambda_arn = "${module.lambda.lambda_function_arn}"
}

module "lambda" {
  source = "./module/lambda"
  
}