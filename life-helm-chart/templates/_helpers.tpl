{{- define "myservice" -}}
{{- range $k, $v := $.Values.myservice }}

{{ if $v.deployment.enabled }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "{{ $k | replace "_" "-" }}-deployment"
spec:
  replicas: {{ $v.deployment.replicas }}
  selector:
    matchLabels:
      app: {{ $k | replace "_" "-" }}
  template:
    metadata:
      labels:
        app: {{ $k | replace "_" "-" }}
    spec:
      containers:
        - name: {{ $k | replace "_" "-" }}
          image: "{{ $v.deployment.image }}:{{ $v.deployment.tag }}"
          imagePullPolicy: {{ $v.deployment.imagePullPolicy }}
          ports:
          {{ toYaml $v.deployment.ports | indent 12 }}
          env:
          {{ toYaml $v.deployment.env | indent 12 }}
      {{- end }}
{{- end }}

{{ if $v.service.enabled }}
---
apiVersion: v1
kind: Service
metadata:
  name: "{{ $k | replace "_" "-" }}-svc"
spec:
  ports:
{{ toYaml $v.service.ports | indent 4 }}
  selector:
    app: {{ $k | replace "_" "-" }}

{{- end }}
{{- end }}
{{- end }}
