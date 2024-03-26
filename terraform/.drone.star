
def terraform_format_step(ctx):
  return {
    "name": "terraform-format",
    "image": "hashicorp/terraform",
    "when": {
      # "branch": [],
      "event": ["push"],
    },
    "commands": [
       'terraform fmt -check=true -recursive',
    ]
  }

def terraform_validate_step(ctx):
  return {
    "name": "terraform-validate",
    "image": "hashicorp/terraform",
    "when": {
      # "branch": [],
      "event": ["push"],
    },
    "commands": [
       'terraform init',
       'terraform validate'
    ]
  }

def terraform_tfsec_step(ctx):
  return {
    "name": "terraform-tfsec",
    "image": "aquasec/tfsec",
    "when": {
      # "branch": [],
      "event": ["push"],
    },
    "commands": [
       'tfsec .'
    ]
  }

def terraform_detect_secret_step(ctx):
  return {
    "name": "detect-secrets",
    "image": "sliide/gdscan",
    "when": {
      # "branch": [],
      "event": ["push"],
    },
    "commands": [
       'gdscan -r -v .'
    ]
  }

def terraform_plan_step(ctx):
  return {
    "name": "terraform-plan",
    "image": "hashicorp/terraform",
    "when": {
      "branch": ["staging"],
      "event": ["push"],
    },
    "commands": [
       'terraform init',
       'terraform plan'
    ]
  }

def terraform_apply_step(ctx):
  return {
    "name": "terraform-plan",
    "image": "hashicorp/terraform",
    "when": {
      "branch": ["master"],
      "event": ["push"],
    },
    "commands": [
       'terraform init',
       'terraform apply --auto-approve'
    ]
  }

def terraform_steps(ctx):
  return [
    terraform_format_step(ctx),
    terraform_validate_step(ctx),
    terraform_tfsec_step(ctx),
    terraform_detect_secret_step(ctx),
    terraform_plan_step(ctx),
    terraform_apply_step(ctx)
  ]

def main(ctx):
  return {
    "kind": "pipeline",
    "type": "docker",
    "name": "terraform-lint-plan-apply",
    "trigger": {
      "branch": { "include": ["staging", "master"] },
      "event": ["push"],
    },
    "steps": terraform_steps(ctx)
  }