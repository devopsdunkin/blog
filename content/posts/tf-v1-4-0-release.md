---
title: "Terraform provider for Nagios XI - version 1.4.0"
date: 2020-01-20T08:22:55-06:00
draft: false
tags: ['terraform', 'golang', 'nagios']
---

Version 1.4.0 of the provider for Nagios XI has been released! There's plenty of improvements and bug fixes, but more notably, I added a new resource and several data sources.

The new resource, `nagios_authserver` now allows to create and destroy Nagios authentication servers. These allow you to provide Active Directory or LDAP integration for Nagios users. One important note on this resource, is that the Nagios API currently does not allow for updates to be executed against auth servers, so any changes to the resource would require Terraform to destroy and create the auth server again. Below is an example of using `resource_authserver` to create an Active Directory authentication server in Nagios:

```hcl
resource "nagios_authserver" "authserver1" {
    enabled                 = true
    connection_method       = "ad"
    ad_account_suffix       = "@domain.local"
    ad_domain_controllers   = "dc1.domain.local"
    base_dn                 = "OU=IT, DC=domain, DC=local"
    security_level          = "ssl"
}
```

For data sources, we have three:

* `data_source_host`
* `data_source_hostgroup`
* `data_source_service`

Each of these allow you to pull existing objects into state to be used with other resources or data sources. For example, if you had a host group created with `nagios_hostgroup`, you could pull in existing hosts to be added as members of the hostgroup, as shown in the example below.

```hcl
data "nagios_host" "existinghost1" {
    host_name = "existinghost1"
}

resource "nagios_hostgroup" "windows-servers" {
    name    = "windows-servers"
    alias   = "Windows Servers"
    members = [
        "${data.nagios_host.existinghost1.host_name}"
    ]
}
```

