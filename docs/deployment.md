# Tahoe deployment

Tahoe's infrastructure code currently lives in 2 repos. The terraform code lives in the
[amc repo](https://github.com/appsembler/amc/tree/develop/deploy/terraform) as does the Ansible
code for deploying Tahoe's AMC component.

The Ansible code for deploying the edX component lives in the [configuration repo](https://github.com/appsembler/configuration/tree/appsembler/ficus/master). We use the `appsembler/ficus/master` branch like
all the other custom deployments.


## Terrforming the infrastructure

To provision new infrastructure on GCP we use Terraform. This will only set up the
infrastructure and will *not* deploy anything to those machines, that's what Ansible
is for.

`NOTE`: This will create the infrastructure for both the AMC and edX components.

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

`TODO`: We should refactor this to use the amc ax plugin

## Deploying the AMC component

The AMC component get's auto deployed to staging on every push (via CircleCI). If you wish to deploy
manually run the following commands

```bash
cd amc/deploy
ENVIRONMENT=staging make provision
```

`TODO`: We should get rid of the makefile and the existing ax plugin to do this in the future.

## Deploying the edX component

We use Ansible to provision our code onto the above created infrastructure.

`NOTE`: This assumes you have `virtualenvwrapper` and `ax` installed locally.
`NOTE2`: It also assumes you have the amc ax plugin installed. See
[here](https://github.com/appsembler/amc/tree/develop/ax_plugins).

```bash
workon ax
ax amc deploy-edx --ansible-tag="deploy"
```

