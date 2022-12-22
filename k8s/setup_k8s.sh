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
kubectl apply namespace cert-manager

# create DB

db_name='lineblocs'
db_username='dbuser'
db_password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
db_host='dbcluster'
opensips_db='opensips'

#B64_PASSWORD=$(echo -n $PASSWORD | base64)

PXC_SECRETS="${DIR}/percona/deploy/secrets.yaml.template"
PXC_SECRETS_OUT="${DIR}/percona/deploy/secrets.yaml"
sed "s/LINEBLOCS_DB_PASSWORD/${db_password}/g" $PXC_SECRETS > $PXC_SECRETS_OUT
#kubectl apply -f ./mysql/01-mysql-pv.yml,./mysql/02-mysql-deployment.yml,./mysql/03-mysql-lb.yml
echo "Percona / MySQL password is: $db_password\r\n"

# create percona ns
kubectl apply ns pxc

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
sed "s/GENERATED_ETCD_PASSWORD/${ETCD_PASSWORD}/g" $INTERNALS > $INTERNALS.cop1
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $INTERNALS.cop1 > $INTERNALS.cop2
sed "s/CONFIGURED_DB_HOST/${db_host}/g" $INTERNALS.cop2 > $INTERNALS.cop3
sed "s/CONFIGURED_DB_USERNAME/${db_username}/g" $INTERNALS.cop3 > $INTERNALS.cop4
sed "s/CONFIGURED_DB_PASSWORD/${db_password}/g" $INTERNALS.cop4 > $INTERNALS.cop5
sed "s/CONFIGURED_DB_NAME/${db_name}/g" $INTERNALS.cop5 > $INTERNALS.cop6
sed "s/CONFIGURED_DB_OPENSIPS_DATABASE/${opensips_db}/g" $INTERNALS.cop6 > $INTERNALS

APP_TMPL="${DIR}/web/01-app.yml.template"
APP="${DIR}/web/01-app.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $APP_TMPL > $APP


WEB_TMPL="${DIR}/web/02-com.yml.template"
WEB="${DIR}/web/02-com.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $WEB_TMPL > $WEB.cop1
sed "s/CONFIGURED_DB_HOST/${db_host}/g" $WEB.cop1 > $WEB.cop2
sed "s/CONFIGURED_DB_USERNAME/${db_username}/g" $WEB.cop2 > $WEB.cop3
sed "s/CONFIGURED_DB_PASSWORD/${db_password}/g" $WEB.cop3 > $WEB.cop4
sed "s/CONFIGURED_DB_NAME/${db_name}/g" $WEB.cop4 > $WEB.cop5
sed "s/CONFIGURED_DB_OPENSIPS_DATABASE/${opensips_db}/g" $WEB.cop5 > $WEB

EDITOR_TMPL="${DIR}/web/04-editor.yml.template"
EDITOR="${DIR}/web/04-editor.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $EDITOR_TMPL > $EDITOR



# create web services
kubectl apply -f ./web/00-namespace.yml,./web/01-app.yml,./web/02-com.yml,./web/03-tsbindings.yml,./web/04-editor.yml,./web/05-routeeditor.yml,./web/06-internals.yml,./web/07-phpmyadmin.yml

# setup cert manager
kubectl apply  -f ./web/production_issuer.yaml

# ingress
kubectl apply  -f ./web/ingress.yml

# metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# create extra service accounts
kubectl apply -f ./rbac/cred-acc.yml

# create crontabs
kubectl apply -f ./misc/crontabs.yml

ARI_TMPL="${DIR}/web/05-asterisk.yml.template"
ARI="${DIR}/web/05-asterisk.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $ARI_TMPL > $ARI.cop1
sed "s/CONFIGURED_LINEBLOCS_KEY/${lineblocs_key}/g" $ARI.cop1 > $ARI.cop2
sed "s/CONFIGURED_ARI_USERNAME/${ari_username}/g" $ARI.cop2 > $ARI.cop3
sed "s/CONFIGURED_ARI_PASSWORD/${ari_password}/g" $ARI.cop3 > $ARI


OPENSIPS_TMPL="${DIR}/web/03-opensips.yml.template"
OPENSIPS="${DIR}/web/03-opensips.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $OPENSIPS_TMPL > $OPENSIPS.cop1
sed "s/CONFIGURED_LINEBLOCS_KEY/${lineblocs_key}/g" $OPENSIPS.cop1 > $OPENSIPS.cop2
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $OPENSIPS.cop2 > $OPENSIPS.cop3
sed "s/CONFIGURED_DB_NAME/${db_name}/g" $OPENSIPS.cop3 > $OPENSIPS.cop4
sed "s/CONFIGURED_DB_USERNAME/${db_username}/g" $OPENSIPS.cop4 > $OPENSIPS.cop5
sed "s/CONFIGURED_DB_PASSWORD/${db_password}/g" $OPENSIPS.cop5 > $OPENSIPS.cop6
sed "s/CONFIGURED_DB_HOST/${db_host}/g" $OPENSIPS.cop6 > $OPENSIPS.cop7
sed "s/CONFIGURED_ARI_USERNAME/${ari_username}/g" $OPENSIPS.cop7 > $OPENSIPS.cop8
sed "s/CONFIGURED_ARI_PASSWORD/${ari_password}/g" $OPENSIPS.cop8 > $OPENSIPS

MNGRS_TMPL="${DIR}/web/06-mngrs.yml.template"
MNGRS="${DIR}/web/06-mngrs.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $MNGRS_TMPL > $MNGRS.cop
sed "s/CONFIGURED_DB_NAME/${db_name}/g" $MNGRS.cop > $MNGRS.cop2
sed "s/CONFIGURED_DB_USERNAME/${db_username}/g" $MNGRS.cop2 > $MNGRS.cop3
sed "s/CONFIGURED_DB_PASSWORD/${db_password}/g" $MNGRS.cop3 > $MNGRS.cop4
sed "s/CONFIGURED_DB_HOST/${db_host}/g" $MNGRS.cop4 > $MNGRS.cop5
sed "s/CONFIGURED_ARI_USERNAME/${ari_username}/g" $MNGRS.cop5 > $MNGRS.cop6
sed "s/CONFIGURED_ARI_PASSWORD/${ari_password}/g" $MNGRS.cop6 > $MNGRS

K8SEVENTS_TMPL="${DIR}/web/07-k8sevents.yml.template"
K8SEVENTS="${DIR}/web/07-k8sevents.yml"
sed "s/CONFIGURED_DEPLOYMENT_DOMAIN/${domain}/g" $K8SEVENTS_TMPL > $K8SEVENTS.cop
sed "s/CONFIGURED_DB_NAME/${db_name}/g" $K8SEVENTS.cop > $K8SEVENTS.cop2
sed "s/CONFIGURED_DB_USERNAME/${db_username}/g" $K8SEVENTS.cop2 > $K8SEVENTS.cop3
sed "s/CONFIGURED_DB_PASSWORD/${db_password}/g" $K8SEVENTS.cop3 > $K8SEVENTS.cop4
sed "s/CONFIGURED_DB_HOST/${db_host}/g" $K8SEVENTS.cop4 > $K8SEVENTS

# voip services
kubectl apply -f ./voip/00-namespace.yml,./voip/01-rbac.yml,./voip/02-nats.yml,./voip/03-opensips.yml,./voip/04-rtpproxy.yml,./voip/05-asterisk.yml,./voip/06-mngrs.yml,./voip/07-k8sevents.yml,./voip/08-grpc.yml

echo "services are starting.."
sleep 10;
echo "to view the status of your deployment, run: kubectl get svc -w"

