commands
terraform init -backend-config .\env-dev\state.tfvars
terraform apply --var-file .\env-dev\main.tfvars --auto-approve
terraform destroy --var-file .\env-dev\main.tfvars --auto-approve

make dev-apply