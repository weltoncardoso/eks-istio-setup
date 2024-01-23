
eksctl create nodegroup \
  --cluster=amp-cluster \
  --region=us-east-1 \
  --node-labels="node=mqtt-server-teste" \
  --tags="PROJECT=INCLOUD" \
  --spot \
  --managed \
  --name=mqtt-server-teste-spot-node-group \
  --instance-types=t3.xlarge \
  --nodes-min=1 \
  --nodes-max=1 \
  --asg-access 

eksctl create nodegroup \
  --cluster=amp-cluster \
  --region=us-east-1 \
  --node-labels="node=mqtt-server" \
  --tags="PROJECT=INCLOUD" \
  --managed \
  --name=mqtt-server-2xlarge-node-group \
  --instance-types=t3a.2xlarge \
  --nodes-min=1 \
  --nodes-max=20 \
  --asg-access \
  | tee logs/spotNodeGroup.log

eksctl create nodegroup \
  --cluster=amp-cluster \
  --region=us-east-1 \
  --node-labels="node=redis-mqtt-teste" \
  --tags="PROJECT=INCLOUD" \
  --managed \
  --name=redis-mqtt-server-teste-node-group \
  --instance-types=t3.xlarge,t3a.xlarge \
  --nodes-min=1 \
  --nodes-max=5 \
  --asg-access \
  | tee logs/spotNodeGroup.log



kubectl create ns mqtt-server-teste
kubectl create secret generic mqtt-server-map -n ns-istio-mqtt-server \
  --from-file=./LIB_NATS_CRED_FILE


## Importar entre namespaces o secret do load balacer para o remotize-production para escrever o secret.

kubectl get secret nats-client-tls -n default -o yaml > my-secret.yaml

## muadr namespace no yaml antes de aplly

kubectl apply -f my-secret.yaml -n ns-nats-istio



helm upgrade --install mqtt-server-istio ./ -n ns-istio-mqtt-server


