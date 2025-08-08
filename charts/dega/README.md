# Dega Helm Chart

A Helm chart for Dega - A lightweight, scalable & high performant CMS written in Go. Developed for modern web features with all the best practices built-in.

## Overview

Dega is a modern content management system that consists of multiple components:
- **API**: Backend API service for content management
- **Server**: Core server application 
- **Studio**: Frontend web interface for content creation and management

This Helm chart deploys all Dega components along with optional dependencies like Meilisearch for search functionality and Imgproxy for image processing.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installation

### Add Helm Repository

```bash
helm repo add factly https://factly.github.io/helm-charts
helm repo update
```

### Install Chart

```bash
# Install with default values
helm install dega factly/dega

# Install with custom values
helm install dega factly/dega -f values.yaml

# Install in specific namespace
helm install dega factly/dega --namespace dega --create-namespace
```

## Uninstallation

```bash
helm uninstall dega
```

## Configuration

The following table lists the configurable parameters and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.image.tag` | Global image tag override | `""` |
| `global.image.imagePullPolicy` | Global image pull policy | `IfNotPresent` |
| `global.securityContext` | Global security context | `{}` |
| `nameOverride` | String to partially override dega.fullname | `dega` |
| `fullnameOverride` | String to fully override dega.fullname | `dega` |
| `namespaceOverride` | Override the deployment namespace | `dega` |
| `imagePullSecrets` | Global Docker registry secret names as an array | `[]` |

### API Component

| Parameter | Description | Default |
|-----------|-------------|---------|
| `api.name` | API component name | `api` |
| `api.image.repository` | API image repository | `factly/dega-api` |
| `api.image.tag` | API image tag | `""` |
| `api.image.pullPolicy` | API image pull policy | `IfNotPresent` |
| `api.replicaCount` | Number of API replicas | `1` |
| `api.autoscaling.enabled` | Enable horizontal pod autoscaler | `false` |
| `api.autoscaling.minReplicas` | Minimum number of replicas | `1` |
| `api.autoscaling.maxReplicas` | Maximum number of replicas | `5` |
| `api.env` | Environment variables for API | `[]` |
| `api.service.type` | API service type | `ClusterIP` |
| `api.service.port` | API service port | `8000` |
| `api.ingress.enabled` | Enable ingress for API | `false` |
| `api.ingress.hosts` | API ingress hosts | `["dega-api.factly.org"]` |
| `api.resources` | API resource requests/limits | `{}` |

### Server Component

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.name` | Server component name | `server` |
| `server.image.repository` | Server image repository | `factly/dega-server` |
| `server.image.tag` | Server image tag | `""` |
| `server.image.pullPolicy` | Server image pull policy | `IfNotPresent` |
| `server.replicaCount` | Number of server replicas | `1` |
| `server.autoMigrate` | Enable automatic database migration | `false` |
| `server.createSuperOrg` | Create super organization on startup | `false` |
| `server.autoscaling.enabled` | Enable horizontal pod autoscaler | `false` |
| `server.env` | Environment variables for server | `[]` |
| `server.service.type` | Server service type | `ClusterIP` |
| `server.service.port` | Server service port | `8000` |
| `server.ingress.enabled` | Enable ingress for server | `false` |
| `server.resources` | Server resource requests/limits | `{}` |

### Studio Component

| Parameter | Description | Default |
|-----------|-------------|---------|
| `studio.name` | Studio component name | `studio` |
| `studio.image.repository` | Studio image repository | `factly/dega-studio` |
| `studio.image.tag` | Studio image tag | `""` |
| `studio.image.pullPolicy` | Studio image pull policy | `IfNotPresent` |
| `studio.replicaCount` | Number of studio replicas | `1` |
| `studio.autoscaling.enabled` | Enable horizontal pod autoscaler | `false` |
| `studio.service.type` | Studio service type | `ClusterIP` |
| `studio.service.port` | Studio service port | `80` |
| `studio.ingress.enabled` | Enable ingress for studio | `false` |
| `studio.resources` | Studio resource requests/limits | `{}` |

### Dependencies

| Parameter | Description | Default |
|-----------|-------------|---------|
| `imgproxy.enabled` | Enable Imgproxy for image processing | `false` |
| `meilisearch.enabled` | Enable Meilisearch for search functionality | `false` |
| `companion.enabled` | Enable Companion for file uploads | `false` |

## Environment Variables

### API Environment Variables

Configure the API component using environment variables:

```yaml
api:
  env:
    - name: DEGA_API_KAVACH_URL
      value: "http://kavach-server.dega.svc.cluster.local:8000"
    - name: DEGA_API_DATABASE_HOST
      value: "postgres-postgresql.dega.svc.cluster.local"
    - name: DEGA_API_DATABASE_NAME
      value: "dega"
    - name: DEGA_API_DATABASE_USER
      value: "postgres"
    - name: DEGA_API_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: dega-api
          key: database_password
```

### Server Environment Variables

Configure the server component:

```yaml
server:
  env:
    - name: DEGA_MODE
      value: "development"
    - name: DEGA_KAVACH_URL
      value: "http://kavach-server.dega.svc.cluster.local:8000"
    - name: DEGA_DATABASE_HOST
      value: "postgres-postgresql.dega.svc.cluster.local"
    - name: DEGA_DATABASE_NAME
      value: "dega"
    - name: DEGA_CREATE_SUPER_ORGANISATION
      value: "true"
    - name: DEGA_SUPER_ORGANISATION_TITLE
      value: "Super Organisation"
```

## Ingress Configuration

Enable ingress for external access:

```yaml
api:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: "letsencrypt-prod"
    hosts:
      - dega-api.example.com
    tls:
      - secretName: dega-api-tls
        hosts:
          - dega-api.example.com

server:
  ingress:
    enabled: true
    hosts:
      - dega-server.example.com
    tls:
      - secretName: dega-server-tls
        hosts:
          - dega-server.example.com

studio:
  ingress:
    enabled: true
    hosts:
      - dega.example.com
    tls:
      - secretName: dega-studio-tls
        hosts:
          - dega.example.com
```

## Monitoring

Enable Prometheus monitoring:

```yaml
api:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
      selector:
        release: monitoring

server:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
      selector:
        release: monitoring
```

## Autoscaling

Enable horizontal pod autoscaling:

```yaml
api:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 80

server:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 80

studio:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 80
```

## Resource Management

Configure resource requests and limits:

```yaml
api:
  resources:
    limits:
      cpu: 500m
      memory: 1Gi
    requests:
      cpu: 100m
      memory: 256Mi

server:
  resources:
    limits:
      cpu: 1
      memory: 2Gi
    requests:
      cpu: 200m
      memory: 512Mi

studio:
  resources:
    limits:
      cpu: 200m
      memory: 512Mi
    requests:
      cpu: 50m
      memory: 128Mi
```

## Health Checks

The chart includes configurable readiness and liveness probes:

```yaml
api:
  readinessProbe:
    initialDelaySeconds: 10
    timeoutSeconds: 5
    periodSeconds: 10
  livenessProbe:
    initialDelaySeconds: 50
    timeoutSeconds: 5
    periodSeconds: 10
```

## Security

Configure security contexts and service accounts:

```yaml
global:
  securityContext:
    runAsUser: 999
    runAsGroup: 999
    fsGroup: 999

api:
  serviceAccount:
    create: true
    annotations: {}
  securityContext:
    capabilities:
      drop:
      - ALL
    readOnlyRootFilesystem: true
    runAsNonRoot: true
    runAsUser: 1000
```

## Troubleshooting

### Common Issues

1. **Pod fails to start**: Check resource limits and node capacity
2. **Database connection issues**: Verify database credentials and connectivity
3. **Ingress not working**: Ensure ingress controller is installed and configured

### Debugging Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=dega

# View pod logs
kubectl logs -l app.kubernetes.io/name=dega -c api
kubectl logs -l app.kubernetes.io/name=dega -c server
kubectl logs -l app.kubernetes.io/name=dega -c studio

# Describe pod for events
kubectl describe pod <pod-name>

# Check services
kubectl get svc -l app.kubernetes.io/name=dega

# Check ingress
kubectl get ingress -l app.kubernetes.io/name=dega
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the changes
5. Submit a pull request

## License

This chart is licensed under the Apache License 2.0.

## Maintainers

- deshetti
- shreeharsha-factly

## Chart Information

- **Chart Version**: 0.11.12
- **App Version**: 0.15.1
- **Kubernetes Version**: 1.19+
- **Helm Version**: 3.2.0+

For more information about Dega, visit the [official documentation](https://dega.factly.org).
