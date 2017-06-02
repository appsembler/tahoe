# AMC - Appsembler Management Console


## Installation

For AMC to work properly, an edX instance also has to be up and running. This section has instructions how to get the whole setup running, both AMC and edX.

### AMC
Requirements:

* pip: `easy_install pip`
* node.js (preferably 4.x.x or 5.x.x)
    * on OS X: `brew install node && npm install -g yarn`
    * on Linux: [read instructions](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)

## Instructions:

### Native env

1. Clone the project: `git clone git@github.com:appsembler/amc.git`
2. Create a virtualenv for the project:

    - using virtualenv:

            cd amc/
            virtualenv env
            source env/bin/activate

    - if you're using pyenv and pyenv-virtualenv (as you probably should):

            pyenv-virtualenv -p python2.7 amc
            cd amc/
            pyenv local amc

3. Install the requirements: `pip install -r requirements/local.txt`
4. Run the migrations: `python manage.py migrate --settings=config.settings.local`
5. Run the django app: `python manage.py runserver 0.0.0.0:9000 --settings=config.settings.local`
6. Open a new shell and install the yarn requirements: `cd frontend && yarn install`
7. In that second shell, run the webpack for asset compilation: `yarn start`
8. Happy hacking!

### Docker based dev env

1. On Linux install docker and docker-compose or just
2. If on Mac, install Docker for Mac.
2. cp env.example .env
3. Edit required variables or omit the ones that can be omitted (it should be indicated in the comments)
4. Make sure to set `LOCAL_USER_ID` in the .env  file to the `UID` of your user.
5. Run `docker-compose up`
6. Run `make migrate` to migrate the schema
7. For the frontend assest run:

        make build-frontend
        make yarn-install
        make yarn-compile

8. If your working on frontend code you might want: `make nmp-start`

9. Use `make help` to list all commands.

10. Follow the rest of the edX Vagrant based setup (for the edxapp part of AMC)

### edX-platform

Requirements:

* [Vagrant](https://www.vagrantup.com/downloads.html)
* make sure vagrant isn't running with vagrant halt
* vagrant-vbguest plugin: `vagrant plugin install vagrant-vbguest`
* if you're on Linux, install required NFS packages: `sudo apt-get install nfs-common nfs-kernel-server`

Instructions:

1. Create a folder where your AMC devstack will live: `mkdir amc_devstack`
2. `cd amc_devstack`
3. Download the Vagrantfile: `curl https://raw.githubusercontent.com/appsembler/configuration/appsembler/amc/develop/vagrant/release/devstack/Vagrantfile.amc -o Vagrantfile`
4. Start Vagrant: `vagrant up`.  This might take a while.
5. Create a oAuth2 client and run devstack the normal way:

        vagrant ssh
        sudo su edxapp
        python manage.py lms create_oauth2_client \
            "http://localhost:9000/" \
            "http://localhost:9000/oauth2/access_token/" \
            confidential --client_name AMC \
            --client_id 6f2b93d5c02560c3f93f \
            --client_secret 2c6c9ac52dd19d7255dd569fb7eedbe0ebdab2db \
            --trusted \
            --settings=devstack_appsembler
        paver devstack lms \
            --settings=devstack_appsembler
        # or paver devstack studio --settings=devstack_appsembler

5. You can access LMS at `http://localhost:8000` and Studio at `http://localhost:8001`
6. Set up theme requirements:

        # Exit the vagrant VM
        cd themes
        git clone git@github.com:appsembler/edx-theme-codebase.git
        cd edx-theme-codebase
        git clone https://github.com/appsembler/edx-theme-customers.git customer_specific
        vagrant ssh
        sudo su -s /bin/bash edxapp
        cd ~
        vim lms.env.json
        # Add the following or edit if they already exist
        # "COMPREHENSIVE_THEME_DIR": "",
        # "COMPREHENSIVE_THEME_DIRS": [
        #     "/edx/app/edxapp/themes"
        # ],
        # "ENABLE_COMPREHENSIVE_THEMING": true,
        # "THEME_NAME": “edx-theme-codebase"

        # Add the following to features
        # FEATURES:
        #  "USE_CUSTOM_THEME": false,
        #  "USE_MICROSITES": false,

7. Run: `paver install_prereqs --settings=devstack_appsembler`
8. Run: `paver update_assets lms --settings=devstack_appsembler`

## Basic Commands

### Setting Up Your Users

To create an **superuser account**, use this command:

    python manage.py createsuperuser --settings=settings

For convenience, you can keep your normal user logged in on Chrome and
your superuser logged in on Firefox (or similar), so that you can see
how the site behaves for both kinds of users.

### Testing fake user signups
In order to get to the signup form, we have to fake a user signup which usually happens on the Appsembler website by filling a HubSpot form. When that happens, HubSpot sends a webhook request to AMC to create an inactive user with no password set and passes the data from the filled form. To mimic that in development, there is a management command that creates an arbitrary number of those users:

    python manage.py --settings=settings generate_signups <num_of_users>

## Testing

### AMC

AMC uses py.test to run unit tests and run PyLint on all the files. All the tests are automatically run on CircleCI on each commit.

To run all the tests:

    py.test

To run all tests with code coverage data:

    py.test --cov --cov-report=term-missing --cov-report=html
    open htmlcov/index.html

To run all the tests under a single test case:

    py.test management_console/users/tests/test_forms.py:

To run a single test:

    py.test management_console/users/tests/test_forms.py::TestSignupForm::test_signup_success

When developing, it's useful to automatically run all the tests, watch the files for changes and automatically rerun all the failing tests:

    py.test -f

### edX

edX has a large and comprehesive test suite. Only Appsembler/AMC related tests will be described here.

To run the Appsembler LMS tests:

    vagrant ssh
    sudo su edxapp
    python manage.py lms test --settings=test_appsembler lms/djangoapps/appsembler_lms/

To run the Appsembler Studio tests:

    vagrant ssh
    sudo su edxapp
    python manage.py cms test --settings=test_appsembler cms/djangoapps/appsembler_cms/

For all other edX related testing tasks, see [edX testing](https://github.com/edx/edx-platform/blob/master/docs/en_us/internal/testing.rst) and [Test engineering FAQ](https://github.com/edx/edx-platform/wiki/Test-engineering-FAQ)

## Troubleshooting
When installing AMC requirements, if you encounter an install error `Error: pg_config executable not found.`:
* on Linux, you may fix it by doing `sudo apt-get install libpq-dev`
* on OS X, if you have Postgres installed via Homebrew or have Postgres.app installed, add the Postgres bin folder to you system path in your .bashrc or .zshrc: `export PATH=/Applications/Postgres.app/Contents/MacOS/bin:$PATH`

