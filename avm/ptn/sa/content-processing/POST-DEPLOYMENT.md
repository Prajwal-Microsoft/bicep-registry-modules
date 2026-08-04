# Content Processing Solution Accelerator — AVM Post-Deployment Guide

This guide covers the steps required **after** deploying this module, before the application is usable. The AVM module provisions infrastructure only — it does not build/push container images or register document schemas, so a few manual steps are required.

## Overview

After successfully deploying this module, complete the following **in order**:

1. **Build and push container images** — the module provisions the Azure Container Registry (ACR) and Container Apps, but does not build/push application images. Run `acr_build_push` so the container apps pick up the real images.
2. **Run the post-deployment script** — registers schemas, creates the schema set, and self-heals a handful of known AVM configuration gaps (see [Notes on pre-flight checks](#notes-on-pre-flight-checks) below).
3. **Configure authentication** — set up app registration for secure access.

## Prerequisites

1. **[Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)** <small>(v2.50+)</small> — Command-line tool for managing Azure resources
2. **PowerShell** <small>(Windows PowerShell or [PowerShell 7+/pwsh](https://learn.microsoft.com/powershell/scripting/install/installing-powershell), cross-platform)</small> — Required to run the scripts below
3. **[Git](https://git-scm.com/downloads/)** — Used to clone the [Content Processing Solution Accelerator](https://github.com/microsoft/content-processing-solution-accelerator) repository, which contains the scripts referenced below
4. **Deployed Infrastructure** — A successful deployment of this AVM module

## Post-Deployment Steps

### Step 1: Clone the accelerator repository

The build/push and post-deployment scripts live in the accelerator repository, not this one:

```bash
git clone https://github.com/microsoft/content-processing-solution-accelerator.git
cd content-processing-solution-accelerator
```

### Step 2: Build and push container images

Run this from the accelerator repository root, passing the resource group you deployed this module into (for example `pgcp1`):

```powershell
.\infra\scripts\acr_build_push.ps1 "<your-resource-group-name>"
```

This builds all four container images (`web`, `api`, `app`, `wkfl`) via ACR Tasks and updates each container app to use the freshly built image. This step typically takes several minutes.

### Step 3: Register schemas and create the schema set

Run the post-deployment script, passing the same resource group and the API app's FQDN from the deployment outputs (exposed as this module's `containerApiAppFqdn` output):

```powershell
.\infra\scripts\post_deployment.ps1 -ResourceGroupName "<your-resource-group-name>" -ApiBaseUrl "https://<containerApiAppFqdn>"
```

`-ApiBaseUrl` is optional — the script auto-discovers the API app's FQDN from the resource group if omitted.

The script performs three steps automatically:
1. Registers individual schema files (auto claim, damaged car image, police report, repair estimate) via `/schemavault/`
2. Creates an **"Auto Claim"** schema set via `/schemasetvault/`
3. Adds all registered schemas into the schema set

It is idempotent — it skips schemas and schema sets that already exist, so it's safe to re-run.

#### Notes on pre-flight checks

Before registering schemas, the script also runs a handful of self-healing pre-flight checks (only active when `-ResourceGroupName` is supplied), which detect and automatically correct known AVM template gaps: storage account and Cosmos DB `publicNetworkAccess` being left `Disabled` on non-WAF deployments, the web container app's ingress port, and API authentication blocking anonymous schema registration calls. These are safe no-ops if your deployment doesn't have the issue.

### Step 4: Configure authentication (required)

**This step is mandatory for application access.** Follow the accelerator's [App Authentication Configuration guide](https://github.com/microsoft/content-processing-solution-accelerator/blob/main/docs/ConfigureAppAuthentication.md), then wait up to 10 minutes for authentication changes to take effect.

### Step 5: Verify deployment

1. Access your application using the web app URL from your deployment output.
2. Confirm the application loads successfully.
3. Verify you can sign in with your authenticated account.

## Need Help?

- Check the accelerator's [Troubleshooting Guide](https://github.com/microsoft/content-processing-solution-accelerator/blob/main/docs/TroubleShootingSteps.md)
