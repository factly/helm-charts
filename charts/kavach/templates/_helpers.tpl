{{/*
Expand the name of the chart.
*/}}
{{- define "kavach.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kavach.fullname" -}}
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
{{- define "kavach.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Global Common labels
*/}}
{{- define "kavach.labels" -}}
helm.sh/chart: {{ include "kavach.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: kavach
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kavach.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kavach.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "kavach.namespace" -}}
    {{- .Release.Namespace -}}
{{- end -}}

{{/*
Create API name and version as used by the chart label.
*/}}
{{- define "api.fullname" -}}
{{- printf "%s-%s" (include "kavach.fullname" .) .Values.api.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
API Common labels
*/}}
{{- define "api.labels" -}}
{{ include "kavach.labels" . }}
app.kubernetes.io/component: {{ .Values.api.name }}
app.kubernetes.io/name: {{ include "kavach.name" . }}-{{ .Values.api.name }}
app.kubernetes.io/version: {{ default .Values.global.image.tag .Values.api.image.tag | quote }}
{{- end }}

{{/*
API Selector labels
*/}}
{{- define "api.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "kavach.name" . }}-{{ .Values.api.name }}
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
Create Server name and version as used by the chart label.
*/}}
{{- define "server.fullname" -}}
{{- printf "%s-%s" (include "kavach.fullname" .) .Values.server.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
server Common labels
*/}}
{{- define "server.labels" -}}
{{ include "kavach.labels" . }}
app.kubernetes.io/component: {{ .Values.server.name }}
app.kubernetes.io/name: {{ include "kavach.name" . }}-{{ .Values.server.name }}
app.kubernetes.io/version: {{ default .Values.global.image.tag .Values.server.image.tag | quote }}
{{- end }}

{{/*
server Selector labels
*/}}
{{- define "server.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "kavach.name" . }}-{{ .Values.server.name }}
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
Create web name and version as used by the chart label.
*/}}
{{- define "web.fullname" -}}
{{- printf "%s-%s" (include "dega.fullname" .) .Values.web.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
web Common labels
*/}}
{{- define "web.labels" -}}
{{ include "dega.labels" . }}
app.kubernetes.io/component: {{ .Values.web.name }}
app.kubernetes.io/name: {{ include "dega.name" . }}-{{ .Values.web.name }}
app.kubernetes.io/version: {{ default .Values.global.image.tag .Values.web.image.tag | quote }}
{{- end }}

{{/*
web Selector labels
*/}}
{{- define "web.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "dega.name" . }}-{{ .Values.web.name }}
{{- end }}

{{/*
Create the name of the service account to use for web
*/}}
{{- define "web.serviceAccountName" -}}
{{- if .Values.web.serviceAccount.create }}
{{- default (include "web.fullname" .) .Values.web.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.web.serviceAccount.name }}
{{- end }}
{{- end }}


