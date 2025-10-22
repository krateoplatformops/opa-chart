# Open Policy Agent Chart

[OPA](https://www.openpolicyagent.org) is an open-source general-purpose policy
engine designed for cloud-native environments.

## How to install

```sh
helm repo add krateo https://charts.krateo.io
helm repo update krateo
helm install opa-chart krateo/opa-chart
```

## Note on Policies and Permissions
By default the Chart will assign **Admin** permissions to the running policies. This allows the policies to interact with any resource freely. We suggest reducing the scope of the permissions to those strictly needed by policies. 