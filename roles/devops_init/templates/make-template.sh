#!/bin/bash
services=$(yq '.project.services | keys' ./scripts/services.yml | sed 's/- //g')

if [[ "$1" -eq "staging" ]]
  then 
    PROJECT_NAME=$(yq '.project.name-test' ./scripts/services.yml)
  elif [[ "$1" -eq "master" ]]
  then
    PROJECT_NAME=$(yq '.project.name-prod' ./scripts/services.yml)
  else 
    echo "Invalid argument"
    exit 1
fi

rm -rf ./vault-agent/templates/*

echo "auto_auth {
  method {
    type = \"approle\"
    mount_path = \"auth/$PROJECT_NAME\"
    config = {
      role_id_file_path = \"/vault-agent/credentials/role_id\"
      secret_id_file_path = \"/vault-agent/credentials/secret_id\"
      remove_secret_id_file_after_reading = false
    } 
  }

sink {
  type = \"file\"
  config = { path = \"/vault-agent/credentials/token\" }
  } 
}

cache {
  use_auto_auth_token = true
}

listener \"tcp\" {
  address = \"0.0.0.0:8200\"
  tls_disable = true
}

vault {
  address = \"https://vault.udevs.io\"
}" > ./vault-agent/config/vault-agent.hcl

for service in ${services[@]}
do

options=$(yq '.project.services.'$service'.options' ./scripts/services.yml | sed 's/- //g')

echo "{{- with secret \"secret/data/swarm/$PROJECT_NAME/$service\" -}}                                                                              
{{- range \$key, \$value := .Data.data }}                                                                                                            
{{ \$key }}: {{ \$value }}                                                                                                                           
{{- end }}                                                                                                                                         
{{ end -}} " >> ./vault-agent/templates/$service-template.tpl

  for option in ${options[@]}
  do

echo "{{- with secret \"secret/data/swarm/$PROJECT_NAME/$option\" -}}                                                                              
{{- range \$key, \$value := .Data.data }}                                                                                                            
{{ \$key }}: {{ \$value }}                                                                                                                           
{{- end }}                                                                                                                                         
{{ end -}} " >> ./vault-agent/templates/$service-template.tpl

  done

echo "template {
  source = \"/vault-agent/templates/$service-template.tpl\"
  destination = \"/secrets/$service.env\"
}" >> ./vault-agent/config/vault-agent.hcl

done