# eks-istio
## Documentação para instalação e configuração do istio em cluster EKS ##

baixar versão mais recente nocaso utilizamos a versão 1.20.2
curl -L https://istio.io/downloadIstio | sh -

versão especifica:
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.2 TARGET_ARCH=x86_64 sh -

entre no diretorio
cd istio-1.20.2

adiciona o istioctl ao path
export PATH=$PWD/bin:$PATH


 Alterar ingress gateway para NLB.

→ Por padrão o istioctl install cria para ingressgateway um CLB que não atende a necessidade da aplicação necessita alteração para criação de um NLB.

Alterção a nivel de codigo na pasta: manifests/charts/gateways/istio-ingress/values.yaml

serviceAnnotations: 
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      service.beta.kubernetes.io/aws-load-balancer-internal: "false"



aplicar alteração: istioctl install — set profile=xxxx — charts=./manifests/ -y


o arquivo ingress-gateway.yaml dentro de istio tem a funçção de subir os ingress e egress primarios e secundarios em namespaces diferentes para evitar conflitos de portas.


criar namespace para apliicação
kubectl create ns xxxxxx

adicionar label ao namespace 
kubectl label namespace xxxxxx istio-injection=enabled

instalar aplicação
helm ......

ordem das aplicaçoes incloud
1 nats
2 console "pode utilizar outro ja instalado "mudar url no configmap""
2 mqtt-server
3 provider
demais ....

instalar os gateways e virtual-services
-> pasta istio da aplicação
 kubectl apply -f xxxxxx.yaml

verificar se o istio esta ok no namespace 
istioctl analyze -n xxxxxxxxx

instalar addons kiali,prometheus,grafana e jaeger
kubectl apply -f samples/addons

iniciar kiali port forward apartir da pasta do istio-x.xx.x
istioctl dashboard kiali
--> tambem pode abrir no rancher em istio.




### UNINSTALL ISTIO ####

kubectl delete -f samples/addons
istioctl uninstall -y --purge

kubectl delete namespace istio-system

kubectl label namespace xxxxx istio-injection-





#### CRIAR VARIOS INGRESS ####
criar este YAML e aplicar com o comando
istioctl install -f ingress-gateway.yaml -y

arquivo:
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  components:
    ingressGateways:
      - name: istio-ingressgateway
        enabled: true
      - name: istio-ingressgateway-dev
        namespace: istio-ingress
        enabled: true
        label:
          istio: istio-ingressgateway-dev