# Companion Helm Chart

A Helm chart for Companion - The companion plugin can be used to upload files to Transloadit for all kinds of processing, such as transcoding video, resizing images, zipping/unzipping, and much more.

## Overview

Companion is a server integration for Uppy file uploader that handles the server-to-server communication between your server and file storage providers such as Google Drive, Dropbox, Instagram, Facebook, OneDrive and remote URLs. Companion is not a target to upload files to, but rather a proxy that handles OAuth and downloads files from third parties on your behalf, then uploads them to the final destination.

Key features:
- **OAuth Integration**: Handles OAuth flows for various cloud storage providers
- **File Processing**: Integrates with Transloadit for file processing capabilities
- **Secure Uploads**: Provides secure server-to-server file transfers
- **Multiple Providers**: Supports Dropbox, Google Drive, Instagram, Facebook, Box, OneDrive, Zoom, and more

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Valid OAuth credentials for the cloud storage providers you want to use

## Installation

### Add Helm Repository

```bash
helm repo add factly https://factly.github.io/helm-charts
helm repo update
```

### Install Chart

```bash
# Install with default values
helm install companion factly/companion

# Install with custom values
helm install companion factly/companion -f values.yaml

# Install in specific namespace
helm install companion factly/companion --namespace companion --create-namespace
```

## Uninstallation

```bash
helm uninstall companion
```

## Configuration

The following table lists the configurable parameters and their default values.

### Global Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nameOverride` | String to partially override companion.fullname | `companion` |
| `fullnameOverride` | String to fully override companion.fullname | `companion` |
| `namespaceOverride` | Override the deployment namespace | `""` |
| `imagePullSecrets` | Global Docker registry secret names as an array | `[]` |

### Image Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Companion image repository | `transloadit/companion` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Companion image tag (overrides the image tag whose default is the chart appVersion) | `""` |

### Deployment Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of Companion replicas | `1` |
| `autoscaling.enabled` | Enable horizontal pod autoscaler | `false` |
| `autoscaling.minReplicas` | Minimum number of replicas | `2` |
| `autoscaling.maxReplicas` | Maximum number of replicas | `5` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization percentage | `80` |

### Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env` | Array of environment variables for Companion configuration | See values.yaml |

#### Required Environment Variables

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `COMPANION_SECRET` | Long set of random characters for server session | `"CHANGE_ME"` |
| `COMPANION_DOMAIN` | Your server domain | `"YOUR SERVER DOMAIN"` |
| `COMPANION_DATADIR` | File path for temporary file storage | `"/"` |
| `COMPANION_PROTOCOL` | Server protocol (http/https) | `"http"` |
| `COMPANION_PORT` | Port on which to start the server | `"3020"` |
| `COMPANION_SELF_ENDPOINT` | Should be same as your domain + path | `"THIS SHOULD BE SAME AS YOUR DOMAIN + PATH"` |

#### Optional Provider Configuration

The chart supports configuration for various cloud storage providers through environment variables:

- **AWS S3**: `COMPANION_AWS_KEY`, `COMPANION_AWS_SECRET`, `COMPANION_AWS_BUCKET`, `COMPANION_AWS_REGION`

### Service Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubernetes service type | `NodePort` |
| `service.port` | Service port | `3020` |
| `service.portName` | Service port name | `http` |
| `service.annotations` | Service annotations | `{}` |
| `service.labels` | Service labels | `{}` |

### ServiceAccount Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Specifies whether a service account should be created | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.labels` | Labels to add to the service account | `{}` |
| `serviceAccount.name` | The name of the service account to use | `"companion"` |

### Ingress Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress controller resource | `false` |
| `ingress.annotations` | Ingress annotations | See values.yaml |
| `ingress.hosts` | Ingress hostnames | `["change-to-your-domain.com", "www.change-to-your-domain.com"]` |
| `ingress.paths` | Ingress paths | `["/"]` |
| `ingress.extraPaths` | Extra ingress paths | `[]` |
| `ingress.tls` | Ingress TLS configuration | See values.yaml |

### Monitoring Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `metrics.enabled` | Enable metrics collection | `false` |
| `metrics.serviceMonitor.enabled` | Enable ServiceMonitor for Prometheus | `false` |
| `metrics.serviceMonitor.selector` | ServiceMonitor selector | `{release: monitoring}` |
| `metrics.serviceMonitor.labels` | ServiceMonitor labels | `{}` |
| `metrics.serviceMonitor.interval` | Metrics scrape interval | `30s` |
| `metrics.serviceMonitor.scheme` | Metrics scrape scheme | `http` |
| `metrics.serviceMonitor.scrapeTimeout` | Metrics scrape timeout | `30s` |

### Health Check Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `readinessProbe.initialDelaySeconds` | Initial delay for readiness probe | `10` |
| `readinessProbe.timeoutSeconds` | Timeout for readiness probe | `5` |
| `readinessProbe.successThreshold` | Success threshold for readiness probe | `1` |
| `readinessProbe.failureThreshold` | Failure threshold for readiness probe | `5` |
| `readinessProbe.periodSeconds` | Period for readiness probe | `10` |
| `livenessProbe.initialDelaySeconds` | Initial delay for liveness probe | `50` |
| `livenessProbe.timeoutSeconds` | Timeout for liveness probe | `5` |
| `livenessProbe.successThreshold` | Success threshold for liveness probe | `1` |
| `livenessProbe.failureThreshold` | Failure threshold for liveness probe | `5` |
| `livenessProbe.periodSeconds` | Period for liveness probe | `10` |

### Resource Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources` | CPU/Memory resource requests/limits | `{}` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity settings for pod assignment | `{}` |
| `podAnnotations` | Annotations to add to pods | `{}` |
| `securityContext` | Security context for pods | `{}` |

## Examples

### Basic Installation with Custom Domain

```yaml
# values.yaml
env:
  - name: COMPANION_SECRET
    value: "your-super-secret-key-here"
  - name: COMPANION_DOMAIN
    value: "companion.yourdomain.com"
  - name: COMPANION_PROTOCOL
    value: "https"
  - name: COMPANION_SELF_ENDPOINT
    value: "https://companion.yourdomain.com"

ingress:
  enabled: true
  hosts:
    - companion.yourdomain.com
  tls:
    - secretName: companion-tls
      hosts:
        - companion.yourdomain.com
```

### Installation with Google Drive Support

```yaml
# values.yaml
env:
  - name: COMPANION_SECRET
    value: "your-super-secret-key-here"
  - name: COMPANION_DOMAIN
    value: "companion.yourdomain.com"
  - name: COMPANION_GOOGLE_KEY
    value: "your-google-oauth-client-id"
  - name: COMPANION_GOOGLE_SECRET
    value: "your-google-oauth-client-secret"
```

### Installation with AWS S3 Support

```yaml
# values.yaml
env:
  - name: COMPANION_AWS_KEY
    value: "your-aws-access-key"
  - name: COMPANION_AWS_SECRET
    value: "your-aws-secret-key"
  - name: COMPANION_AWS_BUCKET
    value: "your-s3-bucket-name"
  - name: COMPANION_AWS_REGION
    value: "us-east-1"
```

## Security Considerations

1. **Secret Management**: Always change the default `COMPANION_SECRET` value and use a secure random string
2. **OAuth Credentials**: Store OAuth credentials securely using Kubernetes secrets rather than plain text in values
3. **Domain Configuration**: Ensure `COMPANION_DOMAIN` and `COMPANION_SELF_ENDPOINT` match your actual deployment URL
4. **Client Origins**: Use `COMPANION_CLIENT_ORIGINS` to whitelist allowed client domains for security

## Troubleshooting

### Common Issues

1. **OAuth Redirect Mismatch**: Ensure your OAuth app redirect URLs match your Companion domain
2. **CORS Issues**: Configure `COMPANION_CLIENT_ORIGINS` to include your frontend domain
3. **File Upload Failures**: Check that `COMPANION_DATADIR` has sufficient disk space and proper permissions
4. **Provider Authentication**: Verify OAuth credentials are correctly configured for each provider

### Logs

To view Companion logs:

```bash
kubectl logs -f deployment/companion
```

## Links

- [Companion Documentation](https://uppy.io/docs/companion/)
- [Uppy File Uploader](https://uppy.io/)
- [Transloadit](https://transloadit.com/)
- [Source Code](https://github.com/transloadit/uppy/tree/main/packages/%40uppy/companion)

## License

This Helm chart is licensed under the MIT License.
