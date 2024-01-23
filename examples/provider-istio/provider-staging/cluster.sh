
eksctl create nodegroup \
  --cluster=device-core \
  --region=us-east-1 \
  --node-labels="node=ondemand" \
  --tags="PROJECT=CORE"
  --managed \
  --name=remotize-redis-ondemand-node-group \
  --instance-types=t3.xlarge \
  --nodes-min=1 \
  --nodes-max=1 \
  --asg-access \
  | tee logs/redisOndemandNodeGroup.log

eksctl create nodegroup \
  --cluster=amp-cluster \
  --region=us-east-1 \
  --node-labels="node=spot-provider-istio" \
  --tags="PROJECT=INCLOUD" \
  --managed \
  --spot  \
  --name=provider-istio-spot-node-group \
  --instance-types=t3.xlarge,t3a.xlarge \
  --nodes-min=1 \
  --nodes-max=20 \
  --asg-access \
  | tee logs/spotNodeGroup.log

eksctl create nodegroup \
  --cluster=amp-cluster \
  --region=us-east-1 \
  --node-labels="node=spot-redis-istio" \
  --tags="PROJECT=INCLOUD" \
  --managed \
  --spot  \
  --name=redis-spot-istio-node-group \
  --instance-types=t3.xlarge,t3a.xlarge \
  --nodes-min=1 \
  --nodes-max=20 \
  --asg-access \
  | tee logs/spotNodeGroup.log


kubectl create ns provider-dev
kubectl create secret generic provider -n ns-istio-provider \
  --from-file=./DATABASE_URL \
  --from-file=./NATS_CREDS \
  --from-file=./NATS_CREDS_SYS \
  --from-file=./LIB_NATS_CRED_FILE \
  --from-file=./MQTT_AC_ID



helm upgrade --install provider-istio ./ -n ns-istio-provider

helm uninstall provider-istio -n ns-istio-provider
