#!/bin/bash
kubectl delete secret voip-regcred
AWS_KEY_ID=AKIAJHVI2B5KLCRD3BIQ
AWS_SECRET=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
AWS_REGION=ca-central-1
echo "LOGGING IN.."
aws ecr get-login-password --region ca-central-1 | docker login --username AWS --password-stdin 754569496111.dkr.ecr.ca-central-1.amazonaws.com
kubectl -n voip --insecure-skip-tls-verify --ignore-not-found=true delete secret voip-regcred
echo "CREATING VOIP REGCRED.."
kubectl -n voip --insecure-skip-tls-verify create secret generic voip-regcred  --from-file=.dockerconfigjson=${HOME}/.docker/config.json  --type=kubernetes.io/dockerconfigjson

kubectl -n default --insecure-skip-tls-verify --ignore-not-found=true delete secret web-regcred
echo "CREATING WEB REGCRED.."
kubectl -n default --insecure-skip-tls-verify create secret generic web-regcred  --from-file=.dockerconfigjson=${HOME}/.docker/config.json  --type=kubernetes.io/dockerconfigjson
