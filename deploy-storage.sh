#!/bin/bash

# Deploy Azure Storage Account and Blob Container
echo "Deploying Azure Storage Account and Blob Container..."
terraform apply -auto-approve

# Get storage account details
STORAGE_ACCOUNT_NAME=$(terraform output -raw storage_account_name)
STORAGE_ACCOUNT_KEY=$(terraform output -raw storage_account_key)

echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Storage Key: $STORAGE_ACCOUNT_KEY"

# Update Kubernetes YAML files with actual storage account details
echo "Updating Kubernetes YAML files with storage account details..."

# Update storage class
sed -i '' "s/staks5q074gff/$STORAGE_ACCOUNT_NAME/g" k8s-storage-class.yaml

# Update storage secret
sed -i '' "s/staks5q074gff/$STORAGE_ACCOUNT_NAME/g" k8s-storage-secret.yaml
sed -i '' "s/your-storage-account-key-here/$STORAGE_ACCOUNT_KEY/g" k8s-storage-secret.yaml

# Apply Kubernetes resources
echo "Applying Kubernetes storage resources..."

# Create storage class
kubectl apply -f k8s-storage-class.yaml

# Create storage secret
kubectl apply -f k8s-storage-secret.yaml

# Create persistent volume
kubectl apply -f k8s-persistent-volume.yaml

# Create persistent volume claim
kubectl apply -f k8s-persistent-volume-claim.yaml

# Wait for PVC to be bound
echo "Waiting for PVC to be bound..."
kubectl wait --for=condition=Bound pvc/aks-blob-pvc --timeout=60s

# Deploy application with persistent storage
echo "Deploying application with persistent storage..."
kubectl apply -f store-front-with-storage.yaml

# Wait for deployment to be ready
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/store-front-with-storage

echo "Deployment complete!"
echo "Check the following resources:"
echo "- kubectl get pv"
echo "- kubectl get pvc"
echo "- kubectl get pods"
echo "- kubectl get services" 