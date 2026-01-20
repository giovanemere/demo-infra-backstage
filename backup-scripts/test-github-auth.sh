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


echo "🧪 Test Completo GitHub Authentication"
echo "====================================="

# Cargar variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

CLIENT_ID="${GITHUB_CLIENT_ID}"
BACKEND_URL="${BACKEND_BASE_URL}"
APP_URL="${APP_BASE_URL}"

echo "🔍 Testeando flujo de autenticación..."

# 1. Test endpoint de inicio de auth
echo "1️⃣ Testeando inicio de autenticación GitHub..."
AUTH_START=$(curl -s "${BACKEND_URL}/api/auth/github/start?env=development" 2>/dev/null)

if echo "$AUTH_START" | grep -q "github.com"; then
    echo "✅ Endpoint de inicio funciona"
    # Extraer URL de GitHub
    GITHUB_URL=$(echo "$AUTH_START" | grep -o 'https://github.com/login/oauth/authorize[^"]*')
    echo "🔗 URL de GitHub: ${GITHUB_URL:0:80}..."
else
    echo "❌ Endpoint de inicio no funciona"
    echo "Response: $AUTH_START"
fi

# 2. Test configuración de callback
echo ""
echo "2️⃣ Testeando configuración de callback..."
CALLBACK_URL="${BACKEND_URL}/api/auth/github/handler/frame"

# Verificar que el endpoint existe
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$CALLBACK_URL" 2>/dev/null)
if [[ "$HTTP_CODE" == "400" ]] || [[ "$HTTP_CODE" == "401" ]]; then
    echo "✅ Endpoint callback existe (HTTP: $HTTP_CODE - esperado sin parámetros)"
else
    echo "❌ Endpoint callback no responde correctamente (HTTP: $HTTP_CODE)"
fi

# 3. Test configuración en frontend
echo ""
echo "3️⃣ Testeando configuración en frontend..."
FRONTEND_CONFIG=$(curl -s "${APP_URL}/api/auth/providers" 2>/dev/null)

if echo "$FRONTEND_CONFIG" | grep -q "github"; then
    echo "✅ GitHub provider disponible en frontend"
else
    echo "❌ GitHub provider no disponible en frontend"
fi

# 4. Test de variables de entorno
echo ""
echo "4️⃣ Validando variables críticas..."

if [[ ${#CLIENT_ID} -eq 20 ]] && [[ $CLIENT_ID == Ov* ]]; then
    echo "✅ Client ID tiene formato correcto"
else
    echo "❌ Client ID no tiene formato correcto"
fi

if [[ ${#GITHUB_CLIENT_SECRET} -eq 40 ]]; then
    echo "✅ Client Secret tiene longitud correcta"
else
    echo "❌ Client Secret no tiene longitud correcta"
fi

# 5. Resumen y próximos pasos
echo ""
echo "📋 Resumen del Test:"
echo "==================="

# Verificar si todo está OK
ALL_OK=true

if ! echo "$AUTH_START" | grep -q "github.com"; then
    ALL_OK=false
fi

if ! echo "$FRONTEND_CONFIG" | grep -q "github"; then
    ALL_OK=false
fi

if $ALL_OK; then
    echo "✅ Configuración técnica correcta"
    echo ""
    echo "🔧 Pasos Finales:"
    echo "1. Configura URLs en GitHub OAuth App:"
    echo "   https://github.com/settings/applications/${CLIENT_ID}"
    echo ""
    echo "2. URLs exactas a configurar:"
    echo "   Homepage URL: ${APP_URL}"
    echo "   Callback URL: ${CALLBACK_URL}"
    echo ""
    echo "3. Reinicia Backstage:"
    echo "   ./restart-backstage.sh"
    echo ""
    echo "4. Prueba login en:"
    echo "   ${APP_URL}"
else
    echo "❌ Hay problemas en la configuración técnica"
    echo "🔧 Revisa los errores anteriores y corrige antes de continuar"
fi
