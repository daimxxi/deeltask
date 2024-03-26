data "vault_generic_secret" "aws-credentials" {
  path = "secrets-admin/terraform-aws"
}