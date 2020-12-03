clear_plans:
	rm -rf *.tfplan

get_credentials:
	gcloud container clusters get-credentials pwup-coding-dev --zone=us-east1-b 