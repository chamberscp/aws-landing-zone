provider "aws" {
  region = "us-east-1"
}

module "organizations" {
  source  = "terraform-aws-modules/organizations/aws"
  version = "~> 2.0"

  accounts = {
    Security   = { email = "security+aws@yourdomain.com" }
    LogArchive = { email = "logarchive+aws@yourdomain.com" }
    Sandbox    = { email = "sandbox+aws@yourdomain.com" }
    Prod       = { email = "prod+aws@yourdomain.com" }
    Dev        = { email = "dev+aws@yourdomain.com" }
  }

  feature_set = "ALL"
}

resource "aws_organizations_policy" "deny_root" {
  name        = "Deny-Root-User-Actions"
  description = "Blocks root user from doing anything"
  type        = "SERVICE_CONTROL_POLICY"
  content     = data.aws_iam_policy_document.deny_root.json
}

resource "aws_organizations_policy_attachment" "deny_root_org" {
  policy_id = aws_organizations_policy.deny_root.id
  target_id = module.organizations.organization_id
}

data "aws_iam_policy_document" "deny_root" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:root"]
    }
  }
}
