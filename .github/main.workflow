workflow "New workflow" {
  on = "push"
  resolves = ["Step2 - Collect Build Info"]
}

action "Step1 - Build app" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["go build go --no-registry"]
  env = {
    CRED = "username"
  }
}

action "Step2 - Upload" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["upload hello generic-local --build-name=my-build --build-number=2"]
  env = {
    CRED = "username"
  }
  needs = ["Step1 - Publish package"]
}

action "Step3 - Collect Build Info" {
  uses = "retgits/actions/jfrog-cli-go@master"
  secrets = ["URL", "USER", "PASSWORD"]
  args = ["build-collect-env my-build 2","build-publish my-build 2"]
  env = {
    CRED = "username"
  }
  needs = ["Step2 - Upload"]
}
