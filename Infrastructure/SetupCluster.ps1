Param(
  [string]$subscriptionname,
  [string]$email,
  [string]$ressourcegroup = "AKSDevFunDemo",
  [string]$clustername = "AKSDevFunDemo",
  [string]$containerregistry = "akscontainerregistrydemo"
)

### setup the cli settings
kubectl config unset contexts.AKSDevFunDemo
az account set --subscription $subscriptionname
az account show
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
az provider register -n Microsoft.ContainerService

### setup kubernetes cluster
az group create -n "$ressourcegroup" -l "westeurope"
az aks create --resource-group $ressourcegroup --name $clustername --node-vm-size Standard_DS1_v2 --node-count 1 --generate-ssh-keys
az aks get-credentials --resource-group $ressourcegroup --name $clustername
az acr create --name $containerregistry --resource-group $ressourcegroup --sku Basic
az acr update -n $containerregistry --admin-enabled true
$acrusername = az acr credential show -n $containerregistry --query username
$acrpassword = az acr credential show -n $containerregistry --query passwords[0].value

### deploy kubernetes configurations
kubectl apply -f .\namespaces.yaml
$dockerserver = "$($containerregistry).azurecr.io"
kubectl create secret docker-registry acrauth $containerregistry --docker-username=$acrusername --docker-password=$acrpassword --docker-server="$dockerserver" --docker-email="$email" --namespace dev
kubectl create secret docker-registry acrauth $containerregistry --docker-username=$acrusername --docker-password=$acrpassword --docker-server="$dockerserver" --docker-email="$email" --namespace test
kubectl create secret docker-registry acrauth $containerregistry --docker-username=$acrusername --docker-password=$acrpassword --docker-server="$dockerserver" --docker-email="$email" --namespace prod
helm init --upgrade --service-account default
helm repo update
helm install stable/nginx-ingress --namespace kube-system --set rbac.create=false --set rbac.createRole=false --set rbac.createClusterRole=false
helm install stable/kube-lego --set config.LEGO_EMAIL=$email --set config.LEGO_URL=https://acme-v01.api.letsencrypt.org/directory