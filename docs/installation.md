# Tahoe dev environment setup

## AMC

## edX

For setting up edX for Tahoe, we need to use our custom server-vars.yml file and modified Vagrantfile which allows the inclusion of those variables.

```bash
mkdir ficus_devstack
cd ficus_devstack
// go to https://github.com/noderabbit-team/edx-configs/blob/master/appsembler/amc/dev/files/server-vars.yml
// and click the "view raw" link and copy the URL
mkdir src
curl "<paste URL here>" -o src/server-vars.yml
// go to https://github.com/appsembler/configuration/blob/appsembler/ficus/master/vagrant/release/devstack/Vagrantfile.amc
// and click the "view raw" link and copy the URL
curl "<paste URL here>" -o Vagrantfile
OPENEDX_RELEASE="open-release/ficus.3" vagrant up
```

We then need to checkout the custom theme. Do the following:

```bash
cd themes
git clone https://github.com/appsembler/edx-theme-codebase.git
cd edx-theme-codebase
git checkout ficus/master
git clone https://github.com/appsembler/edx-theme-customers.git customer_specific
cd customer_specific
git checkout ficus/amc
cd ../../..
vagrant ssh
sudo su edxapp
vim /edx/app/edxapp/lms.env.json
```

Make sure that the following settings are set like this:
```json
"COMPREHENSIVE_THEME_DIR": "/edx/app/edxapp/themes",
"COMPREHENSIVE_THEME_DIRS": [
    "/edx/app/edxapp/themes"
],
"DEFAULT_SITE_THEME": "edx-theme-codebase",
"ENABLE_COMPREHENSIVE_THEMING": true,
```

Then you can do:

```bash
cd /edx/app/edxapp/edx-platform
paver devstack lms --settings=devstack_appsembler
```

### Troubleshooting
On some versions Vagrant and OS X 10.12, there is a problem with NFS, Vagrant and file permissions. If you need to rerun `vagrant provision` for some reason and encounter an error when installing edx_ansible requirements, do the following:

```bash
vagrant ssh
sudo chmod -R 777 /edx/app/edx_ansible/venvs/edx_ansible/lib/python2.7/site-packages/
```

And rerun provisioning.
