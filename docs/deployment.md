# AMC deployment


## Terraform

To provision new infrastructure on GCP we use Terraform. This will only set up the
infrastructure and will *not* deploy anything to those machines, that's what Ansible
is for.

- Install Terraform `0.7.x`.
- To provision a staging env run the following

```bash
# If you don't know what a service account is plese speak
# with someone from the devops team.
export GOOGLE_CREDENTIALS=$(cat /path/to/your_service_account_for_amc_gcp_project.json)
# You can get AWS keys/secrets from the terraform user on AWS or ping
# someone on the devops team
export TF_VAR_aws_secret_key=secretkey
export TF_VAR_aws_access_key=key
# And finally
ENVIRONMENT=staging make plan
# Inspect the plan and make sure this does what you want
ENVIRONMENT=staging make apply
# This should create the needed infrastructure and print out
# the new IP of the node(s) along with AWS key/info that is used
# by AMC app and edX app
```

`NOTE`: Make sure your  using the `appsembler-amc` GCP project.

## Ansible

We use Ansible to provision our code onto the above created infrastructure.

`NOTE`: This assumes you have `virtualenvwrapper` installed locally.

```bash
mkvirtualenv amc
workon amc
pip install -r requirements/local.txt
# or just install Ansible like so
pip install ansible==2.1.2.0
cd deploy
ENVIRONMENT=staging make provision
```

Make sure to set the correct ENVIRONMENT. Accepted values are `staging` and `prod` (*not* production).

