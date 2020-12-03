clear_plans:
	rm -rf *.tfplan

get_credentials:
	gcloud container clusters get-credentials pwup-coding-dev --zone=us-east1-b

plan:
	terraform plan -var-file=values.tfvars -out=plan.tfplan

apply:
	terraform apply "plan.tfplan"

plan.destroy:
	terraform plan -destroy -out destroy.plan

apply.destroy:
	terraform apply "destroy.plan"
	