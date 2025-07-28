- **Why use Resource Groups or Subscriptions for multiple environments?**  
  - Resource Groups keep all environment resources together, making cleanup and permission management easier.  
  - Subscriptions are useful when you need strong isolation (like dev vs prod), separate billing, and stricter access control.  
  - For small teams/projects or non-critical environments, using one subscription with multiple resource groups is simpler and more adequate.  
  - For critical production workloads or multiple teams, separate subscriptions ensure no accidental cross-environment impact.

- **Include a virtual machine and one other resource for a dev setup**  
  - A small Linux virtual machine (Standard_B1s) for testing and development.  
  - A Key Vault to securely store secrets such as database passwords or API keys used in dev.  

- **Name and label resources to make environment and region clear**  
  - used naming patterns like `vm-dev-westeu`, `kv-dev-westeu`, and `rg-dev-westeu`.  

- **How to label resources for better tracking and enforce it**  
  - Always apply tags like `env = dev`, `region = westeurope`, `owner = team-alpha`.  
  - you can also force tagging using Azure Policies, which can block or warn when resources are created without required tags.  

- **What outputs might be useful and why**  
  - `vm_public_ip` – allows developers to quickly connect to their test VM.  
  - `key_vault_uri` – provides the endpoint for storing or retrieving secrets.  
  - `vnet_id` and `subnet_id` – useful for integrating additional services (like AKS or Application Gateway) later.  

- **GitHub pipeline and release lifecycle**  
  - The pipeline runs on each push to `main` and can also be triggered manually for specific environments.  
  - Steps:
    1. **Checkout code** – fetches the latest configuration.  
    2. **Terraform Init** – initializes Terraform and connects to the remote backend.  
    3. **Terraform Plan** – shows what changes will happen and saves the plan.  
    4. **Terraform Apply** – applies changes automatically for the `main` branch.  
    5. **Generate documentation** – uses terraform-docs to update module documentation automatically.  
    6. **Commit documentation updates** – commits updated README files back to the repo to keep documentation in sync.  
  - This release lifecycle ensures infrastructure changes are tested, applied consistently, and documented automatically.
