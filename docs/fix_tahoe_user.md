# AMC User Fix guide

**Goal**: The idea of this documentation is to trouble shoot and solve the spinning wheel user error in AMC.

## Check if the user has an Access and Refresh token assigned in AMC.

All the AMC users have match edX user (email match). This user is able to perform operation from AMC, using an access and refresh token. During the sign up/user creation process, those tokens are created in the edX end, and assigned (and saved) to the AMC user.

## Ensure Access and Refresh Tokens exists in the LMS

1. SSH into any of the production edxapp VMs
2. Load the `edxapp` user and virtualenv
```
sudo -s -- sudo -Hsu edxapp
```

3. Load the python shell
```
python manage.py lms --settings=amc shell
```

4. Run the following script
```python
from datetime import timedelta
from provider.oauth2.models import AccessToken, RefreshToken, Client
from django.db.models.query import Q
from provider.utils import now
from django.contrib.auth.models import User
from organizations.models import UserOrganizationMapping, Organization, UserSiteMapping


def get_by_org_name(org_name):
    org = Organization.objects.get(Q(name=org_name) | Q(short_name=org_name))
    assert org.sites.count() == 1, 'Should have one and only one site.'
    site = org.sites.all()[0]
    return org, site
    

def ensure_access_token(email, org_name):
    url = 'https://amc-app.appsembler.com/complete/edx-oidc/'
    client = Client.objects.get(redirect_uri=url)
    u = User.objects.get(email=email)
    org, site = get_by_org_name(org_name)
    UserOrganizationMapping.objects.get_or_create(user=u, organization=org)
    UserSiteMapping.objects.get_or_create(user=u, site=site)
    try:
        access = AccessToken.objects.get(user=u, client=client)
    except AccessToken.DoesNotExist:
        access = AccessToken.objects.create(
            user=u,
            client=client,
            expires=now() + timedelta(days=366),
        )
        print('New AccessToken created')
    print('AccessToken:', access)
    try:
        refresh = RefreshToken.objects.get(user=u, access_token=access, client=client)
    except RefreshToken.DoesNotExist:
        refresh = RefreshToken.objects.create(
            user=u,
            client=client,
            access_token=access,
        )
        print('New RefreshToken created')
    print('RefreshToken:', refresh)


def ensure_amc_admin(email, org_name):
    u = User.objects.get(email=email)
    org, site = get_by_org_name(org_name)
    om, _ = UserOrganizationMapping.objects.get_or_create(user=u, organization=org)
    om.is_active = True
    om.is_amc_admin = True
    om.save()
    #
    sm, _ = UserSiteMapping.objects.get_or_create(user=u, site=site)
    sm.is_active = True
    sm.is_amc_admin = True
    sm.save()


ensure_access_token('mat@gmail.com', 'delta-rook')
```

If the user has no organization, please assign them to one. See the Case 2 section below.

This script, when successful should print the user organization ina addition to the access
and refresh tokens e.g.:

```
Organization for MHaton is delta-rook
AccessToken xzxzxxzxzxxzxzxxzxzxxzxzx
New RefreshToken created
RefreshToken: xzxzxxzxzxxzxzxxzxzxxzxzx
```

The function `ensure_access_token` can be called multiple times without a problem, since it won't override
existing tokens.

#### Set the new Token in AMC app
1. Go to `https://amc-app.appsembler.com/admin/auth/user/` and search for the user by email.
2. Open the edit form and go to the *OAUTH TOKENS* section.
3. Fill out the new Access and Refresh tokens.
4. Set the expiration to one year in the future.
5. For `token type`, set `Bearer`.
6. Save the user.

Now try to hijack the user, the spinning box should be gone. If the problem persists, we need to go to the next session.

### Case 2: Check user site
If after fix the user tokens, the problem persists, it's probably because the user isn't assigned to any site in edX.

Use the `ensure_amc_admin` function to connect a user with an organization and its stie.

```python
ensure_amc_admin('mat@gmail.com', 'delta-rook')
```
