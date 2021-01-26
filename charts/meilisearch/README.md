# Meilisearch

Helm works as a package manager to run pre-configured Kubernetes resources.

MeiliSearch provides a customizable Helm chart, ready to deploy a [Meilisearch](https://github.com/meilisearch/MeiliSearch) instance on your Kubernetes cluster.

# Getting started

First of all, you will need a Kubernetes cluster up and running. If you are not familiar with how Kuberentes works or need some help with this step, please check the [Kubernetes documentation](https://kubernetes.io/docs/home/).

## Install kubectl

`kubectl` is the most commonly used CLI to handle a Kubernetes cluster. The installation instructions are [available here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

## Install helm

Helm CLI is a Command Line Interface which will automate chart management and installation on your Kubernetes cluster. To install Helm, follow the [Helm installation instructions](https://helm.sh/docs/intro/install/)

## Get Repo Info

```console
helm repo add factly https://factly.github.io/helm-charts
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install MeiliSearch chart

To install the chart with the release name `my-release`:

```console
helm install my-release factly/meilisearch
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm delete my-release
```

## Parameters

| Parameter                        | Description                                                    | Default                           |
|----------------------------------|----------------------------------------------------------------|-----------------------------------|
| `nameOverride`                   | String to partially override meilisearch.fullname              | `nil`
| `fullnameOverride`               | String to fully override meilisearch.fullname                  | `nil`
| `replicaCount`                   | Number of MeiliSearch pods to run                              | `1`
| `environment.MEILI_ENV`          | Sets the environment. Either **production** or **development** | `development`
| `environment.MEILI_NO_ANALYTICS` | Deactivates analytics                                          | `true`
| `image.repository`               | MeiliSearch image name                                         | `getmeili/meilisearch`
| `image.tag`                      | MeiliSearch image tag                                          | `{TAG_NAME}`
| `image.pullPolicy`               | MeiliSearch image pull policy                                  | `IfNotPresent`
| `ingress.enabled`                | Enable ingress controller resource                             | `false`
| `ingress.annotations`            | Ingress annotations                                            | `{}`
| `ingress.path`                   | Path within the host                                           | `/`
| `ingress.hosts`                  | List of hostnames                                              | `[meilisearch-example.local]`
| `ingress.tls`                    | TLS specification                                              | `[]`
| `service.port`                   | Service HTTP port                                              | `ClusterIP`
| `service.type`                   | Kubernetes Service type                                        | `7700`
| `persistence.enabled`            | Enable persistence using PVC                                   | `false`
| `persistence.accessMode`         | PVC Access Mode                                                | `ReadWriteOnce`
| `persistence.storageClass`       | PVC Storage Class                                              | `-` (No storage class)
| `persistence.size`               | PVC Storage Request                                            | `10Gi`
| `resources`                      | Resources allocation (Requests and Limits)                     | `{}`
| `tolerations`                    | Tolerations for pod assignment                                 | `[]`
| `nodeSelector`                   | Node labels for pod assignment                                 | `{}`
| `affinity`                       | Affinity for pod assignment                                    | `{}`


### Environment

The `env` block allows to specify all the environment variables declared on [MeiliSearch Configuration](https://docs.meilisearch.com/guides/advanced_guides/configuration.html#passing-arguments-via-the-command-line)

For production deployment, setting the environment variable `MEILI_MASTER_KEY` is mandatory.

`MEILI_MASTER_KEY` for eg is set with the following code in `env`:

```
  - name: MEILI_MASTER_KEY
    valueFrom:
      secretKeyRef:
        name: meilisearch
        key: meili_key 
```        

The above for example expects a `secret` with the name `meilisearch` to exist, with key specified as `meili_key`