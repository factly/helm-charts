{{- define "rill.pod" -}}
{{- $root := . -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
serviceAccountName: {{ include "rill.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
containers:
  - name: {{ .Chart.Name }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    ports:
      - name: {{ .Values.service.portName }}
        containerPort: {{ .Values.service.portNumber }}
        protocol: TCP
    livenessProbe:
      {{- toYaml .Values.livenessProbe | nindent 6 }}
    readinessProbe:
      {{- toYaml .Values.readinessProbe | nindent 6 }}
    {{- if .Values.env }}
    {{- with .Values.env }}
    env:
    {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- end }}
    resources:
      {{- toYaml .Values.resources | nindent 6 }}
    volumeMounts:
      - name: storage
        mountPath: "/home/rill/dataful"
        {{- with .Values.persistence.subPath }}
        subPath: {{ tpl . $root }}
        readOnly: false
        {{- end }}
      {{- range .Values.extraVolumeMounts }}
      - name: {{ .name }}
        mountPath: {{ .mountPath }}
        subPath: {{ .subPath | default "" }}
        readOnly: {{ .readOnly }}
      {{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
volumes:
  {{- if and .Values.persistence.enabled (eq .Values.persistence.type "pvc") }}
  - name: storage
    persistentVolumeClaim:
      claimName: {{ tpl (.Values.persistence.existingClaim | default (include "rill.fullname" .)) . }}
  {{- else }}
  - name: storage
    {{- if .Values.persistence.inMemory.enabled }}
    emptyDir:
      medium: Memory
      {{- with .Values.persistence.inMemory.sizeLimit }}
      sizeLimit: {{ . }}
      {{- end }}
    {{- else }}
    emptyDir: {}
    {{- end }}
  {{- end }}
  {{- range .Values.extraVolumes }}
  - name: {{ .name }}
    {{- if .existingClaim }}
    persistentVolumeClaim:
      claimName: {{ .existingClaim }}
    {{- else if .hostPath }}
    hostPath:
      {{ toYaml .hostPath }}
    {{- else if .csi }}
    csi:
      {{- toYaml .csi }}
    {{- else if .configMap }}
    configMap:
      {{- toYaml .configMap }}
    {{- else if .secret }}
    secret:
      {{- toYaml .secret }}
    {{- else if .emptyDir }}
    emptyDir:
      {{- toYaml .emptyDir }}
    {{- else }}
    emptyDir: {}
    {{- end }}
  {{- end }}
{{- end }}