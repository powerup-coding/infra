# creates necessary storage bucket for terraform state to be stored
export REGION=us-east1
export PROJECT_ID=pwup-coding
gsutil mb -l $REGION gs://$PROJECT_ID-tf-state
gsutil versioning set on gs://$PROJECT_ID-tf-state/

# add permissions to service account to "do things"
export SA_NAME=terraform-dev
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member "serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role "roles/owner"

# must set this in workspace as well for terraform....reasons
export GOOGLE_APPLICATION_CREDENTIALS="./credentials/terraform-dev.key.json"

# show current tf state file
gsutil ls gs://${PROJECT_ID}-tf-state/dev/

# get node pool for cluster
export CLUSTER_NAME=pwup-coding-dev
export ZONE=export CLUSTER_NAME=your-project-dev                           
export ZONE=us-east1-b                          
gcloud container node-pools list --cluster=$CLUSTER_NAME --zone=$ZONE

# force update nodepool
gcloud container clusters upgrade $CLUSTER_NAME \
  --zone=$ZONE \
  --node-pool=dev-np-primary-preemptible

# set cluster credentials for kubectl
gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE
