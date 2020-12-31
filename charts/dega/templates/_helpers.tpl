{{/*
Expand the name of the chart.
*/}}
{{- define "dega.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dega.fullname" -}}
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
Create API name and version as used by the chart label.
*/}}
{{- define "api.fullname" -}}
{{- printf "%s-%s" (include "dega.fullname" .) .Values.api.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dega.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Global Common labels
*/}}
{{- define "dega.labels" -}}
helm.sh/chart: {{ include "dega.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: dega
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
API Common labels
*/}}
{{- define "api.labels" -}}
{{ include "dega.labels" . }}
app.kubernetes.io/component: {{ .Values.api.name }}
app.kubernetes.io/name: {{ include "dega.name" . }}-{{ .Values.api.name }}
app.kubernetes.io/version: {{ default .Values.global.image.tag .Values.api.image.tag | quote }}
{{- end }}

{{/*
API Selector labels
*/}}
{{- define "api.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "dega.name" . }}-{{ .Values.api.name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dega.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dega.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for API
*/}}
{{- define "api.serviceAccountName" -}}
{{- if .Values.api.serviceAccount.create }}
{{- default (include "api.fullname" .) .Values.api.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.api.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "dega.namespace" -}}
    {{- .Release.Namespace -}}
{{- end -}}


