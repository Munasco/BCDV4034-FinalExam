#!/bin/bash

echo "🔒 Deploying AKS Store Demo with SecurityContext..."

# Delete existing deployment
kubectl delete -f manifests/aks-store-quickstart.yaml -n aks-store-demo --ignore-not-found=true

# Wait for cleanup
echo "⏳ Waiting for cleanup..."
sleep 10

# Deploy the secure version
kubectl apply -f manifests/aks-store-quickstart-secure.yaml -n aks-store-demo

echo "⏳ Waiting for deployments to be ready..."

# Wait for deployments
kubectl wait --for=condition=available --timeout=300s deployment/store-front -n aks-store-demo
kubectl wait --for=condition=available --timeout=300s deployment/product-service -n aks-store-demo
kubectl wait --for=condition=available --timeout=300s deployment/order-service -n aks-store-demo
kubectl wait --for=condition=available --timeout=300s statefulset/rabbitmq -n aks-store-demo

echo "✅ Secure deployments ready!"

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
echo "🔒 SecurityContext Verification:"
kubectl describe pod -l app=store-front -n aks-store-demo | grep -A 10 "Security Context"

echo ""
echo "🌐 Store Front Service URL:"
kubectl get service store-front -n aks-store-demo -o wide 