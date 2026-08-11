# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/content-processing/CHANGELOG.md).

## 0.3.0

### Changes

- Removed the redundant Content Understanding AI Services account; Content Understanding now uses the primary AI Services account.
- Granted missing AI Services role assignments to the app and Workflow container app identities.
- Added missing `APP_REDIRECT_URL` and `APP_POST_REDIRECT_URL` app settings to the Web container app.
- Fixed a double-slash bug in `APP_WEB_AUTHORITY` that caused a blank page after sign-in.
- Moved AVM post-deployment documentation into the module (`POST-DEPLOYMENT.md`), making it self-contained.
- Added a missing Workflow container app update module, App Configuration role assignments/keys, and Storage role assignments.
- Added missing `ingressTargetPort=3000` for the Web container app.
- Added outputs `containerWorkflowAppName` and `containerWorkflowAppFqdn`.
- Updated default GPT model from `gpt-4o` (`2024-08-06`) to `gpt-5.1` (`2025-11-13`).

### Breaking Changes

- None

## 0.2.0

### Changes

- Added Cognitive Services account and AI project management modules for AI Foundry
- Enhanced Container Registry with security and networking improvements (private endpoints, network rules, export policy controls)
- Migrated from legacy AI Hub/AI Project to new AI Foundry project model using Cognitive Services projects
- Updated all AVM module references to latest versions (Container App 0.19.0, Cosmos DB 0.18.0, App Configuration 0.9.2, etc.)
- Improved private networking configuration with proper DNS zone integration
- Added Virtual Machine and Bastion Host modules and updated the virtual network and subnet creation logic
- Updated resource naming conventions to use `solutionSuffix` pattern and refactored params based on AVM WAF Standards
- Improved conditional resource provisioning for monitoring and WAF-aligned features

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
