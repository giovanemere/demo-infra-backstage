#!/bin/bash

echo "🎭 Iniciando Backstage Infrastructure AI Platform..."

cd /home/giovanemere/demos/backstage-idp/infra-ai-backstage

# Cargar variables de entorno
if [ -f .env ]; then
    echo "📋 Cargando variables de entorno..."
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "⚠️  Archivo .env no encontrado, usando valores por defecto"
    # Valores por defecto si no existe .env
    export POSTGRES_HOST=localhost
    export POSTGRES_PORT=5432
    export POSTGRES_USER=backstage
    export POSTGRES_PASSWORD=backstage123
    export POSTGRES_DB=backstage
    export GITHUB_TOKEN=your_github_token_here
    export GITHUB_ORG=giovanemere
    export GITHUB_REPO=demo-infra-ai-agent-template-idp
    export GITHUB_BRANCH=main
    export CATALOG_PATH=/catalog-info.yaml
    export BACKEND_SECRET=infra-ai-platform-secret-key
    export BACKEND_BASE_URL=http://localhost:7007
    export APP_BASE_URL=http://localhost:3000
    export CATALOG_SYNC_FREQUENCY=5
    export CATALOG_SYNC_TIMEOUT=3
fi

# Verificar dependencias críticas
echo "🔍 Verificando dependencias..."
if ! yarn list @backstage/plugin-catalog-backend-module-github > /dev/null 2>&1; then
    echo "📦 Instalando módulo GitHub para catálogo..."
    yarn add @backstage/plugin-catalog-backend-module-github
fi

if ! yarn list @backstage/plugin-auth-backend-module-github-provider > /dev/null 2>&1; then
    echo "📦 Instalando proveedor de autenticación GitHub..."
    yarn add @backstage/plugin-auth-backend-module-github-provider
fi

# Iniciar Backstage
echo "🚀 Iniciando Backstage con sincronización automática..."
echo "📊 Catálogo se sincronizará cada ${CATALOG_SYNC_FREQUENCY} minutos"
echo "🔗 Repositorio: ${GITHUB_ORG}/${GITHUB_REPO}"

yarn backstage-cli app:serve --config app-config.yaml &

echo "✅ Backstage iniciado en ${APP_BASE_URL}"
echo "🔄 Sincronización automática activada con GitHub"
