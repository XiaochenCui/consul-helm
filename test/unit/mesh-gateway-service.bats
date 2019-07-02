#!/usr/bin/env bats

load _helpers

@test "meshGateway/Service: disabled by default" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "meshGateway/Service: disabled with meshGateway.enabled=true" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "false" ]
}

@test "meshGateway/Service: enabled with meshGateway.enabled=true meshGateway.service.enabled" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      . | tee /dev/stderr |
      yq 'length > 0' | tee /dev/stderr)
  [ "${actual}" = "true" ]
}

@test "meshGateway/Service: can set annotations" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      --set 'meshGateway.service.annotations=key: value' \
      . | tee /dev/stderr |
      yq -r '.metadata.annotations.key' | tee /dev/stderr)
  [ "${actual}" = "value" ]
}

@test "meshGateway/Service: has default port" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      . | tee /dev/stderr |
      yq -r '.spec.ports[0].port' | tee /dev/stderr)
  [ "${actual}" = "443" ]
}

@test "meshGateway/Service: can set port" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      --set 'meshGateway.service.port=8443' \
      . | tee /dev/stderr |
      yq -r '.spec.ports[0].port' | tee /dev/stderr)
  [ "${actual}" = "8443" ]
}

@test "meshGateway/Service: has default targetPort" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      . | tee /dev/stderr |
      yq -r '.spec.ports[0].targetPort' | tee /dev/stderr)
  [ "${actual}" = "443" ]
}

@test "meshGateway/Service: uses targetPort from containerPort" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      --set 'meshGateway.containerPort=8443' \
      . | tee /dev/stderr |
      yq -r '.spec.ports[0].targetPort' | tee /dev/stderr)
  [ "${actual}" = "8443" ]
}

@test "meshGateway/Service: defaults to type ClusterIP" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      . | tee /dev/stderr |
      yq -r '.spec.type' | tee /dev/stderr)
  [ "${actual}" = "ClusterIP" ]
}

@test "meshGateway/Service: can set type" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      --set 'meshGateway.service.type=LoadBalancer' \
      . | tee /dev/stderr |
      yq -r '.spec.type' | tee /dev/stderr)
  [ "${actual}" = "LoadBalancer" ]
}

@test "meshGateway/Service: can add additionalSpec" {
  cd `chart_dir`
  local actual=$(helm template \
      -x templates/mesh-gateway-service.yaml  \
      --set 'meshGateway.enabled=true' \
      --set 'meshGateway.service.enabled=true' \
      --set 'meshGateway.service.additionalSpec=key: value' \
      . | tee /dev/stderr |
      yq -r '.spec.key' | tee /dev/stderr)
  [ "${actual}" = "value" ]
}
