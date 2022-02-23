# umami

Helm works as a package manager to run pre-configured Kubernetes resources.

This a customizable Helm chart, ready to deploy a [umami](https://github.com/factly/umami) instance on your Kubernetes cluster.

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

## Install umami chart

To install the chart with the release name `my-release`:

```console
helm install my-release factly/umami
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
helm uninstall my-release
```

## Parameters

| Parameter                        | Description                                                    | Default                           |
|----------------------------------|----------------------------------------------------------------|-----------------------------------|
| `nameOverride`                   | String to partially override umami.fullname                     | `"umami"`
| `fullnameOverride`               | String to fully override umami.fullname                         | `"umami"`
| `namespaceOverride`              | Override the deployment namespace                              | `""`
| `imagePullSecrets`               | List of container registry secretse                            | `[]`
| `name`                           | Name of the Release                                            | `"umami"`
| `image.repository`               | umami image name                                                | `factly/umami`
| `image.tag`                      | umami image tag                                                 | `1.26.0`
| `image.pullPolicy`               | umami image pull policy                                         | `IfNotPresent`
| `replicaCount`                   | Number of nodes (Valid only when autoscaling is disabled)      | `1`
| `autoscaling.enabled`            | Enable Horizontal Pod Autoscaler                               | `false`
| `autoscaling.minReplicas`        | Minimum number of replicas for the HPA                         | `2`
| `autoscaling.maxReplicas`        | Maximum number of replicas for the HPA                         | `5`
| `autoscaling.targetCPUUtilizationPercentage` | Average CPU utilization percentage for the HPA     | `80`
| `autoscaling.targetMemoryUtilizationPercentage` | Average Memory utilization percentage for the HPA  | `80`
| `podDisruptionBudget.minAvailable` | Pod disruption minimum available                             | `nil`
| `podDisruptionBudget.maxUnavailable` | Pod disruption maximum unavailable                         | `nil`
| `podDisruptionBudget.labels`     | Additional labels for poddisruptionbudget                      | `{}`
| `podDisruptionBudget.annotations`| Additional annotations for poddisruptionbudget                 | `{}`
| `createSecret.enabled`           | Creates a secret with name umami                                | `true`
| `createSecret.postgresqlPostgresPassword`     | PostgreSQL admin password (used when postgresqlUsername is not postgres, in which casepostgres is the admin username)   | `ClusterIP`
| `createSecret.postgresqlPassword`             | PostgreSQL user password                          | `8001`
| `createSecret.postgresqlReplicationPassword`  | Replication user password (overrides replication password) | `metrics`
| `env`                            | Environment variables to pass for configuration                | `check values.yaml for defaults`
| `serviceAccount.create`          | Create Service account                                         | `true`
| `serviceAccount.name`            | Name for the service account                                   | `"umami"`
| `serviceAccount.labels`          | Additional labels for service account                          | `{}`
| `serviceAccount.annotations`     | Additional annotations for service account                     | `{}`
| `podAnnotations`                 | Annotations for the pods                                       | `nil`
| `securityContext`                | Security Context for the pods                                  | `nil`
| `service.type`                   | Service HTTP port                                              | `ClusterIP`
| `service.port`                   | Kubernetes Service type                                        | `8000`
| `service.portName`               | Kubernetes Service type                                        | `http`
| `service.labels`                 | Additional labels for service                                  | `{}`
| `service.annotations`            | Additional annotations for service                             | `{}`
| `metrics.enabled`                | Enable Metrics                                                 | `false`
| `metrics.serviceMonitor.enabled` | Enable Service Monitor for Prometheus Operator                 | `false`
| `metrics.serviceMonitor.selector`| Selector to select Pods                                        | `"release: monitoring"`
| `metrics.serviceMonitor.labels`  | Additional labels for service monitor                          | `{}`
| `metrics.serviceMonitor.annotations` | Additional annotations for service monitor                 | `{}`
| `metrics.serviceMonitor.interval`| Interval at which metrics should be scraped                    | `30s`
| `metrics.serviceMonitor.scheme`  | HTTP scheme to use for scraping                                | `http`
| `metrics.serviceMonitor.tlsConfig` | TLS configuration to use when scraping the endpoint          | `{}`
| `metrics.serviceMonitor.scrapeTimeout` | 	Timeout after which the scrape is ended                 | `30s`
| `ingress.enabled`                | Enable ingress controller resource                             | `false`
| `ingress.annotations`            | Additional annotations for Ingress                             | `{}`
| `ingress.labels`                 | Additional labels for Ingress                                  | `{}`
| `ingress.paths`                  | Path within the host                                           | `/`
| `ingress.extraPaths`             | Ingress extra paths to prepend to every host configuration. Useful when configuring custom actions with AWS ALB Ingress Controller. | `[]`
| `ingress.hosts`                  | List of hostnames                                              | `[]`
| `ingress.tls`                    | TLS specification                                              | `[]`
| `resources`                      | Resources allocation (Requests and Limits)                     | `{}`
| `readinessProbe.initialDelaySeconds` | Readiness Probe initial delay in seconds                   | `10`
| `readinessProbe.timeoutSeconds`  | Readiness Probe timeout in seconds                              | `5`
| `readinessProbe.successThreshold`| Minimum consecutive successes for the probe to be considered successful after having failed | `1`
| `readinessProbe.failureThreshold`| When a probe fails, Kubernetes will how many times to try before giving up | `5`
| `readinessProbe.periodSeconds`   | How often to perform the probe in seconds                        | `10`
| `livenessProbe.initialDelaySeconds` | Liveness Probe initial delay in seconds                     | `10`
| `livenessProbe.timeoutSeconds`   | Liveness Probe timeout in seconds                                | `5`
| `livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed | `1`
| `livenessProbe.failureThreshold` | When a probe fails, Kubernetes will how many times to try before giving up | `5`
| `livenessProbe.periodSeconds`    | How often to perform the probe in seconds                        | `10`
| `nodeSelector`                   | Node labels for pod assignment                                 | `{}`
| `tolerations`                    | Tolerations for pod assignment                                 | `[]`
| `affinity`                       | Affinity for pod assignment                                    | `{}`
| `postgresql.enabled`             | Installs Bitnami's chart for Postgresql                        | `true`
| `postgresql.enabled`             | Postgres Image Tag                      | `14.1.0-debian-10-r80`
| `postgresql.existingSecret`      | Uses an existing secret. Keep it as `umami` if `createSecret.enable` is `true` | `ClusterIP`

### Environment Variables

The `env` block allows to configure any environment variables as documented on [umami Configuration](https://umami.is/docs/environment-variables).

A 50 character alphanumeric `HASH_SALT` is generated automatically by the chart.

#### TODO:

Need to generate the `DATABASE_URL` from the individual parameters, so that the password is picked up from the `secret` file.

`UMAMI_DATABASE_PASSWORD` is set with the following code in `env`:

```
    - name: UMAMI_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: umami
          key: database_password
```        

The above for example expects a `secret` with the name `umami` to exist, with key specified as `database_password`. This would be the suggested way to add the UMAMI_DATABASE_PASSWORD. Other insecure way to add the UMAMI_DATABASE_PASSWORD is to add it like any other env variable like below:

```
  - name: UMAMI_DATABASE_PASSWORD
    value: PLEASE_CHANGE_ME
```  

### Postgres

The installs the Postgres using the following Bitnami chart: https://github.com/bitnami/charts/tree/master/bitnami/postgresql

Any changes to the Postgres instance can be customized by overriding the values for Postgres based on the above Bitnami chart.

Currently, the postgres password needs to be changed at both places. The default password created by the chart is `CHANGE_ME`:
1. In the env variable: `DATABASE_URL`
2. In the postgres chart: `postgresql.auth.postgresPassword`