kubectl create namespace pihole
kubectl apply -f pihole.persistentvolume.yaml
kubectl apply -f pihole.persistentvolumeclaim.yaml
helm install pihole mojo2600/pihole -n pihole --values pihole.values.yaml
