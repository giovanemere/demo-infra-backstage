#!/bin/bash
echo "🧪 Test completo de GitHub Authentication..."

cd infra-ai-backstage

# Cargar variables de entorno
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

source .env

echo "🔐 Configuración GitHub OAuth:"
echo "   Client ID: ${AUTH_GITHUB_CLIENT_ID:-No configurado}"
echo "   Client Secret: ${AUTH_GITHUB_CLIENT_SECRET:+Configurado}"
echo "   Callback URL: $BACKEND_BASE_URL/api/auth/github/handler/frame"
echo ""

# Test OAuth App
if [ ! -z "$AUTH_GITHUB_CLIENT_ID" ] && [ ! -z "$AUTH_GITHUB_CLIENT_SECRET" ]; then
    echo "🧪 Verificando OAuth App..."
    
    # Verificar que la app existe
    OAUTH_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/applications/$AUTH_GITHUB_CLIENT_ID/tokens")
    
    if echo "$OAUTH_RESPONSE" | grep -q '"message": "Not Found"'; then
        echo "❌ OAuth App no encontrada o sin permisos"
    else
        echo "✅ OAuth App configurada correctamente"
    fi
else
    echo "⚠️  OAuth no configurado - Solo autenticación guest disponible"
fi

# Test integración completa
echo ""
echo "🧪 Test de integración completa..."
../scripts/validate-github-auth.sh

echo ""
echo "📋 URLs importantes:"
echo "   🎭 Backstage: $APP_BASE_URL"
echo "   🔧 Backend: $BACKEND_BASE_URL"
echo "   🔐 GitHub OAuth: https://github.com/settings/applications/$AUTH_GITHUB_CLIENT_ID"
