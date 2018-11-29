---

edx_platform_repo: "https://github.com/appsembler/edx-platform.git"
edx_ansible_source_repo: "https://github.com/appsembler/configuration"

EDX_VERSION: "open-release/ficus.master"
edx_platform_version: "appsembler/amc/develop"
configuration_version: "appsembler/ficus/master"
certs_version: "{{ EDX_VERSION | default('open-release/ficus.master') }}"
forum_source_repo: "https://github.com/appsembler/cs_comments_service.git"
forum_version: "{{ EDX_VERSION | default('open-release/ficus.master') }}"
xqueue_version: "{{ EDX_VERSION | default('open-release/ficus.master') }}"
NOTIFIER_VERSION: "{{ EDX_VERSION | default('open-release/ficus.master') }}"

EDXAPP_DEFAULT_COURSE_MODE_SLUG: "honor"

EDXAPP_APPSEMBLER_FEATURES:
  TMP: 'none'

EDXAPP_ENABLE_AUTO_AUTH: true

EDXAPP_USE_GIT_IDENTITY: true
EDXAPP_GIT_IDENTITY: |
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAKCAQEA4pNFyN1gFjQ9RHfgWbJWzaHpYzM9WWtwAuYkSCAWAAsF0aT0
  ...
  cVXIa84zodEBu9Jaq2jWolV/4eNMpr7KHvA1Lhu/RGahFuyCGLpq7WOZzqp+dNi4
  Sg06X+bPZckGSyllFNbuGPamljRAmoBtb7pk9Y4AcDkLkE5AoR+O
  -----END RSA PRIVATE KEY-----

EDXAPP_FEATURES:
  ENABLE_SERVICE_STATUS: True
  ENVIRONMENT: "{{ COMMON_ENVIRONMENT }}"
  AUTH_USE_OPENID_PROVIDER: true  # default: true
  ENABLE_OAUTH2_PROVIDER: true  # default: false
  ALLOW_ALL_ADVANCED_COMPONENTS: true  # default: false
  ENABLE_LTI_PROVIDER: true  # default: false
  ENABLE_SYSADMIN_DASHBOARD: True  # default: false
  CERTIFICATES_ENABLED: true  # default: true  <- check
  CERTIFICATES_HTML_VIEW: true
  ENABLE_DISCUSSION_SERVICE: true  # default: true
  ENABLE_DISCUSSION_HOME_PANEL: true
  ENABLE_INSTRUCTOR_ANALYTICS: true  # default: false
  PREVIEW_LMS_BASE: "{{ EDXAPP_PREVIEW_LMS_BASE }}"
  ENABLE_S3_GRADE_DOWNLOADS: true  # default: true
  USE_CUSTOM_THEME: "{{ edxapp_use_custom_theme }}"
  ENABLE_MKTG_SITE: "{{ EDXAPP_ENABLE_MKTG_SITE }}"  # default: false
  AUTOMATIC_AUTH_FOR_TESTING: "{{ EDXAPP_ENABLE_AUTO_AUTH }}"  # default: false
  ENABLE_THIRD_PARTY_AUTH: true
  #search features in CMS
  ENABLE_COURSEWARE_INDEX: true  # default: false
  ENABLE_LIBRARY_INDEX: true  # default: false
  #search features in LMS
  ENABLE_COURSEWARE_SEARCH: true  # default: false
  ENABLE_DASHBOARD_SEARCH: true  # default: false
  ENABLE_COURSE_DISCOVERY: true # default: false
  ENABLE_COMBINED_LOGIN_REGISTRATION: true  # default: false
  ALLOW_HIDING_DISCUSSION_TAB: true
  #for prereqs
  MILESTONES_APP: true
  ENTRANCE_EXAMS: true
  ENABLE_SPECIAL_EXAMS: true
  ENABLE_PREREQUISITE_COURSES: true
  CUSTOM_COURSES_EDX: true
  #for bulk email
  ENABLE_INSTRUCTOR_EMAIL: true
  REQUIRE_COURSE_EMAIL_AUTH: true
  ENABLE_MOBILE_REST_API: true
  ORGANIZATIONS_APP: true
  # to avoid non staff user creating courses in studio
  ENABLE_CREATOR_GROUP: true
  LICENSING: true
  # needed temporarily
  AMC_APP_URL: "https://staging-amc-app.appsembler.com"
  ENABLE_TIERS_APP: true

EDXAPP_EXTRA_REQUIREMENTS:
  - name: "git+https://github.com/pmitros/FeedbackXBlock.git#egg=feedback-xblock"
  - name: "git+https://github.com/appsembler/xblock-launchcontainer.git@v2.1.4#egg=xblock-launchcontainer"
  - name: 'git+https://github.com/MarCnu/pdfXBlock.git#egg=pdf'

EDXAPP_AUTH_EXTRA:
  TIERS_DATABASE_URL: "postgres://amc:@192.168.1.42:5432/amc"

## Stanford theme
edxapp_use_custom_theme: false # false to disable & use std. theme
edxapp_theme_name: ""
edxapp_theme_source_repo: "git@github.com:appsembler/edx-theme-codebase.git"
edxapp_theme_version: "ficus/master" #branch
edxapp_customer_theme_source_repo: "https://github.com/appsembler/edx-theme-customers.git"
edxapp_customer_theme_version: "ficus/amc"

# Comprehensive theme
EDXAPP_COMPREHENSIVE_THEME_DIR: "{{edxapp_theme_dir}}"
EDXAPP_COMPREHENSIVE_THEME_DIRS:
  - "{{ EDXAPP_COMPREHENSIVE_THEME_DIR }}"
# Name of the default site theme
EDXAPP_DEFAULT_SITE_THEME: "edx-theme-codebase"
EDXAPP_ENABLE_COMPREHENSIVE_THEMING: true

# EDX API KEY
EDXAPP_EDX_API_KEY: "test"
EDXAPP_EDXAPP_SECRET_KEY: "secret_key"
