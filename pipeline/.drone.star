def image_build_push_step(ctx):
  if ctx.build.branch == "develop":
      repo = "dev"
  elif ctx.build.branch == "staging":
      repo = "stage"
  elif ctx.build.branch == "master":
      repo = "prod"

  return {
    "name": "image-build-push",
    "image": "plugins/ecr",
    "settings": {
      "access_key": from_secret("access_key"),
      "secret_key": from_secret("secret_key"),
      "registry": from_secret("registry"),
      "repo": repo,
      "create_repository": "false",
      "tags": ctx.build.commit[:7],
      "dockerfile": "./application/Dockerfile",
      "context": "./application",
    },
  },

def deploy_step(ctx):
  if ctx.build.branch == "develop":
      repo = "dev"
  elif ctx.build.branch == "staging":
      repo = "stage"
  elif ctx.build.branch == "master":
      repo = "prod"

  tag = ctx.build.commit[:7]
  DOCKER_CONTAINER_NAME = "main"

  return {
    "name": "deploy-container",
    "image": "appleboy/drone-ssh",
    "when": {
      "branch": ["master"],
      "event": ["push"],
    },
    "settings": {
      "host": [from_secret("host")],
      "username": from_secret("username"),
      "password": from_secret("ssh_password"),
      "environment": {
        "AWS_ACCOUNT_ID": {"from_secret": "AWS_ACCOUNT_ID"},
        "AWS_REGION": {"from_secret": "AWS_REGION"},
        },
      "script": [
        'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com',
        'docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/{}:{}'.format(repo, tag),

        'docker stop {} || true'.format(DOCKER_CONTAINER_NAME),
        'docker rm {} || true'.format(DOCKER_CONTAINER_NAME),

        'docker run -d --name {} -p 80:80 ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/{}:{}'.format(DOCKER_CONTAINER_NAME, repo, tag)
      ]
    },
  }


def from_secret(name):
  return {
    "from_secret": name,
  }


def build_push_steps(ctx):
  return [
    image_build_push_step(ctx),
    deploy_step(ctx)
  ]


def main(ctx):
  return {
    "kind": "pipeline",
    "type": "docker",
    "name": "image-build-push",
    "trigger": {
      "branch": { "include": ["develop", "staging", "master"] },
      "event": ["push"],
    },
    "steps": build_push_steps(ctx)
  }