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
helm uninstall my-release
```

## Parameters

| Parameter                        | Description                                                    | Default                           |
|----------------------------------|----------------------------------------------------------------|-----------------------------------|
| `nameOverride`                   | String to partially override meilisearch.fullname              | `"meilisearch"`
| `fullnameOverride`               | String to fully override meilisearch.fullname                  | `"meilisearch"`
| `namespaceOverride`              | Override the deployment namespace                              | `""`
| `imagePullSecrets`               | List of container registry secretse                            | `[]`
| `name`                           | Name of the Release                                            | `"meilisearch"`
| `image.repository`               | MeiliSearch image name                                         | `getmeili/meilisearch`
| `image.tag`                      | MeiliSearch image tag                                          | `v0.18.1`
| `image.pullPolicy`               | MeiliSearch image pull policy                                  | `IfNotPresent`| 
| `replicaCount`                   | Number of nodes (Valid only when autoscaling is disabled)      | `1`
| `autoscaling.enabled`            | Enable Horizontal Pod Autoscaler                               | `false`
| `autoscaling.minReplicas`        | Minimum number of replicas for the HPA                         | `2`
| `autoscaling.maxReplicas`        | Maximum number of replicas for the HPA                         | `5`
| `autoscaling.targetCPUUtilizationPercentage` | Average CPU utilization percentage for the HPA     | `80`
| `autoscaling.targetMemoryUtilizationPercentage` | Average Memory utilization percentage for the HPA  | `80`
| `podDisruptionBudget.minAvailable` | Pod disruption minimum available                             | `nil`
| `podDisruptionBudget.maxAvailable` | Pod disruption maximum available                             | `nil`
| `podDisruptionBudget.labels`     | Additional labels for poddisruptionbudget                      | `{}`
| `podDisruptionBudget.annotations`| Additional annotations for poddisruptionbudget                 | `{}`
| `env`                            | Environment variables to pass for configuration                | `nil`
| `serviceAccount.create`          | Create Service account                                         | `true`
| `serviceAccount.name`            | Name for the service account                                   | `"meilisearch"`
| `serviceAccount.labels`          | Additional labels for service account                          | `{}`
| `serviceAccount.annotations`     | Additional annotations for service account                     | `{}`
| `podAnnotations`                 | Annotations for the pods                                       | `nil`
| `securityContext`                | Security Context for the pods                                  | `nil`
| `service.type`                   | Service HTTP port                                              | `ClusterIP`
| `service.port`                   | Kubernetes Service type                                        | `7700`
| `service.portName`               | Kubernetes Service type                                        | `http`
| `service.labels`                 | Additional labels for service                                  | `{}`
| `service.annotations`            | Additional annotations for service                             | `{}`
| `ingress.enabled`                | Enable ingress controller resource                             | `false`
| `ingress.annotations`            | Additional annotations for Ingress                             | `{}`
| `ingress.labels`                 | Additional labels for Ingress                                  | `{}`
| `ingress.paths`                  | Path within the host                                           | `/`
| `ingress.extraPaths`             | Ingress extra paths to prepend to every host configuration. Useful when configuring custom actions with AWS ALB Ingress Controller. | `[]`
| `ingress.hosts`                  | List of hostnames                                              | `[]`
| `ingress.tls`                    | TLS specification                                              | `[]`
| `persistence.enabled`            | Enable persistence using PVC                                   | `false`
| `persistence.accessMode`         | PVC Access Mode                                                | `ReadWriteOnce`
| `persistence.storageClass`       | PVC Storage Class                                              | `-` (No storage class)
| `persistence.size`               | PVC Storage Request                                            | `20Gi`
| `persistence.labels`             | Additional labels for PVC                                      | `{}`
| `persistence.annotations`        | Additional annotations for PVC                                 | `{}`
| `resources`                      | Resources allocation (Requests and Limits)                     | `{}`
| `readinessProbe.initialDelaySeconds` | Readiness Probe initial delay in seconds                   | `10`
| `readinessProbe.timeoutSeconds` | Readiness Probe timeout in seconds                              | `5`
| `readinessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed | `1`
| `readinessProbe.failureThreshold` | When a probe fails, Kubernetes will how many times to try before giving up | `5`
| `readinessProbe.periodSeconds` | How often to perform the probe in seconds                        | `10`
| `livenessProbe.initialDelaySeconds` | Liveness Probe initial delay in seconds                     | `10`
| `livenessProbe.timeoutSeconds` | Liveness Probe timeout in seconds                                | `5`
| `livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed | `1`
| `livenessProbe.failureThreshold` | When a probe fails, Kubernetes will how many times to try before giving up | `5`
| `livenessProbe.periodSeconds` | How often to perform the probe in seconds                        | `10`
| `nodeSelector`                   | Node labels for pod assignment                                 | `{}`
| `tolerations`                    | Tolerations for pod assignment                                 | `[]`
| `affinity`                       | Affinity for pod assignment                                    | `{}`


### Environment Variables

The `env` block allows to specify all the environment variables declared on [MeiliSearch Configuration](https://docs.meilisearch.com/guides/advanced_guides/configuration.html)

For production deployment, setting the environment variable `MEILI_MASTER_KEY` is mandatory.

`MEILI_MASTER_KEY` for eg is set with the following code in `env`:

```
  - name: MEILI_MASTER_KEY
    valueFrom:
      secretKeyRef:
        name: meilisearch
        key: meili_key 
```        

The above for example expects a `secret` with the name `meilisearch` to exist, with key specified as `meili_key`. This would be the suggested way to add the MASTER_KEY. Other insecure way to add the MASTER_KEY is to add it like any other env variable like below:

```
  - name: MEILI_MASTER_KEY
    value: PLEASE_CHANGE_ME
```   