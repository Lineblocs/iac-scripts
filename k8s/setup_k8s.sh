#! /bin/sh
while getopts d: flag
do
    case "${flag}" in
        d) domain=${OPTARG};;
    esac
done
echo "Domain: $domain";
if [ -z ${domain} ]; then 
   echo "domain not set. please rerun the script with the -d option. for example: ./setup_k8s.sh -d example.org"
   exit -1
fi

DIR=`pwd`
INGRESS="${DIR}/web/ingress.yml.template"
INGRESS_OUT="${DIR}/web/ingress.yml"
sed "s/DOMAIN_TO_CHANGE/${domain}/g" $INGRESS > $INGRESS_OUT
command -v kubectl
if [ "$?" -ne 0 ]; then
   echo "kubectl was not found. to continue, please install kubectl >= 1.20"
   exit
fi
command -v helm
if [ "$?" -ne 0 ]; then
   echo "helm was not found. to continue, please install helm >= 3.0"
   exit
fi

kube_version=`kubectl version -o json`

kube_details_1=`echo ${kube_version} | jq '.clientVersion .major'`
kube_details_2=`echo ${kube_version} | jq '.clientVersion .minor'`
echo $kube_details_1

if [ "${kube_details_1}" != '"1"' ]; then
   echo "kubectl version not supported, please install >= 1.0"
   exit
fi
helm_version=`helm  version --template='{{.Version}}'`
if [ "${helm_version}" == '<no value>' ]; then
   echo "helm version not supported, please install >= 3.0"
   exit
fi
helm_details_1=(${helm_version//v/ })
helm_details_2=(${helm_details_1[0]//./ })
if [ "${helm_details_2[0]}" != '3' ]; then
   echo "helm version not supported, please install >= 3.0"
   exit
fi

# install CRDs
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager.crds.yaml

# install Helm packages
helm repo add stable https://charts.helm.sh/stable
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install nginx-ingress stable/nginx-ingress --set controller.publishService.enabled=true
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.14.1
helm install metrics-server stable/metrics-server


# in# create namespaces
kubectl create namespace cert-manager
kubectl create ns voip
kubectl create ns voip-users
kubectl create ns storage

# create DB
kubectl create -f ./mysql/01-mysql-pv.yml,./mysql/02-mysql-deployment.yml,./mysql/03-mysql-lb.yml

# create web services
kubectl create -f ./web/01-app.yml,./web/02-com.yml,./web/03-compiler.yml,./web/04-editor.yml,./web/05-internals.yml,./web/06-phpmyadmin.yml

# setup cert manager
kubectl create  -f ./web/production_issuer.yaml

# ingress
kubectl create  -f ./web/ingress.yml

# metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# create extra service accounts
kubectl create -f ./rbac/cred-acc.yml

# create crontabs
kubectl create -f ./misc/crontabs.yml

# voip services
kubectl create -f ./voip/01-rbac.yaml,./voip/02-nats.yaml,./voip/03-opensips.yaml,./voip/04-asterisk.yaml,./voip/05-mngrs.yaml,./voip/06-k8sevents.yaml,./voip/07-grpc.yaml

echo "services are starting.."
sleep 10;
echo "to view the status of your deployment, run: kubectl -w get svc"
