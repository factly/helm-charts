{{/*
Expand the name of the chart.
*/}}
{{- define "ruspie.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ruspie.fullname" -}}
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
{{- define "ruspie.namespace" -}}
{{- .Release.Namespace -}}
{{ end }}

{{/* 
ruspie common labels
*/}}
{{- define "ruspie.labels" -}}
{{ include "ruspie.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Version }}
{{- with .Values.extraLabels }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/* 
ruspie annotations
*/}}
{{- define "ruspie.annotations" -}}
{{- with .Values.annotations }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/*
ruspie Selector labels
*/}}
{{- define "ruspie.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "ruspie.name" . }}
{{- end }}

{{/* 
ruspie pod labels
*/}}
{{- define "ruspie.PodLabels" -}}
{{ include "ruspie.labels" . }}
{{- with .Values.extraPodLabels }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/* 
ruspie pod annotations
*/}}
{{- define "ruspie.PodAnnotations" -}}
{{- with .Values.Podannotations }}
{{ toYaml . }}
{{ end }}
{{ end }}

{{/*
Create service account to use for ruspie
*/}}
{{- define "ruspie.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ruspie.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}