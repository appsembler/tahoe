# Third Party Auth Admin API Docs

This API allows external systems (like AMC) to manage the SAML configuration in the Open edX platform. At the moment we've two groups of endpoints in this API, one to control the edX configuration as a SAML Service Provider, and another to control the configuration of the associated SAML Identity Providers.

## Django configuration models
The SAML (and OAuth TBD in the near future) configuration are implemented in an edX application called `third_party_auth` located in `/common/djangoapps/third_party_auth`. The models associated to our API are based in the **Django configuration models**.

Documentation: https://github.com/edx/django-config-models

Django configuration models provide a base class to inherit from, so we can take the config model behaviour in our models. Basically after inheriting from the class you write a normal Django class, then every time you edit an object a new record is created, so you can store and history and you can revert to that configuration. When you define a class inheriting from configuration fields you need to define a `KEY_FIELDS` attribute, this is what it makes you configuration unique. **Django configuration models** Also provides an object manager `current_set()` that is based on the `KEY_FIELDS` will return the last version of each configuration.

All the classes that we're going to be interacting with the API are based configuration models, so the API only allows to list all objects, list current, post and delete, we don't methods available to update, since a new one is always going to be created.

## SAML configuration Endpoints
This set of endpoint allows managing the edX configuration as a SAML Service Provider.

More info: https://en.wikipedia.org/wiki/Service_provider_(SAML)

### SAML Configuration List and Create

* URL: `/appsembler/api/saml-configurations/`
* Methods: `GET` | `POST`
* Data Params:
  * Required:
    * site=[integer]
    * entity_id=[string]
  * Optional:
    * enabled=[boolean] Default=False
    * private_key=[string]
    * public_key=[string]
    * org_info_str=[string] JSON Formatted
    * other_config_str=[string] JSON Formatted
* Success Response:
  * Code 200 (`HTTP_200_OK`)
    Content:
    ```
    {
      "count": 2,
      "num_pages": 1,
      "current_page": 1,
      "results": [
          {
              "id": 5,
              "site": 5,
              "enabled": false,
              "entity_id": "http://saml.example.com",
              "private_key": "MIICXAIBAAKBgQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+D\r\nwWTOd+64OdwSrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe\r\n6e/ZQfT5649RC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQAB\r\nAoGAfNrwNFBVJEtCXf0kfbDjD01LQoAsnRrN1j8F+qnAAiYmBGGx1/tkFROBNEas\r\nR+/Ue0BzOu/DOIr86lN7Yw20+sG1420NjUezjhabXXRkvj5EdVh9lGfjBF4sbjjD\r\nrVOswvjVX6E/lgmR3qAeNeouLlZTgmpeW6Vx03JuepE0fjkCQQDZx+dksm3q6Tx4\r\nm25pmjmiEypIuBSbWUh7XmbRRxqAYlO+k8vg6x9sZLAVz/KYLufHfPLv5RxPc1kN\r\nGnLuM6d9AkEAwE6uTlYmg0JZh8wvmj1ddKJtcwkLolIaNdRYSamOiWBOYQ+DqO3e\r\nMEBzKv9blXiPT/cbxPxV/MExhT3RQaWtcwJBALiY4MOTFuaa4r4cid+LcbS26A2R\r\nsy3m5TBlWWOlEIqoTfHpl1REGHOpeTRT+n8SqzaF6+p6Wp/h1ybrN2Y/dIUCQBVL\r\nYR/JiGA2g6V25bqFmwikR8xaLxCdWMunJNObU+5AXM2Ao0qcdGMRb+9N8X0+qVfo\r\nfAm3C2p+lhYz/yzuxKMCQGrT8smCoWJgeERF+Fn51HXp3QkZvxiWpNpDQLHRXGci\r\nBMyPnEmma1sMJ+t+j0NRfOiq/5k0gYeY1gXj52P/DYw=",
              "public_key": "MIICsDCCAhmgAwIBAgIJAL14w2W/eMM0MA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV\r\nBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX\r\naWRnaXRzIFB0eSBMdGQwHhcNMTYxMDI4MTQzMDA3WhcNMjYxMDI4MTQzMDA3WjBF\r\nMQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50\r\nZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB\r\ngQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+DwWTOd+64OdwS\r\nrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe6e/ZQfT5649R\r\nC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQABo4GnMIGkMB0G\r\nA1UdDgQWBBRQC2o5HBYFPVYMs3IZ+hSh/r3EuDB1BgNVHSMEbjBsgBRQC2o5HBYF\r\nPVYMs3IZ+hSh/r3EuKFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUt\r\nU3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAL14w2W/\r\neMM0MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEAnO5s2BMisss3x9Fk\r\nr2oZHgxYKgOCj11fejYGAj1L0nGd2j8cJWBhOuwnE0IG/nxzr/8RKPl6iozdMRPv\r\nW6KIOn+SPINOr600GQs6TrLS2NBA4rHvCesV+0P5jxuz4lRUXbHUV3CiRH9ncyFc\r\npB42II8X/KJbNFeS/pVmyPUjXOo=",
              "org_info_str": "{\"en-US\": {\"url\": \"http://www.example.com\", \"displayname\": \"Example Inc.\", \"name\": \"example\"}}",
              "other_config_str": "{\n\"SECURITY_CONFIG\": {\"metadataCacheDuration\": 604800, \"signMetadata\": false}\n}"
          },
          {
              "id": 12,
              "site": 1,
              "enabled": false,
              "entity_id": "http://saml2.example.com",
              "private_key": "MIICXAIBAAKBgQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+D\r\nwWTOd+64OdwSrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe\r\n6e/ZQfT5649RC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQAB\r\nAoGAfNrwNFBVJEtCXf0kfbDjD01LQoAsnRrN1j8F+qnAAiYmBGGx1/tkFROBNEas\r\nR+/Ue0BzOu/DOIr86lN7Yw20+sG1420NjUezjhabXXRkvj5EdVh9lGfjBF4sbjjD\r\nrVOswvjVX6E/lgmR3qAeNeouLlZTgmpeW6Vx03JuepE0fjkCQQDZx+dksm3q6Tx4\r\nm25pmjmiEypIuBSbWUh7XmbRRxqAYlO+k8vg6x9sZLAVz/KYLufHfPLv5RxPc1kN\r\nGnLuM6d9AkEAwE6uTlYmg0JZh8wvmj1ddKJtcwkLolIaNdRYSamOiWBOYQ+DqO3e\r\nMEBzKv9blXiPT/cbxPxV/MExhT3RQaWtcwJBALiY4MOTFuaa4r4cid+LcbS26A2R\r\nsy3m5TBlWWOlEIqoTfHpl1REGHOpeTRT+n8SqzaF6+p6Wp/h1ybrN2Y/dIUCQBVL\r\nYR/JiGA2g6V25bqFmwikR8xaLxCdWMunJNObU+5AXM2Ao0qcdGMRb+9N8X0+qVfo\r\nfAm3C2p+lhYz/yzuxKMCQGrT8smCoWJgeERF+Fn51HXp3QkZvxiWpNpDQLHRXGci\r\nBMyPnEmma1sMJ+t+j0NRfOiq/5k0gYeY1gXj52P/DYw=",
              "public_key": "MIICsDCCAhmgAwIBAgIJAL14w2W/eMM0MA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV\r\nBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX\r\naWRnaXRzIFB0eSBMdGQwHhcNMTYxMDI4MTQzMDA3WhcNMjYxMDI4MTQzMDA3WjBF\r\nMQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50\r\nZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB\r\ngQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+DwWTOd+64OdwS\r\nrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe6e/ZQfT5649R\r\nC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQABo4GnMIGkMB0G\r\nA1UdDgQWBBRQC2o5HBYFPVYMs3IZ+hSh/r3EuDB1BgNVHSMEbjBsgBRQC2o5HBYF\r\nPVYMs3IZ+hSh/r3EuKFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUt\r\nU3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAL14w2W/\r\neMM0MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEAnO5s2BMisss3x9Fk\r\nr2oZHgxYKgOCj11fejYGAj1L0nGd2j8cJWBhOuwnE0IG/nxzr/8RKPl6iozdMRPv\r\nW6KIOn+SPINOr600GQs6TrLS2NBA4rHvCesV+0P5jxuz4lRUXbHUV3CiRH9ncyFc\r\npB42II8X/KJbNFeS/pVmyPUjXOo=",
              "org_info_str": "{\"en-US\": {\"url\": \"http://www.example.com\", \"displayname\": \"Example Inc.\", \"name\": \"example\"}}",
              "other_config_str": "{\n\"SECURITY_CONFIG\": {\"metadataCacheDuration\": 604800, \"signMetadata\": false}\n}"
          }
      ],
      "next": null,
      "start": 0,
      "previous": null
    }
    ```
  * Code 201 (`HTTP_201_CREATED`)
    Content:
    ```
    {
      "id": 5,
      "site": 5,
      "enabled": true,
      "entity_id": "http://saml.example.com",
      "private_key": "MIICXAIBAAKBgQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+D\r\nwWTOd+64OdwSrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe\r\n6e/ZQfT5649RC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQAB\r\nAoGAfNrwNFBVJEtCXf0kfbDjD01LQoAsnRrN1j8F+qnAAiYmBGGx1/tkFROBNEas\r\nR+/Ue0BzOu/DOIr86lN7Yw20+sG1420NjUezjhabXXRkvj5EdVh9lGfjBF4sbjjD\r\nrVOswvjVX6E/lgmR3qAeNeouLlZTgmpeW6Vx03JuepE0fjkCQQDZx+dksm3q6Tx4\r\nm25pmjmiEypIuBSbWUh7XmbRRxqAYlO+k8vg6x9sZLAVz/KYLufHfPLv5RxPc1kN\r\nGnLuM6d9AkEAwE6uTlYmg0JZh8wvmj1ddKJtcwkLolIaNdRYSamOiWBOYQ+DqO3e\r\nMEBzKv9blXiPT/cbxPxV/MExhT3RQaWtcwJBALiY4MOTFuaa4r4cid+LcbS26A2R\r\nsy3m5TBlWWOlEIqoTfHpl1REGHOpeTRT+n8SqzaF6+p6Wp/h1ybrN2Y/dIUCQBVL\r\nYR/JiGA2g6V25bqFmwikR8xaLxCdWMunJNObU+5AXM2Ao0qcdGMRb+9N8X0+qVfo\r\nfAm3C2p+lhYz/yzuxKMCQGrT8smCoWJgeERF+Fn51HXp3QkZvxiWpNpDQLHRXGci\r\nBMyPnEmma1sMJ+t+j0NRfOiq/5k0gYeY1gXj52P/DYw=",
      "public_key": "MIICsDCCAhmgAwIBAgIJAL14w2W/eMM0MA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV\r\nBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX\r\naWRnaXRzIFB0eSBMdGQwHhcNMTYxMDI4MTQzMDA3WhcNMjYxMDI4MTQzMDA3WjBF\r\nMQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50\r\nZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB\r\ngQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+DwWTOd+64OdwS\r\nrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe6e/ZQfT5649R\r\nC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQABo4GnMIGkMB0G\r\nA1UdDgQWBBRQC2o5HBYFPVYMs3IZ+hSh/r3EuDB1BgNVHSMEbjBsgBRQC2o5HBYF\r\nPVYMs3IZ+hSh/r3EuKFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUt\r\nU3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAL14w2W/\r\neMM0MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEAnO5s2BMisss3x9Fk\r\nr2oZHgxYKgOCj11fejYGAj1L0nGd2j8cJWBhOuwnE0IG/nxzr/8RKPl6iozdMRPv\r\nW6KIOn+SPINOr600GQs6TrLS2NBA4rHvCesV+0P5jxuz4lRUXbHUV3CiRH9ncyFc\r\npB42II8X/KJbNFeS/pVmyPUjXOo=",
      "org_info_str": "{\n    \"en-US\": {\n        \"url\": \"http://www.example.com\", \n        \"displayname\": \"Example Inc.\", \n        \"name\": \"example\"\n    }\n}",
      "other_config_str": "{\n    \"SECURITY_CONFIG\": {\n        \"signMetadata\": false, \n        \"metadataCacheDuration\": 604800\n    }\n}"
    }
    ```
* Error Response:
  * Code: 403 (`HTTP_403_FORBIDDEN`)

### SAML Configuration Retrieve and Delete

* URL: `/appsembler/api/saml-configurations/<pk>/`
* Methods: `GET` | `DELETE`
* Success Response:
  * Code 200 (`HTTP_200_OK`)
    Content:
    ```
    {
      "id": 5,
      "site": 5,
      "enabled": true,
      "entity_id": "http://saml.example.com",
      "private_key": "MIICXAIBAAKBgQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+D\r\nwWTOd+64OdwSrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe\r\n6e/ZQfT5649RC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQAB\r\nAoGAfNrwNFBVJEtCXf0kfbDjD01LQoAsnRrN1j8F+qnAAiYmBGGx1/tkFROBNEas\r\nR+/Ue0BzOu/DOIr86lN7Yw20+sG1420NjUezjhabXXRkvj5EdVh9lGfjBF4sbjjD\r\nrVOswvjVX6E/lgmR3qAeNeouLlZTgmpeW6Vx03JuepE0fjkCQQDZx+dksm3q6Tx4\r\nm25pmjmiEypIuBSbWUh7XmbRRxqAYlO+k8vg6x9sZLAVz/KYLufHfPLv5RxPc1kN\r\nGnLuM6d9AkEAwE6uTlYmg0JZh8wvmj1ddKJtcwkLolIaNdRYSamOiWBOYQ+DqO3e\r\nMEBzKv9blXiPT/cbxPxV/MExhT3RQaWtcwJBALiY4MOTFuaa4r4cid+LcbS26A2R\r\nsy3m5TBlWWOlEIqoTfHpl1REGHOpeTRT+n8SqzaF6+p6Wp/h1ybrN2Y/dIUCQBVL\r\nYR/JiGA2g6V25bqFmwikR8xaLxCdWMunJNObU+5AXM2Ao0qcdGMRb+9N8X0+qVfo\r\nfAm3C2p+lhYz/yzuxKMCQGrT8smCoWJgeERF+Fn51HXp3QkZvxiWpNpDQLHRXGci\r\nBMyPnEmma1sMJ+t+j0NRfOiq/5k0gYeY1gXj52P/DYw=",
      "public_key": "MIICsDCCAhmgAwIBAgIJAL14w2W/eMM0MA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV\r\nBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX\r\naWRnaXRzIFB0eSBMdGQwHhcNMTYxMDI4MTQzMDA3WhcNMjYxMDI4MTQzMDA3WjBF\r\nMQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50\r\nZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB\r\ngQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+DwWTOd+64OdwS\r\nrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe6e/ZQfT5649R\r\nC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQABo4GnMIGkMB0G\r\nA1UdDgQWBBRQC2o5HBYFPVYMs3IZ+hSh/r3EuDB1BgNVHSMEbjBsgBRQC2o5HBYF\r\nPVYMs3IZ+hSh/r3EuKFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUt\r\nU3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAL14w2W/\r\neMM0MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEAnO5s2BMisss3x9Fk\r\nr2oZHgxYKgOCj11fejYGAj1L0nGd2j8cJWBhOuwnE0IG/nxzr/8RKPl6iozdMRPv\r\nW6KIOn+SPINOr600GQs6TrLS2NBA4rHvCesV+0P5jxuz4lRUXbHUV3CiRH9ncyFc\r\npB42II8X/KJbNFeS/pVmyPUjXOo=",
      "org_info_str": "{\n    \"en-US\": {\n        \"url\": \"http://www.example.com\", \n        \"displayname\": \"Example Inc.\", \n        \"name\": \"example\"\n    }\n}",
      "other_config_str": "{\n    \"SECURITY_CONFIG\": {\n        \"signMetadata\": false, \n        \"metadataCacheDuration\": 604800\n    }\n}"
    }
    ```
  * Code 204 (`HTTP_204_NO_CONTENT`)
  * Code 403 (`HTTP_403_FORBIDDEN`)

### SAML Configuration for specific site

* URL: `/appsembler/api/site-saml-configuration/<site_id>/`
* Methods: `GET`
* Success Response:
  * Code: 200 (`HTTP_200_OK`)
    Content:
    ```
    {
      "id": 5,
      "site": 5,
      "enabled": true,
      "entity_id": "http://saml.example.com",
      "private_key": "MIICXAIBAAKBgQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+D\r\nwWTOd+64OdwSrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe\r\n6e/ZQfT5649RC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQAB\r\nAoGAfNrwNFBVJEtCXf0kfbDjD01LQoAsnRrN1j8F+qnAAiYmBGGx1/tkFROBNEas\r\nR+/Ue0BzOu/DOIr86lN7Yw20+sG1420NjUezjhabXXRkvj5EdVh9lGfjBF4sbjjD\r\nrVOswvjVX6E/lgmR3qAeNeouLlZTgmpeW6Vx03JuepE0fjkCQQDZx+dksm3q6Tx4\r\nm25pmjmiEypIuBSbWUh7XmbRRxqAYlO+k8vg6x9sZLAVz/KYLufHfPLv5RxPc1kN\r\nGnLuM6d9AkEAwE6uTlYmg0JZh8wvmj1ddKJtcwkLolIaNdRYSamOiWBOYQ+DqO3e\r\nMEBzKv9blXiPT/cbxPxV/MExhT3RQaWtcwJBALiY4MOTFuaa4r4cid+LcbS26A2R\r\nsy3m5TBlWWOlEIqoTfHpl1REGHOpeTRT+n8SqzaF6+p6Wp/h1ybrN2Y/dIUCQBVL\r\nYR/JiGA2g6V25bqFmwikR8xaLxCdWMunJNObU+5AXM2Ao0qcdGMRb+9N8X0+qVfo\r\nfAm3C2p+lhYz/yzuxKMCQGrT8smCoWJgeERF+Fn51HXp3QkZvxiWpNpDQLHRXGci\r\nBMyPnEmma1sMJ+t+j0NRfOiq/5k0gYeY1gXj52P/DYw=",
      "public_key": "MIICsDCCAhmgAwIBAgIJAL14w2W/eMM0MA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV\r\nBAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX\r\naWRnaXRzIFB0eSBMdGQwHhcNMTYxMDI4MTQzMDA3WhcNMjYxMDI4MTQzMDA3WjBF\r\nMQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50\r\nZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB\r\ngQCjmNy8ifmqs32SmYzdKCV3dPXRmE9Mcs6w4Zf0VDgi9WFl6H+DwWTOd+64OdwS\r\nrAbfzkif/dyC9PUHLtXyLRJTro3oTsmDqgr2CUwoeRJgbP3PMyHe6e/ZQfT5649R\r\nC/toiTV8RnYzEVs0mADtVSb6o3uoIDL8TODOVrd4mfS2JwIDAQABo4GnMIGkMB0G\r\nA1UdDgQWBBRQC2o5HBYFPVYMs3IZ+hSh/r3EuDB1BgNVHSMEbjBsgBRQC2o5HBYF\r\nPVYMs3IZ+hSh/r3EuKFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUt\r\nU3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAL14w2W/\r\neMM0MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEAnO5s2BMisss3x9Fk\r\nr2oZHgxYKgOCj11fejYGAj1L0nGd2j8cJWBhOuwnE0IG/nxzr/8RKPl6iozdMRPv\r\nW6KIOn+SPINOr600GQs6TrLS2NBA4rHvCesV+0P5jxuz4lRUXbHUV3CiRH9ncyFc\r\npB42II8X/KJbNFeS/pVmyPUjXOo=",
      "org_info_str": "{\n    \"en-US\": {\n        \"url\": \"http://www.example.com\", \n        \"displayname\": \"Example Inc.\", \n        \"name\": \"example\"\n    }\n}",
      "other_config_str": "{\n    \"SECURITY_CONFIG\": {\n        \"signMetadata\": false, \n        \"metadataCacheDuration\": 604800\n    }\n}"
    }
    ```
* Error Response:
  * Code 404 (`HTTP_404_NOT_FOUND`)
  * Code 403 (`HTTP_403_FORBIDDEN`)
