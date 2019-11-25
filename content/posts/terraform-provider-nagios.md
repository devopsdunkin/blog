---
title: "terraform provider nagios"
date: 2019-11-22T07:20:17-06:00
draft: false
tags: ["terraform","golang","nagios"]
---

For the past several months, I have spent several evenings learning how to write Go and how to create a Terraform provider. It's been quite a fun experience and it's exciting to see that work starting to pay off. As of October 31, [version 1.0.0](https://github.com/devopsdunkin/terraform-provider-nagios/tree/master) has been released! This version allows you to manage hosts, host groups, services and service groups within Nagios XI. The plan is to release several updates over the coming weeks that will add other resources and eventually data sources into the fold.

I'm a bit late writing this post so I have actually had the chance to release a couple more versions that allow you to manage contacts and contact groups as well. If you use Nagios, give it a try and let me know how it works for you. I would love feedback! Stay tuned for more updates on this as well as other stuff I'm working on.