data "terraform_remote_state" "step-2" {
  backend = "local"

  config = {
    path = "${path.module}/../step-2/terraform.tfstate"
  }
}
