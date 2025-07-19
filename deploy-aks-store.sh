#!/bin/bash

echo "🚀 Deploying AKS Store Demo..."

# Create namespace
kubectl create namespace aks-store-demo --dry-run=client -o yaml | kubectl apply -f -

# Deploy the application
kubectl apply -f manifests/aks-store-quickstart.yaml -n aks-store-demo

echo "⏳ Waiting for deployments to be ready..."

# Wait for deployments
kubectl wait --for=condition=available --timeout=300s deployment/store-front -n aks-store-demo
kubectl wait --for=condition=available --timeout=300s deployment/product-service -n aks-store-demo
kubectl wait --for=condition=available --timeout=300s deployment/order-service -n aks-store-demo
kubectl wait --for=condition=available --timeout=300s statefulset/rabbitmq -n aks-store-demo

echo "✅ Deployments ready!"

# Get service information
echo ""
echo "📊 Deployment Status:"
kubectl get deployments -n aks-store-demo

echo ""
echo "🔗 Services:"
kubectl get services -n aks-store-demo

echo ""
echo "📦 Pods:"
kubectl get pods -n aks-store-demo

echo ""
echo "🌐 Store Front Service URL:"
kubectl get service store-front -n aks-store-demo -o wide 