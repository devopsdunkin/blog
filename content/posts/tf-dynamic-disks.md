---
title: "Terraform - Dynamic Disks"
date: 2020-01-06T21:20:25-06:00
draft: false
tags: ["terraform","storage"]
---

With the release of Terraform 0.12, one of the great, new features is dynamic blocks. I have been working on a Terraform module for our operations team to consume to build servers via a CI/CD pipeline and needed to allow them to provision an arbitary number of disks to each deployment.

Below, we define the dynamic block within the module itself. We pass in a variable, called `disks_to_provision`, which is a list of maps. We loop through and dynamically create each disk with a unique label.

```hcl
dynamic "disk" {
    for.each = [ for disk in var.disks_to_provision: {
      size = disk.size
      unit_number = disk.unit_number
    }]
    content {
      label = "${var.vm_name}${count.index}-${disk.value.unit_number}-disk"
      size = "${disk.value.size}"
      unit_number = "${disk.value.unit_number}"
    }
  }
```

Putting this together in a module, we can abstract a lot of this and make it easier to consume. Below, we are defining our `disks_to_provision` variable. Now all the consumer needs to worry about is the size of the disk. You could even abstract away needing to provide a `unit_number`. We decided to keep that as an input due to some VMware best practices for storage, but this would definitely vary depending upon the Terraform provider being used.

```hcl
disks_to_provision = [
    {
        size = 100,
        unit_number = 0
    },
    {
        size = 250,
        unit_number = 1
    }
]
```

Terraform 0.12 has been out for a while, so making the jump is not much of a big deal, and definitely worth it for this feature alone. It's made my job a lot easier!
