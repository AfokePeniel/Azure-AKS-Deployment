# Azure Kubernetes Service (AKS) Deployment Guide

This guide walks through setting up an Azure Kubernetes Service cluster and deploying a containerized application.

## Prerequisites

### Azure Account Setup
1. Create a free tier account and activate a subscription
   - Visit [Azure Free Account](https://azure.microsoft.com/en-us/free/)

### Required Tools Installation

1. **Azure CLI**
   - Install from [Microsoft's official guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
   - Verify installation:
     ```
     az --version
     ```

2. **Docker**
   - Install from [Docker's official documentation](https://docs.docker.com/engine/install/)
   - Verify installation:
     ```
     docker --version
     ```

3. **Kubectl**
   ```
   sudo az aks install-cli
   
   # Make binaries executable if needed
   sudo chmod +x /usr/local/bin/kubectl
   sudo chmod +x /usr/local/bin/kubelogin
   
   # Verify installation
   kubectl version --client
   ```

## Setup Steps

### 1. Azure Authentication and Resource Group

```
# Login to Azure
az login

# Create resource group
az group create --name <ResourceGroupName> --location <location>

# Verify resource group
az group list --output table
```

### 2. Register Required Services

```
# Register Compute Service
az provider register --namespace Microsoft.Compute
az provider show --namespace Microsoft.Compute --query "registrationState" --output table

# Register Container Service
az provider register --namespace Microsoft.ContainerService
az provider show --namespace Microsoft.ContainerService --query "registrationState" --output table
```

### 3. Create and Configure Azure Container Registry (ACR)

```
# Create ACR
az acr create --resource-group myResourceGroup --name <ACRName> --sku Basic

# Login to ACR
az acr login --name <ACRName>
```

### 4. Create and Configure AKS Cluster

```
# Create AKS cluster
az aks create --resource-group <ResourceGroupName> --name <AKSClusterName> --node-count 2 --enable-addons monitoring --generate-ssh-keys

# Verify cluster creation
az aks list --output table

# Connect to cluster
az aks get-credentials --resource-group <ResourceGroupName> --name <AKSClusterName>

# Attach ACR to cluster
az aks update --name <AKSClusterName> --resource-group <ResourceGroupName> --attach-acr <ACRName>

# Verify nodes
kubectl get nodes
```

### 5. Application Deployment

1. Create application files:
   - app.py
   - deployment.yml
   - service.yml
   - Dockerfile
   - requirements.txt

2. Build and push Docker image:
   ```
   # Build image
   docker build -t myapp:v1 .

   # Tag image
   docker tag myapp:v1 <ACRName>.azurecr.io/myapp:v1

   # Login to ACR
   az acr login --name <ACRName>

   # Push image
   docker push <ACRName>.azurecr.io/myapp:v1

   # Verify image in ACR
   az acr repository list --name <ACRName> --output table
   ```

3. Deploy to Kubernetes:
   ```
   # Create deployment
   kubectl apply -f deployment.yml

   # Create service
   kubectl apply -f service.yml

   # Verify deployment
   kubectl get deployments

   # Check pods
   kubectl get pods

   # Check service
   kubectl get service
   ```

### 6. Configure Network Access

1. Add inbound security rule in Azure Portal:
   - Priority: 500 (or lower than 65000)
   - Name: Allow-HTTP
   - Port: 80
   - Protocol: TCP
   - Source: Any
   - Destination: Any
   - Action: Allow

### 7. Verify Deployment

1. Via Terminal:
   ```
   curl http://<EXTERNAL-IP>
   ```

2. Via Browser:
   - Open `http://<EXTERNAL-IP>`

## Notes
- Replace placeholders (`<ResourceGroupName>`, `<ACRName>`, etc.) with your actual values
- Ensure all services are properly registered before proceeding with next steps
- Monitor resource usage to stay within free tier limits
