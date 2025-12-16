{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "opa.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opa.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "opa.sarfullname" -}}
{{- $name := (include "opa.fullname" . | trunc 59 | trimSuffix "-") -}}
{{- printf "%s-sar" $name -}}
{{- end -}}

{{- define "opa.mgmtfullname" -}}
{{- $name := (include "opa.fullname" . | trunc 58 | trimSuffix "-") -}}
{{- printf "%s-mgmt" $name -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "opa.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "opa.labels" -}}
{{/* helm.sh/chart: {{ include "opa.chart" . }} */}}
{{ include "opa.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opa.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "opa.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "opa.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "opa.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "opa.fullname" .) }}
{{- end -}}

{{- define "opa.rootCAIssuer" -}}
{{ printf "%s-ca" (include "opa.fullname" .) }}
{{- end -}}

{{- define "opa.rootCACertificate" -}}
{{ printf "%s-ca" (include "opa.fullname" .) }}
{{- end -}}

{{- define "opa.servingCertificate" -}}
{{ printf "%s-webhook-tls" (include "opa.fullname" .) }}
{{- end -}}

{{/*
Detect the available version of admissionregistration
*/}}
{{- define "opa.admissionregistrationApiVersion" -}}
{{- if (.Capabilities.APIVersions.Has "admissionregistration.k8s.io/v1") -}}
admissionregistration.k8s.io/v1
{{- else  -}}
admissionregistration.k8s.io/v1beta1
{{- end -}}
{{- end -}}

{{- define "opa.mgmt.image" -}}
{{- $tag := .Values.mgmt.image.tag | default .Chart.AppVersion -}}
{{ printf "%s:%s" .Values.mgmt.image.repository $tag }}
{{- end -}}

{{- define "opa.dnsPolicy" -}}
{{- if .Values.dnsPolicyOverride -}}
dnsPolicy: "{{ .Values.dnsPolicyOverride }}"
{{ end -}}
{{ end -}}
