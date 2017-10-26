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
