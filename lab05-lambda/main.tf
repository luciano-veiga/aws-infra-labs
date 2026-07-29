terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3     = "http://localhost:4566"
    iam    = "http://localhost:4566"
    lambda = "http://localhost:4566"
    sts    = "http://localhost:4566"
    logs   = "http://localhost:4566"
  }
}

# --- Bucket S3 que dispara a Lambda a cada novo objeto ---

resource "aws_s3_bucket" "trigger_bucket" {
  bucket = var.bucket_name

  tags = {
    Name    = "${var.project_name}-lab05-bucket"
    Project = var.project_name
  }
}

# --- Empacota o codigo da funcao em um .zip automaticamente ---

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/function_src"
  output_path = "${path.module}/build/function.zip"
}

# --- Trust policy: apenas o servico Lambda pode assumir esta role ---

data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lab05-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  tags = {
    Name    = "${var.project_name}-lab05-lambda-role"
    Project = var.project_name
  }
}

# --- Least privilege: so escrever logs e ler o bucket especifico, nada mais ---

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    sid    = "WriteLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "ReadTriggerBucket"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = ["${aws_s3_bucket.trigger_bucket.arn}/*"]
  }
}

resource "aws_iam_role_policy" "lambda_permissions" {
  name   = "${var.project_name}-lab05-lambda-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_permissions.json
}

# --- Funcao Lambda ---

resource "aws_lambda_function" "on_object_created" {
  function_name    = "${var.project_name}-lab05-on-object-created"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10

  tags = {
    Name    = "${var.project_name}-lab05-lambda"
    Project = var.project_name
  }
}

# --- Permissao para o S3 invocar esta Lambda especifica ---

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.on_object_created.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.trigger_bucket.arn
}

# --- Notificacao do bucket: chama a Lambda a cada objeto criado ---

resource "aws_s3_bucket_notification" "trigger" {
  bucket = aws_s3_bucket.trigger_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.on_object_created.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
