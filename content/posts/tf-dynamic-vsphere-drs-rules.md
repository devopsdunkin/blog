---
title: "terraform - dynamically created vSphere anti-affinity rules"
date: 2019-12-08T21:10:42-06:00
draft: true
tags: ["terraform","vmware","vsphere","drs"]
---

As we've continued to mature our Terraform modules, we have been working to give our operations team more flexbility in how they are consumed. We wanted to make sure if more than one server was being deployed from a single configuration, that vSphere DRS anti-affinity rules would be created for them. I know I've been guilty of forgetting to create anti-affinity rules before, so now, Terraform does this for us. If we pass in more than one IP address through the `ip_addresses` list variable, then the ternary should return 1, which tells Terraform to create the resource. Otherwise, it should return 0 and no rules will be created.

```hcl
resource "vsphere_virtual_machine" "web-servers" {
    ...
    <server config>
    ip_addresses    = [
        "192.168.1.2",
        "192.168.1.3"
    ]
    ...
}

resource "vsphere_compute_cluster_vm_anti_affinity_rule" "web_server_farm_anti_affinity_rule" {
    count = length(var.ip_addresses) > 1 ? 1 : 0

    name                = "web-server-farm-anti-affinity-rule"
    compute_cluster_id  = "${data.vsphere_compute_cluster.cluster.id}"
    virtual_machine_ids = "${vsphere_virtual_machine.web-servers.*.id}"
}

output "anti-affinity-rule-name" {
    value = "${vsphere_compute_cluster_vm_anti_affinity_rule.cluster_vm_anti_affinity_rule.*.name}"
}
```

We included this in our module repository, so the consumer doesn't even need to know about it. All they need to do is provide the IP addresses, and the module will take care of the rest!
