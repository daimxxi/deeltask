provider "aws" {
  region     = var.aws_region
  access_key = data.vault_generic_secret.aws-credentials.data["key"]
  secret_key = data.vault_generic_secret.aws-credentials.data["secret"]
}

provider "vault" {
  address = var.vault_url
}