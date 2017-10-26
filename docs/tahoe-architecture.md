# Tahoe Architecture

Tahoe as a platform consists of two main parts - AMC (Appsembler Management Console) and a multitenant edX deployment. The two parts are connected using
REST APIs.

## AMC

AMC is a React app coupled with a Django backend meant for administration of edX sites on Tahoe.

### Signup process

Signup process on Tahoe consists of several steps:

1. User enters their basic information and submits the info. This creates a user and an organization in the AMC database and sends an activation link to the user.
2. User clicks the activation link and is redirected to step 3
3. In step 3, user chooses their password. That password will be used on both AMC and edX (at least initially). In this step, three things are done:
  * password is set for the AMC user
  * a user is created in the edX database with that password
  * OAuth2 tokens for that user from edX are saved in the AMC database to allow using of edX REST APIs
4. User selects their subdomain on `tahoe.appsembler.com`, platform name, colors, logos and fonts. All that is persistent in a redux store on the frontend before sending it in the final step.
5. User finishes the registration, a request with all the data is sent to edX. An organization is created in the edX database, user is assigned to it and a new site is created in edX.

## edX

Tahoe uses edX microsites (now just called sites) to enable multitenancy on the edX platform. Each registered user on Tahoe gets a new site in edX along with custom theming and content.

### Theming

Tahoe uses the Appsembler custom theme with some customizations in the `customer_specific` folder inside the theme. Currently the following branches are used:

* [edx-theme-codebase](https://github.com/appsembler/edx-theme-codebase): `ficus/master`
* [edx-theme-customers](https://github.com/appsembler/edx-theme-customers) `ficus/amc`

`edx-theme-codebase` repo contains the theme base that is same for all customers, be it Tahoe or enterprise customers. It is also the folder that edX theme configuration options point to.
`edx-theme-customers` repo contains per-customer or per-project (in case of Tahoe) overrides of the theme base. That repo is supposed to be cloned into the folder named `customer_specific` inside the theme base folder.
Those overrides will be picked up automatically by edX and used instead of the defaults in theme base.

For Tahoe, variables in the `customer_specific` override are loaded dynamically from the edX database because they are different for every site/customer on Tahoe. Every site/customer also has an extra CSS stylesheet that's dynamically generated on every change to the site in AMC and uploaded to S3. Those values from the DB are dynamically injected when compiling SASS to CSS instead of the static file [_branding-basics.scss](https://github.com/appsembler/edx-theme-customers/blob/ficus/amc/lms/static/sass/base/_branding-basics.scss) that would be used for enterprise deployments instead. It will be loaded after the default theme CSS files and it's the file that defines the look of a customer site. 

### Content

For static page content, `customer_specific` override variables load page content from the database and show it on the edX site. It also includes header and footer items. For details, see [theme-variables.html](https://github.com/appsembler/edx-theme-customers/blob/ficus/amc/lms/templates/theme-variables.html).
