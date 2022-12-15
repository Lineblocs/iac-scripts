#! /bin/bash
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

echo "helm version is '${helm_version}'"
if [ "${helm_version}" == "<no value>" ]; then
   echo "helm version not supported, please install >= 3.0"
   exit
fi

helm_details_1=(${helm_version//v/ })
helm_details_2=(${helm_details_1[0]//./ })
if [ "${helm_details_2[0]}" != '3' ]; then
   echo "helm version not supported, please install >= 3.0"
   exit
fi


# configured lineblocs key
#lineblocs_key='exmaple-strong-key'
lineblocs_key=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)

# install CRDs
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.1/cert-manager.crds.yaml

# install Helm packages
helm repo add stable https://charts.helm.sh/stable
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

REDIS_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
helm install nginx-ingress stable/nginx-ingress --set controller.publishService.enabled=true
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.14.1
helm install metrics-server stable/metrics-server
helm install redis-cluster bitnami/redis --set global.redis.password="$REDIS_PASSWORD" --set auth.enabled=false


# in# create namespaces
kubectl create namespace cert-manager
kubectl create ns voip
kubectl create ns voip-users
kubectl create ns storage

# create DB

DB_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
#B64_PASSWORD=$(echo -n $PASSWORD | base64)

PXC_SECRETS="${DIR}/percona/deploy/secrets.yaml.template"
PXC_SECRETS_OUT="${DIR}/percona/deploy/secrets.yaml"
sed "s/LINEBLOCS_DB_PASSWORD/${DB_PASSWORD}/g" $PXC_SECRETS > $PXC_SECRETS_OUT
#kubectl create -f ./mysql/01-mysql-pv.yml,./mysql/02-mysql-deployment.yml,./mysql/03-mysql-lb.yml
echo "Percona / MySQL password is: $DB_PASSWORD\r\n"

# create percona ns
kubectl create ns pxc

kubectl apply -f ./percona/deploy/crd.yaml
kubectl apply -f ./percona/deploy/rbac.yaml -n pxc
kubectl apply -f ./percona/deploy/operator.yaml -n pxc
kubectl apply -f ./percona/deploy/secrets.yaml -n pxc
kubectl apply -f ./percona/deploy/cr.yaml -n pxc


# install etcd
ETCD_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)

helm install etcd bitnami/etcd --set auth.rbac.rootPassword="${ETCD_PASSWORD}"

INTERNALS="${DIR}/web/06-internals.yml.template"
INTERNALS_OUT="${DIR}/web/06-internals.yml"
sed "s/GENERATED_ETCD_PASSWORD/${ETCD_PASSWORD}/g" $INTERNALS > $INTERNALS_OUT


APP_TMPL="${DIR}/web/01-app.yml.template"
APP="${DIR}/web/01-app.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $APP_TMPL > $APP

WEB_TMPL="${DIR}/web/02-com.yml.template"
WEB="${DIR}/web/02-com.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $WEB_TMPL > $WEB

EDITOR_TMPL="${DIR}/web/04-editor.yml.template"
EDITOR="${DIR}/web/04-editor.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $EDITOR_TMPL > $EDITOR



# create web services
kubectl create -f ./web/00-namespace.yml,./web/01-app.yml,./web/02-com.yml,./web/03-compiler.yml,./web/04-editor.yml,./web/05-routeeditor.yml,./web/06-internals.yml,./web/07-phpmyadmin.yml

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

ARI_TMPL="${DIR}/web/05-asterisk.yml.template"
ARI="${DIR}/web/05-asterisk.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $ARI_TMPL > $ARI.cop
sed "s/CONFIGURED_LINEBLOCS_KEY/${lineblocs_key}/g" $ARI.cop > $ARI

OPENSIPS_TMPL="${DIR}/web/03-opensips.yml.template"
OPENSIPS="${DIR}/web/03-opensips.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $OPENSIPS_TMPL > $OPENSIPS.cop
sed "s/CONFIGURED_LINEBLOCS_KEY/${lineblocs_key}/g" $opensips.cop > $OPENSIPS

# voip services
kubectl create -f ./voip/00-namespace.yml,./voip/01-rbac.yml,./voip/02-nats.yml,./voip/03-opensips.yml,./voip/04-rtpproxy.yml,./voip/05-asterisk.yml,./voip/06-mngrs.yml,./voip/07-k8sevents.yml,./voip/08-grpc.yml

echo "services are starting.."
sleep 10;
echo "to view the status of your deployment, run: kubectl get svc -w"

