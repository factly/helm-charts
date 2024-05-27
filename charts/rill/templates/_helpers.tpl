{{/*
Expand the name of the chart.
*/}}
{{- define "rill.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rill.fullname" -}}
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
namespace to be release namespace
*/}}
{{- define "rill.namespace" -}}
{{- .Release.Namespace -}}
{{ end }}

{{/* 
rill common labels
*/}}
{{- define "rill.labels" -}}
{{ include "rill.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Version }}
{{- with .Values.extraLabels }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/* 
rill annotations
*/}}
{{- define "rill.annotations" -}}
{{- with .Values.annotations }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/*
rill Selector labels
*/}}
{{- define "rill.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "rill.name" . }}
{{- end }}

{{/* 
rill pod labels
*/}}
{{- define "rill.PodLabels" -}}
{{ include "rill.labels" . }}
{{- with .Values.extraPodLabels }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/* 
rill pod annotations
*/}}
{{- define "rill.PodAnnotations" -}}
{{- with .Values.Podannotations }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/*
Create service account to use for rill
*/}}
{{- define "rill.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rill.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}