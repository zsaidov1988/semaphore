STACK=pb
prod-service-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c services/docker-compose.yml ${STACK}

prod-vault-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c services/docker-compose.vault.yml ${STACK}

prod-minio-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c minio/minio.yml ${STACK}
  
mon-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c monitoring/docker-compose.yml ${STACK}

alert-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c alert/docker-compose.yml ${STACK}

ne-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c monitoring/docker-compose.ne.yml ${STACK}

pe-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c monitoring/docker-compose.pe.yml ${STACK}

promtail-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c monitoring/docker-compose.promtail.yml ${STACK}

loki-up:
	set -a &&. ./.env && set +a && docker stack deploy --with-registry-auth -c monitoring/docker-compose.loki.yml ${STACK}
