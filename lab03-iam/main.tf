terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    s3  = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

# --- Bucket S3 de exemplo, ao qual a role tera acesso restrito ---

resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name

  tags = {
    Name    = "${var.project_name}-lab03-bucket"
    Project = var.project_name
  }
}

# --- Trust policy: quem pode assumir esta role (apenas o servico EC2) ---

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_role" {
  name               = "${var.project_name}-lab03-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json

  tags = {
    Name    = "${var.project_name}-lab03-role"
    Project = var.project_name
  }
}

# --- Policy de least privilege: so o necessario, nada de "*" em Resource ---

data "aws_iam_policy_document" "s3_least_privilege" {
  statement {
    sid    = "ListSpecificBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.app_bucket.arn,
    ]
  }

  statement {
    sid    = "ReadWriteObjectsInSpecificBucket"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.app_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_least_privilege" {
  name        = "${var.project_name}-lab03-s3-policy"
  description = "Permite apenas listar e ler/escrever objetos no bucket especifico deste lab - nada de acesso a outros buckets ou outros servicos"
  policy      = data.aws_iam_policy_document.s3_least_privilege.json

  tags = {
    Name    = "${var.project_name}-lab03-s3-policy"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.s3_least_privilege.arn
}

# --- Instance profile: e o que efetivamente se anexa a uma instancia EC2 ---

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project_name}-lab03-instance-profile"
  role = aws_iam_role.app_role.name
}
