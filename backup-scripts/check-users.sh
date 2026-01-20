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


echo "👤 Verificando Usuarios en Catálogo"
echo "=================================="

# Cargar variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

BACKEND_URL="${BACKEND_BASE_URL}"

echo "🔍 Verificando entidades User en catálogo..."

sleep 5  # Esperar que Backstage cargue

# Verificar usuarios en el catálogo
USERS=$(curl -s "${BACKEND_URL}/api/catalog/entities?filter=kind=user" 2>/dev/null)

if echo "$USERS" | grep -q "giovanemere"; then
    echo "✅ Usuario 'giovanemere' encontrado en catálogo"
else
    echo "❌ Usuario 'giovanemere' NO encontrado en catálogo"
    echo "📋 Usuarios disponibles:"
    echo "$USERS" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 || echo "  Ninguno"
fi

# Verificar grupos
GROUPS=$(curl -s "${BACKEND_URL}/api/catalog/entities?filter=kind=group" 2>/dev/null)

if echo "$GROUPS" | grep -q "developers"; then
    echo "✅ Grupo 'developers' encontrado en catálogo"
else
    echo "❌ Grupo 'developers' NO encontrado en catálogo"
fi

echo ""
echo "🔧 Si los usuarios no aparecen:"
echo "1. Verifica que catalog-users.yaml existe"
echo "2. Revisa logs: tail -f backstage.log"
echo "3. Ve al catálogo: ${APP_BASE_URL}/catalog"
echo ""
echo "🧪 Test de login:"
echo "1. Ve a: ${APP_BASE_URL}"
echo "2. Haz clic en 'Sign In'"
echo "3. Selecciona 'GitHub'"
echo "4. Usa usuario: giovanemere"
