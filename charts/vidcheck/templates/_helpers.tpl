{{/*
Expand the name of the chart.
*/}}
{{- define "vidcheck.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vidcheck.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vidcheck.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Global Common labels
*/}}
{{- define "vidcheck.labels" -}}
helm.sh/chart: {{ include "vidcheck.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: vidcheck
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "vidcheck.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vidcheck.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "vidcheck.namespace" -}}
    {{- .Release.Namespace -}}
{{- end -}}

{{/*
Create API name and version as used by the chart label.
*/}}
{{- define "api.fullname" -}}
{{- printf "%s-%s" (include "vidcheck.fullname" .) .Values.api.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create Server name and version as used by the chart label.
*/}}
{{- define "server.fullname" -}}
{{- printf "%s-%s" (include "vidcheck.fullname" .) .Values.server.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
server Common labels
*/}}
{{- define "server.labels" -}}
{{ include "vidcheck.labels" . }}
app.kubernetes.io/component: {{ .Values.server.name }}
app.kubernetes.io/name: {{ include "vidcheck.name" . }}-{{ .Values.server.name }}
app.kubernetes.io/version: {{ default .Values.global.image.tag .Values.server.image.tag | quote }}
{{- end }}

{{/*
server Selector labels
*/}}
{{- define "server.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "vidcheck.name" . }}-{{ .Values.server.name }}
{{- end }}

{{/*
Create the name of the service account to use for server
*/}}
{{- define "server.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "server.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create studio name and version as used by the chart label.
*/}}
{{- define "studio.fullname" -}}
{{- printf "%s-%s" (include "vidcheck.fullname" .) .Values.studio.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
studio Common labels
*/}}
{{- define "studio.labels" -}}
{{ include "vidcheck.labels" . }}
app.kubernetes.io/component: {{ .Values.studio.name }}
app.kubernetes.io/name: {{ include "vidcheck.name" . }}-{{ .Values.studio.name }}
app.kubernetes.io/version: {{ default .Values.global.image.tag .Values.studio.image.tag | quote }}
{{- end }}

{{/*
studio Selector labels
*/}}
{{- define "studio.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "vidcheck.name" . }}-{{ .Values.studio.name }}
{{- end }}

{{/*
Create the name of the service account to use for studio
*/}}
{{- define "studio.serviceAccountName" -}}
{{- if .Values.studio.serviceAccount.create }}
{{- default (include "studio.fullname" .) .Values.studio.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.studio.serviceAccount.name }}
{{- end }}
{{- end }}


