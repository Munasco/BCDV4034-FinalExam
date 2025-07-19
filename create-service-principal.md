# Create Service Principal for GitHub Actions

## Step 1: Create App Registration

1. Go to **Azure Portal** → **Azure Active Directory**
2. Click **"App registrations"** → **"New registration"**
3. Name: `github-actions-aks`
4. Click **"Register"**
5. **Copy the Application (client) ID** - this is your `AZURE_CLIENT_ID`

## Step 2: Create Client Secret

1. In the app registration → **"Certificates & secrets"**
2. Click **"New client secret"**
3. Description: `github-actions`
4. Click **"Add"**
5. **Copy the secret value** - this is your `AZURE_CLIENT_SECRET`

## Step 3: Assign Role

1. Go to **Resource Group**: `rg-aks-5q074gff`
2. Click **"Access control (IAM)"**
3. Click **"Add"** → **"Add role assignment"**
4. Role: **"Contributor"**
5. Members: Search for `github-actions-aks`
6. Click **"Save"**

## Step 4: Add GitHub Secrets

Add these secrets to your GitHub repository:

- **`AZURE_CLIENT_ID`**: Your app registration client ID
- **`AZURE_CLIENT_SECRET`**: Your client secret
- **`AZURE_TENANT_ID`**: `b5dc206c-17fd-4b06-8bc8-24f0bb650229`
- **`AZURE_SUBSCRIPTION_ID`**: `69a0ceb2-4ba6-4cd4-bbf7-a35a58b1be1e`

## Values You Need:

- **Tenant ID**: `b5dc206c-17fd-4b06-8bc8-24f0bb650229`
- **Subscription ID**: `69a0ceb2-4ba6-4cd4-bbf7-a35a58b1be1e`
- **Client ID**: Get from app registration
- **Client Secret**: Get from app registration secrets
