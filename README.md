# Azure VNET Demo

## ⚡ Why separate module + env folders?
* **Module** isolates reusable networking logic.
* **Environment folders** keep per‑environment state, variables, and pipeline “blast radius” small.

## 🌐 Multiple environments: RG vs Subscription
| Option | Pros | Cons | Good when… |
| ------ | ---- | ---- | ---------- |
| **Separate Resource Groups in one subscription** | Fast to create, easy RBAC | Quota & naming clashes | Only a few low‑risk envs (dev/test) |
| **Separate Subscriptions** | Hard isolation, separate budgets, clear RBAC | Needs Azure Landing Zone / Management Group setup | Prod vs non‑prod, regulated workloads |

This repo starts with **one RG** for dev. Promote to subscriptions later without touching the module.

## 🔖 Naming & Tags
Every resource gets these tags:

```hcl
tags = {
  env    = "dev"
  region = "eastus"
  owner  = "team-alpha"
}
