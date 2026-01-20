#!/bin/bash
echo "🔧 Configurando autenticación GitHub..."

cd infra-ai-backstage

# Verificar archivo .env
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    echo "💡 Crea el archivo .env con las variables necesarias"
    exit 1
fi

source .env

echo "📋 Configuración actual:"
echo "   Token: ${GITHUB_TOKEN:+Configurado}"
echo "   Organización: $GITHUB_ORG"
echo "   Repositorio: $GITHUB_REPO"
echo "   OAuth Client ID: ${AUTH_GITHUB_CLIENT_ID:-No configurado}"
echo ""

# Verificar configuración mínima
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GITHUB_TOKEN requerido"
    echo "💡 Genera un token en: https://github.com/settings/tokens"
    echo "💡 Permisos necesarios: repo, read:org, read:user"
    exit 1
fi

# Verificar token
echo "🔍 Verificando token..."
USER_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user)
if echo "$USER_RESPONSE" | grep -q '"login"'; then
    USER=$(echo "$USER_RESPONSE" | grep '"login"' | cut -d'"' -f4)
    echo "✅ Token válido para: $USER"
else
    echo "❌ Token inválido"
    exit 1
fi

# Configurar OAuth (opcional)
if [ -z "$AUTH_GITHUB_CLIENT_ID" ]; then
    echo ""
    echo "⚠️  OAuth no configurado - Solo modo guest disponible"
    echo "💡 Para configurar OAuth:"
    echo "   1. Ve a: https://github.com/settings/applications/new"
    echo "   2. Application name: Backstage IDP"
    echo "   3. Homepage URL: $APP_BASE_URL"
    echo "   4. Callback URL: $BACKEND_BASE_URL/api/auth/github/handler/frame"
    echo "   5. Agrega CLIENT_ID y CLIENT_SECRET al .env"
fi

echo ""
echo "✅ Configuración GitHub lista"
echo "🚀 Ejecuta: ./scripts/start-backstage.sh"
