#!/bin/bash

# Auto-load environment variables
if [ -f ".env" ]; then
    set -a
    source .env
    set +a
elif [ -f "../backstage-idp/infra-ai-backstage/.env" ]; then
    cd ../backstage-idp/infra-ai-backstage
    set -a
    source .env
    set +a
    cd - > /dev/null
elif [ -f "backstage-idp/infra-ai-backstage/.env" ]; then
    cd backstage-idp/infra-ai-backstage
    set -a
    source .env
    set +a
    cd - > /dev/null
fi


echo "📋 Verificando Carga Automática de Templates"
echo "==========================================="

# Cargar variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

BACKEND_URL="${BACKEND_BASE_URL}"
REPO_URL="https://github.com/giovanemere/demo-infra-ai-agent-template-idp"

echo "🔍 Verificando catalog-info.yaml en repositorio..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${REPO_URL}/raw/main/catalog-info.yaml")

if [[ "$HTTP_CODE" == "200" ]]; then
    echo "✅ catalog-info.yaml encontrado en repositorio"
else
    echo "❌ catalog-info.yaml NO encontrado (HTTP: $HTTP_CODE)"
    exit 1
fi

echo ""
echo "🔍 Verificando configuración en Backstage..."

# Verificar que la URL esté en la configuración
if grep -q "demo-infra-ai-agent-template-idp" ../infra-ai-backstage/app-config.yaml; then
    echo "✅ Repositorio configurado en app-config.yaml"
else
    echo "❌ Repositorio NO configurado en app-config.yaml"
fi

echo ""
echo "⏳ Esperando sincronización (puede tomar hasta 5 minutos)..."
sleep 10

echo ""
echo "🔍 Verificando entidades cargadas..."

# Verificar locations
LOCATIONS=$(curl -s "${BACKEND_URL}/api/catalog/entities?filter=kind=location" 2>/dev/null)
if echo "$LOCATIONS" | grep -q "infrastructure-ai-templates"; then
    echo "✅ Location 'infrastructure-ai-templates' cargada"
else
    echo "⏳ Location aún no cargada, esperando..."
fi

# Verificar components
COMPONENTS=$(curl -s "${BACKEND_URL}/api/catalog/entities?filter=kind=component" 2>/dev/null)
if echo "$COMPONENTS" | grep -q "ai-agent"; then
    echo "✅ Component 'ai-agent' cargado"
else
    echo "⏳ Components aún no cargados"
fi

# Verificar systems
SYSTEMS=$(curl -s "${BACKEND_URL}/api/catalog/entities?filter=kind=system" 2>/dev/null)
if echo "$SYSTEMS" | grep -q "infrastructure-ai-platform"; then
    echo "✅ System 'infrastructure-ai-platform' cargado"
else
    echo "⏳ Systems aún no cargados"
fi

echo ""
echo "📊 Resumen de Sincronización:"
echo "- Frecuencia: Cada 5 minutos"
echo "- Repositorio: ${REPO_URL}"
echo "- Archivo: /catalog-info.yaml"
echo ""
echo "🌐 Verifica en Backstage:"
echo "- Catálogo: http://localhost:3000/catalog"
echo "- Locations: http://localhost:3000/catalog?filters%5Bkind%5D=location"
echo "- Components: http://localhost:3000/catalog?filters%5Bkind%5D=component"

# Limpiar repositorio temporal
rm -rf /tmp/template-repo 2>/dev/null
