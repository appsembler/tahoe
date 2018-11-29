# Tahoe development environment documentation

The Tahoe development environment documentation setup consist in two big pieces. The edX platform Vagrant Box setup, which uses our own Appsembler branch with some customizations and the Management Console (A.K.A. AMC) setup which is a Django project running locally, but it need to connect to the edX platform box via HTTP.

## edX platform vagrant box setup

### Software Prerequisites

Devstack requires the following software.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 4.3.12 or later.
* [Vagrant](https://www.vagrantup.com/downloads.html) 1.6.5 or later.
* A Network File System (NFS) client, if your operating system does not include one. Devstack uses VirtualBox Guest Editions to share folders through NFS.

### Installing Devstack with a Direct Vagrant Box Download
1. Ensure the `nfsd` client is running.
2. Create the `devstack` directory and navigate to it in the command prompt
```
mkdir devstack
cd devstack
```
3. Download the Devstack Vagrant file.
```
curl -L https://raw.githubusercontent.com/appsembler/configuration/appsembler/ficus/master/vagrant/release/devstack/Vagrantfile.amc > Vagrantfile
```

https://github.com/appsembler/configuration/blob/appsembler/ficus/master/vagrant/release/devstack/Vagrantfile.amc

4. Install the Vagrant vbguest plugin.
```
vagrant plugin install vagrant-vbguest
```
5. Create the server vars file for the Ansible provisioning
```
mkdir devstack/src
vi devstack/src/server-vars.yml
```
and copy the content of the [example server-vars.yml file](server-vars.yml.md).
The piece that you need to fill out, it's the `EDXAPP_GIT_IDENTITY` that is used to clone and checkout the [edx-theme-codebase](https://github.com/appsembler/edx-theme-codebase) repository.
Here is the documentation to generate a new deploy key and add it to github: [https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys)

6. Create the Devstack virtual machine.
```
vagrant up
```
The first time you create the Devstack virtual machine, Vagrant downloads the base box, which has a file size of about 4GB. If you destroy and recreate the virtual machine, Vagrant re-uses the box it downloaded. See Vagrant’s documentation on boxes for more information.
7. When prompted, enter the administrator password for your local computer.

### Run LMS and Studio
In order to start the LMS and Studio development servers you need to run the following commands.

### Setup you hosts file to use the devstack
Edit your `/etc/hosts` file and add the following entries:
```
127.0.0.1	edx.test
127.0.0.1	studio.edx.test
```

####Connect to you vagrant box
1. To connect to the Devstack virtual machine, use the SSH command from the devstack directory.
```
vagrant ssh
```
2. To use Devstack and perform any of the tasks described in this section, you must connect as the user edxapp and load the python env.
```
sudo su edxapp -s /bin/bash
source /edx/app/edxapp/edxapp_env
```

#### LMS
```
paver devstack lms --settings devstack_appsembler
```
Open the LMS in your browser at http://edx.test:8000/
#### Studio
```
paver devstack studio --settings devstack_appsembler
```
Open Studio in your browser at http://studio.edx.test:8001/

## AMC Setup

### Install Postgres

We need Postgres for the tiers app, this app is installed in edX and in AMC as well, and they share the database.

Check that Homebrew is healthy:
```
$ brew update
$ brew doctor
```

You can also install lunchy
```
gem install lunchy
```
And the you can
```
lunchy [start|restart|stop] postgres
```

Create DB and users

To enter to db shell
```
$ psql postgres
```

Create user
```
createuser amc
```
```
ALTER ROLE amc SUPERUSER;
\q
```
Enter again using the abc user

Create database
```
$ psql postgres -U amc
psql (10.2)
Type "help" for help.

postgres=# CREATE DATABASE amc;
```

### Create python3 virtualenv
Install python3
```
brew install python3
```
Create virtualenv
```
virtualenv -p python3 amc3
source amc3/bin/activate
```
Upgrade PIP
```
pip install --upgrade pip
```
Inside the amc code directory run
```
$ pip install -r requirements/local.txt
```

If you get a PIL error:
```
Traceback (most recent call last):
      File "<string>", line 1, in <module>
      File "/private/var/folders/cr/_mvfdb7d4sn49vwc__6__w1r0000gn/T/pip-build-xz0t2vfn/Pillow/setup.py", line 753, in <module>
        zip_safe=not debug_build(), )
      File "/Users/melvin/Appsembler/amc3/lib/python3.6/site-packages/setuptools/__init__.py", line 129, in setup
        return distutils.core.setup(**attrs)
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/core.py", line 148, in setup
        dist.run_commands()
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/dist.py", line 955, in run_commands
        self.run_command(cmd)
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/dist.py", line 974, in run_command
        cmd_obj.run()
      File "/Users/melvin/Appsembler/amc3/lib/python3.6/site-packages/setuptools/command/install.py", line 61, in run
        return orig.install.run(self)
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/command/install.py", line 545, in run
        self.run_command('build')
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/cmd.py", line 313, in run_command
        self.distribution.run_command(command)
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/dist.py", line 974, in run_command
        cmd_obj.run()
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/command/build.py", line 135, in run
        self.run_command(cmd_name)
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/cmd.py", line 313, in run_command
        self.distribution.run_command(command)
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/dist.py", line 974, in run_command
        cmd_obj.run()
      File "/usr/local/Cellar/python3/3.6.4_2/Frameworks/Python.framework/Versions/3.6/lib/python3.6/distutils/command/build_ext.py", line 339, in run
        self.build_extensions()
      File "/private/var/folders/cr/_mvfdb7d4sn49vwc__6__w1r0000gn/T/pip-build-xz0t2vfn/Pillow/setup.py", line 521, in build_extensions
        ' using --disable-%s, aborting' % (f, f))
    ValueError: jpeg is required unless explicitly disabled using --disable-jpeg, aborting
```

To solve this error run:
```
brew install libjpeg zlib
```
You may also need to force-link zlib using the following:
```
brew link zlib --force
```

### Frontend
Install yarn
```
brew install yarn
```
move to the frontend directory and install NPM requirements
```
$ cd frontend/
$ npm install
```
Start yarn
```
$ yarn start
$ yarn
```

### edX access key and secret
Go to the Django Admin: `/admin/oauth2/client/` and click on "Add client".

User: Click on the magnifier and select a superuser user.
Name: AMC
URL: http://example.com
Redirect URL: http://example.com
Client id: Use defaults
Client secret: Use defaults
Client type: Confidential (Web Application)

in the AMC root folder create a amc.env file with the following content

```
export DJANGO_DEBUG=true
export DJANGO_CELERY_ALWAYS_EAGER=true
export SSL_ENABLED=false
export DATABASE_URL=postgres://amc:@127.0.0.1:5432/amc
export BROKER_URL=redis://localhost:6379/1
export LMS_BASE_URL=http://edx.test:8000
export CMS_BASE_URL=edx.test:8001
export APPSEMBLER_EDX_OAUTH_CLIENT_ID=oauth_id
export APPSEMBLER_EDX_OAUTH_CLIENT_SECRET=oauth_secret
export APPSEMBLER_EDX_API_KEY=test # check this value in lms.auth.json and cms.auth.json under the var EDX_API_KEY
export APPSEMBLER_SECRET_KEY=secret_key # check this value in lms.auth.json and cms.auth.json under the var SECRET_KEY
export DJANGO_CELERY_ALWAYS_EAGER=true
export OAUTHLIB_INSECURE_TRANSPORT=1

export DJANGO_SETTINGS_MODULE=config.settings
export DJANGO_SECRET_KEY=secretkey
export DJANGO_ALLOWED_HOSTS=*

# NOTE for Mac users: check the user id inside the docker-machine
# docker-machine ssh default
# and then use the "id" command to the UID of the user and
# the GID of the "docker" group. Most likely UID will be 1000
# and docker group GID will be 100
export LOCAL_USER_ID=501
export DOCKER_GROUP_ID=20

export DJANGO_INTERCOM_APP_ID=set_me_please
export DJANGO_INTERCOM_APP_SECRET=set_me_please
export DJANGO_GOOGLE_ANALYTICS_APP_ID=set_me_please
export DJANGO_MIXPANEL_APP_ID=set_me_please
export DJANGO_HUBSPOT_API_KEY=set_me_please
```

Reference
* https://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/
* https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb


AMC Postgress

The edX app connection string must point to the host internal IP, since the AMC database lives in the host, and not in the Vagrant box.

postgres://bezidejni:@192.168.1.44:5432/amc

1. Edit the file `/usr/local/var/postgres/postgresql.conf` (in mac OS X) and set the variable `listen_addresses = '*'` to allow all hosts to connect, this is super insecure in staging or productions environments, but is ok for local development.
2. Edit the file `/usr/local/var/postgres/pg_hba.conf` and add the lines:
	 ```
	 # devstack
	 host  all  all  0.0.0.0/0  trust
	 ```
	 at the end of the file, where the allowed connections are defined.
4. Restart Postgres `brew services restart postgresql`

#### Run the AMC development server
```
python amc/manage.py runserver 0.0.0.0:8000
```
