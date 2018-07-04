# AMC User Fix guide

**Goal**: The idea of this documentation is to trouble shoot and solve the spinning wheel user error in AMC.

## Check if the user has an Access and Refresh token assigned in AMC.

All the AMC users have match edX user (email match). This user is able to perform operation from AMC, using an access and refresh token. During the sign up/user creation process, those tokens are created in the edX end, and assigned (and saved) to the AMC user.

In order to check if the user has tokens assigned, go to https://amc-app.appsembler.com/admin/auth/user/ and search the user by email.

Open the user and go to the section *OAUTH TOKENS*

Even the tokens exists or not, now we need to check the edX end.

## Check Access and Refresh tokens in the edX end

The Django's OAuth2 Admin interface in edX is pretty bad for search, so the best way to make sure that a token exists or not in edX is to ssh into the VM and run this snippet.

1. SSH into any of the production edxapp VMs
2. Load the `edxapp` user and virtualenv
```
sudo su edxapp -s /bin/bash
source /edx/app/edxapp/edxapp_env
cd ~/edx-platform
```
3. Load the python shell
```
python manage.py lms --settings=amc shell
```
4. Run the following script
```
from provider.oauth2.models import AccessToken, RefreshToken
from django.contrib.auth.models import User

user_email = "user@email.com"

u = User.objects.get(email=user_email)
token = AccessToken.objects.get(user=u)
```

After perform this step we can face different scenarios, all of theme are covered bellow.

### Case 1 The token doesn't exists
If you get the following error:
```
>>> token = AccessToken.objects.get(user=u)
Traceback (most recent call last):
  File "<console>", line 1, in <module>
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/db/models/manager.py", line 127, in manager_method
    return getattr(self.get_queryset(), name)(*args, **kwargs)
  File "/edx/app/edxapp/venvs/edxapp/local/lib/python2.7/site-packages/django/db/models/query.py", line 334, in get
    self.model._meta.object_name
DoesNotExist: AccessToken matching query does not exist.
```
This means that the tokens hasn't been created in the edX end. We need to create the token manually in the Django's admin.

#### Create the Refresh and Access token
1. Go to `https://tahoe.appsembler.com/admin/oauth2/refreshtoken/`
2. Click on *Add refresh token*
3. Select the User from DropDown, after picking the User you can use the edit icon to verify that you choose the correct one.
4. Save the auto generated Refresh Token or set your own one.
5. In the Access Token field, click on the plus icon to create a new one.
6. Save the auto generated Access Token or set your own one.
7. Select the `https://amc-app.appsembler.com/complete/edx-oidc/` OAuth client.
8. Set the expiration to one year in the future.
9. For scope leave the default `read` value.
10. Save
11. Now back in the refresh token form, Select the `https://amc-app.appsembler.com/complete/edx-oidc/` OAuth client again.
12. Leave the `Expired` checkbox unchecked.

#### Set the new Token in AMC app
1. Go to `https://amc-app.appsembler.com/admin/auth/user/` and search for the user by email.
2. Open the edit form and go to the *OAUTH TOKENS* section.
3. Fill out the new Access and Refresh tokens.
4. Set the expiration to one year in the future.
5. For `token type`, set `Bearer`.
6. Save the user.

Now try to hijack the user, the spinning box should be gone. If the problem persists, we need to go to the next session.

## Check user site
If after fix the user tokens, the problem persists, it's probably because the user isn't assigned to any site in edX.

### Check the user organisation in AMC
1. Go to `https://amc-app.appsembler.com/admin/organizations/organization/`
2. Search for the Organisation by name, for example: *Redis* or *Cybereason*.
3. Open the organisation and check the user is inside org, so it's basically inside the *Chosen Users* box. If is not, check for the user and add it.

### Check for the user organisation in edX
1. Go to `https://tahoe.appsembler.com/admin/sites/site/`
2. Search for the Organisation by name, for example: *Redis* or *Cybereason*.
3. Check that the user is listed in the *User Mapping object* and is marked as an AMC admin.
