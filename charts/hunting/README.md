# Hunting Helm Chart

A Helm chart for Hunting Server - A data processing and analysis platform that provides APIs for data manipulation, transformation, and machine learning workflows.

## Overview

Hunting Server is a FastAPI-based application designed for data processing and analysis tasks. It provides a comprehensive platform for:

- **Data Processing**: Handle various data formats and transformations
- **API Services**: RESTful APIs for data manipulation and analysis
- **Task Management**: Celery-based distributed task processing with Redis broker
- **Monitoring**: Flower integration for task monitoring and management
- **Database Integration**: MongoDB support for data persistence
- **Scalability**: Horizontal pod autoscaling and worker management

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled for dependencies)

## Installation

### Add Helm Repository

```bash
helm repo add factly https://factly.github.io/helm-charts
helm repo update
```

### Install Chart

```bash
# Install with default values
helm install hunting factly/hunting

# Install with custom values
helm install hunting factly/hunting -f values.yaml

# Install in specific namespace
helm install hunting factly/hunting --namespace hunting --create-namespace
```

## Uninstallation

```bash
helm uninstall hunting
```

## Configuration

The following table lists the configurable parameters and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | String to partially override hunting.fullname | `""` |
| `fullnameOverride` | String to fully override hunting.fullname | `""` |
| `imagePullSecrets` | Global Docker registry secret names as an array | `[]` |

### Image Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Hunting image repository | `factly/hunting` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Hunting image tag (overrides the image tag whose default is the chart appVersion) | `""` |

### Deployment Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of Hunting replicas | `1` |
| `autoscaling.enabled` | Enable horizontal pod autoscaler | `false` |
| `autoscaling.minReplicas` | Minimum number of replicas | `2` |
| `autoscaling.maxReplicas` | Maximum number of replicas | `10` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization percentage | `80` |

### Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env` | Array of environment variables for Hunting configuration | See values.yaml |

#### Core Environment Variables

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `PROJECT_NAME` | Project name for the application | `"Hunting Server"` |
| `API_V1_STR` | API version string prefix | `"/api/v1"` |
| `MODE` | Application mode | `"production"` |
| `EXAMPLE_URL` | Example dataset URL for testing | `"https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv"` |

#### Database Configuration

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `MONGODB_HOST` | MongoDB host address | `"hunting-mongodb.default.svc.cluster.local"` |
| `MONGODB_PORT` | MongoDB port | `"27017"` |
| `MONGODB_DATABASE` | MongoDB database name | `"hunting"` |
| `MONGODB_USER` | MongoDB username | `"root"` |
| `MONGODB_PASSWORD` | MongoDB password | `"password"` |

#### Optional S3 Configuration

The chart supports S3 storage configuration through environment variables (commented by default):

- `S3_ENDPOINT`: S3 endpoint URL
- `S3_BUCKET`: S3 bucket name
- `S3_KEY`: S3 access key
- `S3_SECRET`: S3 secret key
- `S3_SECURE`: Enable secure S3 connection
- `S3_ENDPOINT_TARGET`: Target S3 endpoint for data transfer
- `S3_BUCKET_TARGET`: Target S3 bucket
- `S3_KEY_TARGET`: Target S3 access key
- `S3_SECRET_TARGET`: Target S3 secret key
- `S3_SECURE_TARGET`: Enable secure connection for target S3

### Service Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `8000` |
| `service.additionalLabels` | Additional labels for service | `{}` |

### ServiceAccount Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.name` | The name of the service account to use | `"hunting"` |

### Ingress Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress controller resource | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress hostnames | `[{host: "chart-example.local", paths: [{path: "/", pathType: "ImplementationSpecific"}]}]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### Worker Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `worker.enabled` | Enable Celery worker deployment | `false` |
| `worker.replicaCount` | Number of worker replicas | `1` |
| `worker.autoscaling.enabled` | Enable worker autoscaling | `false` |
| `worker.autoscaling.minReplicas` | Minimum worker replicas | `2` |
| `worker.autoscaling.maxReplicas` | Maximum worker replicas | `10` |
| `worker.autoscaling.targetCPUUtilizationPercentage` | Worker target CPU utilization | `80` |
| `worker.autoscaling.targetMemoryUtilizationPercentage` | Worker target memory utilization | `80` |
| `worker.resources.limits.cpu` | Worker CPU limit | `1` |
| `worker.resources.limits.memory` | Worker memory limit | `4096Mi` |
| `worker.resources.requests.cpu` | Worker CPU request | `100m` |
| `worker.resources.requests.memory` | Worker memory request | `128Mi` |

### Flower Configuration (Task Monitoring)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `flower.enabled` | Enable Flower for task monitoring | `false` |
| `flower.replicaCount` | Number of Flower replicas | `1` |
| `flower.autoscaling.enabled` | Enable Flower autoscaling | `false` |
| `flower.env` | Environment variables for Flower | `[]` |
| `flower.service.type` | Flower service type | `ClusterIP` |
| `flower.service.port` | Flower service port | `5555` |
| `flower.resources.limits.cpu` | Flower CPU limit | `0.5` |
| `flower.resources.limits.memory` | Flower memory limit | `2Gi` |
| `flower.resources.requests.cpu` | Flower CPU request | `25m` |
| `flower.resources.requests.memory` | Flower memory request | `100Mi` |
| `flower.ingress.enabled` | Enable Flower ingress | `false` |
| `flower.ingress.hosts` | Flower ingress hosts | `[{host: "chart-example.local", paths: [{path: "/", pathType: "ImplementationSpecific"}]}]` |

### Resource Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.limits.cpu` | CPU limit | `1` |
| `resources.limits.memory` | Memory limit | `2048Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `128Mi` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity settings for pod assignment | `{}` |
| `podAnnotations` | Annotations to add to pods | `{}` |
| `podSecurityContext` | Security context for pods | `{}` |
| `securityContext` | Security context for containers | `{}` |

### Dependencies

#### MongoDB

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mongodb.enabled` | Enable MongoDB dependency | `false` |
| `mongodb.auth.enabled` | Enable MongoDB authentication | `true` |
| `mongodb.auth.rootPassword` | MongoDB root password | `"password"` |

#### Redis

| Parameter | Description | Default |
|-----------|-------------|---------|
| `redis.enabled` | Enable Redis dependency | `false` |
| `redis.architecture` | Redis architecture | `"standalone"` |
| `redis.auth.password` | Redis authentication password | `"password"` |

## Examples

### Basic Installation

```yaml
# values.yaml
env:
  - name: PROJECT_NAME
    value: "My Hunting Server"
  - name: MONGODB_HOST
    value: "my-mongodb.default.svc.cluster.local"
  - name: MONGODB_PASSWORD
    value: "my-secure-password"

ingress:
  enabled: true
  hosts:
    - host: hunting.mydomain.com
      paths:
        - path: /
          pathType: ImplementationSpecific
```

### Installation with MongoDB and Redis Dependencies

```yaml
# values.yaml
mongodb:
  enabled: true
  auth:
    enabled: true
    rootPassword: "secure-mongo-password"

redis:
  enabled: true
  auth:
    password: "secure-redis-password"

env:
  - name: MONGODB_PASSWORD
    value: "secure-mongo-password"
```

### Installation with Worker and Flower

```yaml
# values.yaml
worker:
  enabled: true
  replicaCount: 3
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10

flower:
  enabled: true
  ingress:
    enabled: true
    hosts:
      - host: flower.mydomain.com
        paths:
          - path: /
            pathType: ImplementationSpecific

redis:
  enabled: true
  auth:
    password: "redis-password"
```

### Installation with S3 Configuration

```yaml
# values.yaml
env:
  - name: S3_ENDPOINT
    value: "s3.amazonaws.com"
  - name: S3_BUCKET
    value: "my-hunting-bucket"
  - name: S3_KEY
    value: "AKIAIOSFODNN7EXAMPLE"
  - name: S3_SECRET
    value: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  - name: S3_SECURE
    value: "True"
```

## Architecture

The Hunting chart can deploy the following components:

1. **Main Application**: FastAPI-based server handling HTTP requests
2. **Celery Workers**: Distributed task processing (optional)
3. **Flower**: Web-based tool for monitoring Celery tasks (optional)
4. **MongoDB**: Document database for data persistence (optional dependency)
5. **Redis**: In-memory data store used as Celery broker (optional dependency)

## Security Considerations

1. **Database Passwords**: Always change default passwords for MongoDB and Redis
2. **S3 Credentials**: Store S3 credentials securely using Kubernetes secrets
3. **Service Account**: The chart creates a dedicated service account for the application
4. **Network Policies**: Consider implementing network policies to restrict inter-pod communication

## Troubleshooting

### Common Issues

1. **MongoDB Connection Issues**: Ensure MongoDB is accessible and credentials are correct
2. **Redis Connection Issues**: Verify Redis is running and authentication is properly configured
3. **Worker Tasks Not Processing**: Check Redis connectivity and worker logs
4. **S3 Upload Failures**: Verify S3 credentials and bucket permissions

### Logs

To view application logs:

```bash
# Main application logs
kubectl logs -f deployment/hunting

# Worker logs (if enabled)
kubectl logs -f deployment/hunting-celery

# Flower logs (if enabled)
kubectl logs -f deployment/hunting-flower
```

### Health Checks

The application exposes health check endpoints that can be used for monitoring:

- Main application health: `http://hunting:8000/health`
- Flower monitoring: `http://hunting-flower:5555` (if enabled)

## Links

- [Hunting Server Repository](https://github.com/factly/hunting)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Celery Documentation](https://docs.celeryproject.org/)
- [Flower Documentation](https://flower.readthedocs.io/)

## License

This Helm chart is licensed under the MIT License.
