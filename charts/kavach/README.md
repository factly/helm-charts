# Kavach Helm Chart

A Helm chart for Kavach - A comprehensive identity and access management (IAM) platform that provides authentication, authorization, and user management services for modern applications.

## Overview

Kavach is a complete IAM solution built with modern microservices architecture. It provides:

- **Authentication**: User authentication with multiple providers and methods
- **Authorization**: Fine-grained access control with role-based permissions
- **User Management**: Complete user lifecycle management with organizations and spaces
- **Multi-tenancy**: Support for multiple organizations and applications
- **API Gateway**: Secure API access with authentication and authorization
- **File Management**: Integrated file upload and processing capabilities
- **Scalability**: Microservices architecture with horizontal scaling support

## Architecture

Kavach consists of multiple components:

- **Server**: Backend API service for authentication and user management
- **Web**: Frontend web interface for user management and administration
- **PostgreSQL**: Database for storing user data and configurations
- **Minio**: Object storage for file management
- **Imgproxy**: Image processing and optimization service
- **Kratos**: Identity management service (Ory Kratos)
- **Oathkeeper**: API gateway and proxy (Ory Oathkeeper)
- **Keto**: Authorization service (Ory Keto)
- **Companion**: File upload service for handling third-party integrations

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
helm install kavach factly/kavach

# Install with custom values
helm install kavach factly/kavach -f values.yaml

# Install in specific namespace
helm install kavach factly/kavach --namespace kavach --create-namespace
```

## Uninstallation

```bash
helm uninstall kavach
```

## Configuration

The following table lists the configurable parameters and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | String to partially override kavach.fullname | `kavach` |
| `fullnameOverride` | String to fully override kavach.fullname | `kavach` |
| `namespaceOverride` | Override the deployment namespace | `dega` |
| `imagePullSecrets` | Global Docker registry secret names as an array | `[]` |
| `global.image.tag` | Global image tag override | `""` |
| `global.image.imagePullPolicy` | Global image pull policy | `IfNotPresent` |
| `global.securityContext` | Global security context | `{}` |

### Server Component

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.name` | Server component name | `server` |
| `server.image.repository` | Server image repository | `factly/kavach-server` |
| `server.image.tag` | Server image tag | `""` |
| `server.image.pullPolicy` | Server image pull policy | `IfNotPresent` |
| `server.replicaCount` | Number of server replicas | `1` |
| `server.autoscaling.enabled` | Enable horizontal pod autoscaler for server | `false` |
| `server.autoscaling.minReplicas` | Minimum number of server replicas | `1` |
| `server.autoscaling.maxReplicas` | Maximum number of server replicas | `5` |
| `server.autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage | `80` |
| `server.autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization percentage | `80` |
| `server.autoMigrate` | Enable automatic database migration | `false` |
| `server.createSuperOrg` | Create super organization on startup | `false` |
| `server.env` | Environment variables for server | `[]` |
| `server.defaultApplications` | Default applications configuration | `""` |

#### Server Environment Variables

| Environment Variable | Description | Example |
|---------------------|-------------|---------|
| `KAVACH_IMAGEPROXY_URL` | Image proxy URL for image processing | `"https://images.factly.org"` |
| `KAVACH_MODE` | Application mode | `"development"` or `"production"` |
| `KAVACH_KETO_URL` | Keto authorization service URL | `"http://keto.dega.svc.cluster.local:4466"` |
| `KAVACH_DATABASE_HOST` | Database host | `"kavach-postgresql.dega.svc.cluster.local"` |
| `KAVACH_DATABASE_NAME` | Database name | `"kavach"` |
| `KAVACH_DATABASE_PORT` | Database port | `"5432"` |
| `KAVACH_DATABASE_USER` | Database username | `"postgres"` |
| `KAVACH_DATABASE_PASSWORD` | Database password | From secret |
| `KAVACH_DATABASE_SSL_MODE` | Database SSL mode | `"disable"` |
| `KAVACH_SENDGRID_API_KEY` | SendGrid API key for email | From secret |
| `KAVACH_DOMAIN_NAME` | Domain name for the application | `"https://kavach.factly.org"` |

### Server Service Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.service.type` | Server service type | `ClusterIP` |
| `server.service.port` | Server service port | `8000` |
| `server.service.portName` | Server service port name | `http` |
| `server.service.annotations` | Server service annotations | `{}` |
| `server.service.labels` | Server service labels | `{}` |

### Server ServiceAccount Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.serviceAccount.create` | Create service account for server | `false` |
| `server.serviceAccount.annotations` | Server service account annotations | `{}` |
| `server.serviceAccount.labels` | Server service account labels | `{}` |
| `server.serviceAccount.name` | Server service account name | `"kavach-server"` |

### Server Monitoring Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.metrics.enabled` | Enable metrics collection for server | `false` |
| `server.metrics.service.type` | Metrics service type | `ClusterIP` |
| `server.metrics.service.port` | Metrics service port | `8001` |
| `server.metrics.serviceMonitor.enabled` | Enable ServiceMonitor for Prometheus | `false` |
| `server.metrics.serviceMonitor.selector` | ServiceMonitor selector | `{release: monitoring}` |
| `server.metrics.serviceMonitor.interval` | Metrics scrape interval | `30s` |

### Web Component

| Parameter | Description | Default |
|-----------|-------------|---------|
| `web.name` | Web component name | `web` |
| `web.image.repository` | Web image repository | `factly/kavach-web` |
| `web.image.tag` | Web image tag | `""` |
| `web.image.pullPolicy` | Web image pull policy | `IfNotPresent` |
| `web.replicaCount` | Number of web replicas | `1` |
| `web.autoscaling.enabled` | Enable horizontal pod autoscaler for web | `false` |
| `web.autoscaling.minReplicas` | Minimum number of web replicas | `1` |
| `web.autoscaling.maxReplicas` | Maximum number of web replicas | `5` |
| `web.autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage | `80` |
| `web.autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization percentage | `80` |
| `web.env` | Environment variables for web | `[]` |

### Web Service Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `web.service.type` | Web service type | `NodePort` |
| `web.service.port` | Web service port | `80` |
| `web.service.portName` | Web service port name | `http` |
| `web.service.annotations` | Web service annotations | `{}` |
| `web.service.labels` | Web service labels | `{}` |

### Web ServiceAccount Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `web.serviceAccount.create` | Create service account for web | `false` |
| `web.serviceAccount.annotations` | Web service account annotations | `{}` |
| `web.serviceAccount.labels` | Web service account labels | `{}` |
| `web.serviceAccount.name` | Web service account name | `"kavach-web"` |

### Health Check Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.readinessProbe.initialDelaySeconds` | Server readiness probe initial delay | `10` |
| `server.readinessProbe.timeoutSeconds` | Server readiness probe timeout | `5` |
| `server.readinessProbe.successThreshold` | Server readiness probe success threshold | `1` |
| `server.readinessProbe.failureThreshold` | Server readiness probe failure threshold | `5` |
| `server.readinessProbe.periodSeconds` | Server readiness probe period | `10` |
| `server.livenessProbe.initialDelaySeconds` | Server liveness probe initial delay | `50` |
| `server.livenessProbe.timeoutSeconds` | Server liveness probe timeout | `5` |
| `server.livenessProbe.successThreshold` | Server liveness probe success threshold | `1` |
| `server.livenessProbe.failureThreshold` | Server liveness probe failure threshold | `5` |
| `server.livenessProbe.periodSeconds` | Server liveness probe period | `10` |
| `web.readinessProbe.*` | Web readiness probe parameters | Same as server |
| `web.livenessProbe.*` | Web liveness probe parameters | Same as server |

### Resource Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.resources` | Server CPU/Memory resource requests/limits | `{}` |
| `web.resources` | Web CPU/Memory resource requests/limits | `{}` |
| `server.nodeSelector` | Server node labels for pod assignment | `{}` |
| `server.tolerations` | Server tolerations for pod assignment | `[]` |
| `server.affinity` | Server affinity settings for pod assignment | `{}` |
| `web.nodeSelector` | Web node labels for pod assignment | `{}` |
| `web.tolerations` | Web tolerations for pod assignment | `[]` |
| `web.affinity` | Web affinity settings for pod assignment | `{}` |
| `server.podAnnotations` | Server pod annotations | `{}` |
| `web.podAnnotations` | Web pod annotations | `{}` |
| `server.securityContext` | Server security context | `{}` |
| `web.securityContext` | Web security context | `{}` |

### Dependencies

#### PostgreSQL

| Parameter | Description | Default |
|-----------|-------------|---------|
| `postgresql.enabled` | Enable PostgreSQL dependency | `false` |
| `postgresql.image.registry` | PostgreSQL image registry | `docker.io` |
| `postgresql.image.repository` | PostgreSQL image repository | `bitnami/postgresql` |
| `postgresql.image.tag` | PostgreSQL image tag | `14.2.0-debian-10-r33` |
| `postgresql.auth.enablePostgresUser` | Enable postgres admin user | `true` |
| `postgresql.auth.postgresPassword` | PostgreSQL postgres user password | `"postgres"` |
| `postgresql.auth.username` | PostgreSQL custom username | `""` |
| `postgresql.auth.password` | PostgreSQL custom user password | `""` |
| `postgresql.auth.database` | PostgreSQL custom database | `""` |
| `postgresql.architecture` | PostgreSQL architecture | `standalone` |
| `postgresql.primary.resources.requests.memory` | PostgreSQL memory request | `256Mi` |
| `postgresql.primary.resources.requests.cpu` | PostgreSQL CPU request | `250m` |

#### Minio

| Parameter | Description | Default |
|-----------|-------------|---------|
| `minio.enabled` | Enable Minio dependency | `false` |
| `minio.mode` | Minio server mode | `distributed` |
| `minio.replicas` | Number of Minio containers | `4` |
| `minio.zones` | Number of expanded Minio clusters | `1` |
| `minio.persistence.enabled` | Enable Minio persistence | `true` |
| `minio.auth.rootUser` | Minio root username | `admin` |
| `minio.auth.rootPassword` | Minio root password | `password` |

#### Imgproxy

| Parameter | Description | Default |
|-----------|-------------|---------|
| `imgproxy.enabled` | Enable Imgproxy dependency | `false` |

#### Kratos (Identity Management)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `kratos.enabled` | Enable Kratos dependency | `false` |
| `kratos.kratos.automigration.enabled` | Enable Kratos auto-migration | `true` |
| `kratos.kratos.config.dsn` | Kratos database connection string | PostgreSQL connection |

#### Oathkeeper (API Gateway)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `oathkeeper.enabled` | Enable Oathkeeper dependency | `false` |
| `oathkeeper.oathkeeper.config.serve.proxy.port` | Oathkeeper proxy port | `4455` |
| `oathkeeper.oathkeeper.config.serve.api.port` | Oathkeeper API port | `4456` |

#### Keto (Authorization)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `keto.enabled` | Enable Keto dependency | `false` |
| `keto.keto.automigration.enabled` | Enable Keto auto-migration | `true` |
| `keto.keto.config.serve.read.port` | Keto read API port | `4466` |
| `keto.keto.config.serve.write.port` | Keto write API port | `4467` |
| `keto.keto.config.serve.metrics.port` | Keto metrics port | `4468` |
| `keto.keto.config.dsn` | Keto database connection string | PostgreSQL connection |

#### Companion (File Upload)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `companion.enabled` | Enable Companion dependency | `false` |

## Examples

### Basic Installation

```yaml
# values.yaml
server:
  env:
    - name: KAVACH_MODE
      value: "production"
    - name: KAVACH_DATABASE_HOST
      value: "my-postgresql.default.svc.cluster.local"
    - name: KAVACH_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: kavach-secrets
          key: database_password

postgresql:
  enabled: true
  auth:
    postgresPassword: "secure-postgres-password"
```

### Complete Installation with All Dependencies

```yaml
# values.yaml
server:
  autoMigrate: true
  createSuperOrg: true
  env:
    - name: KAVACH_MODE
      value: "production"
    - name: KAVACH_IMAGEPROXY_URL
      value: "http://kavach-imgproxy:8080"
    - name: KAVACH_KETO_URL
      value: "http://kavach-keto:4466"
    - name: KAVACH_DATABASE_HOST
      value: "kavach-postgresql"
    - name: KAVACH_DATABASE_NAME
      value: "kavach"
    - name: KAVACH_DATABASE_USER
      value: "postgres"
    - name: KAVACH_DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: kavach-postgresql
          key: postgres-password

postgresql:
  enabled: true
  auth:
    postgresPassword: "secure-postgres-password"

minio:
  enabled: true
  auth:
    rootUser: "admin"
    rootPassword: "secure-minio-password"

imgproxy:
  enabled: true

kratos:
  enabled: true
  kratos:
    config:
      dsn: "postgres://postgres:secure-postgres-password@kavach-postgresql:5432/kratos"

oathkeeper:
  enabled: true

keto:
  enabled: true
  keto:
    config:
      dsn: "postgres://postgres:secure-postgres-password@kavach-postgresql:5432/keto"

companion:
  enabled: true
```

### Production Installation with Ingress

```yaml
# values.yaml
server:
  ingress:
    enabled: true
    hosts:
      - host: api.kavach.mydomain.com
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls:
      - secretName: kavach-api-tls
        hosts:
          - api.kavach.mydomain.com

web:
  ingress:
    enabled: true
    hosts:
      - host: kavach.mydomain.com
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls:
      - secretName: kavach-web-tls
        hosts:
          - kavach.mydomain.com

server:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10

web:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 5
```

## Security Considerations

1. **Database Security**: Always change default PostgreSQL passwords and use strong passwords
2. **Minio Security**: Configure secure access keys for Minio object storage
3. **Secret Management**: Store sensitive configuration in Kubernetes secrets rather than plain text
4. **Network Policies**: Implement network policies to restrict inter-service communication
5. **TLS/SSL**: Enable TLS for all external-facing services
6. **RBAC**: Configure proper role-based access control for Kubernetes resources

## Troubleshooting

### Common Issues

1. **Database Connection Issues**: Ensure PostgreSQL is accessible and credentials are correct
2. **Migration Failures**: Check database permissions and migration logs
3. **Service Discovery**: Verify service names and namespaces are correctly configured
4. **Authentication Issues**: Check Kratos configuration and database connectivity
5. **Authorization Issues**: Verify Keto policies and database setup

### Logs

To view application logs:

```bash
# Server logs
kubectl logs -f deployment/kavach-server

# Web logs
kubectl logs -f deployment/kavach-web

# Database logs
kubectl logs -f statefulset/kavach-postgresql

# Kratos logs (if enabled)
kubectl logs -f deployment/kavach-kratos

# Keto logs (if enabled)
kubectl logs -f deployment/kavach-keto
```

### Health Checks

The application exposes health check endpoints:

- Server health: `http://kavach-server:8000/health`
- Metrics: `http://kavach-server:8001/metrics` (if enabled)
- Kratos health: `http://kavach-kratos:4433/health/ready` (if enabled)
- Keto health: `http://kavach-keto:4468/health/ready` (if enabled)

## Migration and Upgrades

### Database Migrations

Kavach supports automatic database migrations:

```yaml
server:
  autoMigrate: true
```

### Upgrading

When upgrading Kavach:

1. Backup your database
2. Review the changelog for breaking changes
3. Update your values.yaml file
4. Run the upgrade command:

```bash
helm upgrade kavach factly/kavach -f values.yaml
```

## Links

- [Kavach Repository](https://github.com/factly/kavach)
- [Ory Kratos Documentation](https://www.ory.sh/kratos/docs/)
- [Ory Oathkeeper Documentation](https://www.ory.sh/oathkeeper/docs/)
- [Ory Keto Documentation](https://www.ory.sh/keto/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Minio Documentation](https://docs.min.io/)

## License

This Helm chart is licensed under the MIT License.
