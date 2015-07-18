# This is the env to run Kubernetes locally with vagrant with all the stuff I want

export KUBERNETES_PROVIDER=vagrant
export NUM_MINIONS=1
export ENABLE_CLUSTER_DNS=true
export DNS_SERVER_IP="10.0.0.10"
export DNS_DOMAIN="cluster.local"
export DNS_REPLICAS=1

alias kc=kubectl

