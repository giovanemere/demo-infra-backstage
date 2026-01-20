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


echo "🔐 Configuración GitHub OAuth App para Backstage"
echo "================================================"

# Cargar variables de entorno
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo "📋 Configuración actual:"
echo "  Client ID: ${GITHUB_CLIENT_ID}"
echo "  Backend URL: ${BACKEND_BASE_URL}"
echo "  App URL: ${APP_BASE_URL}"

echo ""
echo "🔧 Para que GitHub Sign-in persista, verifica en GitHub:"
echo "  1. Ve a: https://github.com/settings/developers"
echo "  2. Selecciona tu OAuth App: ${GITHUB_CLIENT_ID}"
echo "  3. Configura estas URLs:"
echo ""
echo "     Homepage URL:"
echo "     ${APP_BASE_URL}"
echo ""
echo "     Authorization callback URL:"
echo "     ${BACKEND_BASE_URL}/api/auth/github/handler/frame"
echo ""
echo "🔄 Después de configurar, reinicia Backstage:"
echo "   ./restart-backstage.sh"
echo ""
echo "✅ La autenticación persistirá entre reinicios"
