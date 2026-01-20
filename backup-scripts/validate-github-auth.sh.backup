#!/bin/bash

echo "🔍 Validando Configuración GitHub OAuth App"
echo "==========================================="

# Cargar variables de entorno
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

# Variables requeridas
CLIENT_ID="${GITHUB_CLIENT_ID}"
CLIENT_SECRET="${GITHUB_CLIENT_SECRET}"
BACKEND_URL="${BACKEND_BASE_URL}"
APP_URL="${APP_BASE_URL}"

echo "📋 Configuración Local:"
echo "  Client ID: ${CLIENT_ID}"
echo "  Client Secret: ${CLIENT_SECRET:0:8}..."
echo "  Backend URL: ${BACKEND_URL}"
echo "  App URL: ${APP_URL}"
echo ""

# Validar variables requeridas
ERRORS=0

if [[ -z "$CLIENT_ID" ]]; then
    echo "❌ GITHUB_CLIENT_ID no configurado"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ GITHUB_CLIENT_ID configurado"
fi

if [[ -z "$CLIENT_SECRET" ]]; then
    echo "❌ GITHUB_CLIENT_SECRET no configurado"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ GITHUB_CLIENT_SECRET configurado"
fi

if [[ -z "$BACKEND_URL" ]]; then
    echo "❌ BACKEND_BASE_URL no configurado"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ BACKEND_BASE_URL configurado"
fi

echo ""

# Validar endpoints de Backstage
echo "🌐 Validando Endpoints Backstage..."

# Verificar que Backstage esté corriendo
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${APP_URL}" 2>/dev/null || echo "000")
if [[ "$HTTP_CODE" == "200" ]]; then
    echo "✅ Frontend accesible: ${APP_URL}"
else
    echo "❌ Frontend no accesible: ${APP_URL} (HTTP: $HTTP_CODE)"
    ERRORS=$((ERRORS + 1))
fi

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "${BACKEND_URL}/api/auth/.well-known/jwks.json" 2>/dev/null || echo "000")
if [[ "$HTTP_CODE" == "200" ]]; then
    echo "✅ Backend auth accesible: ${BACKEND_URL}/api/auth"
else
    echo "❌ Backend auth no accesible: ${BACKEND_URL}/api/auth (HTTP: $HTTP_CODE)"
    ERRORS=$((ERRORS + 1))
fi

# Verificar configuración auth en app-config.yaml
echo ""
echo "📄 Validando app-config.yaml..."

if grep -q "clientId: \${GITHUB_CLIENT_ID}" ../infra-ai-backstage/app-config.yaml; then
    echo "✅ GitHub clientId configurado en app-config.yaml"
else
    echo "❌ GitHub clientId no encontrado en app-config.yaml"
    ERRORS=$((ERRORS + 1))
fi

if grep -q "callbackUrl:" ../infra-ai-backstage/app-config.yaml; then
    echo "✅ Callback URL configurado en app-config.yaml"
else
    echo "❌ Callback URL no configurado en app-config.yaml"
    ERRORS=$((ERRORS + 1))
fi

# URLs esperadas
EXPECTED_CALLBACK="${BACKEND_URL}/api/auth/github/handler/frame"

echo ""
echo "🔧 Configuración Requerida en GitHub:"
echo "  1. Ve a: https://github.com/settings/developers"
echo "  2. Selecciona OAuth App: ${CLIENT_ID}"
echo "  3. Configura estas URLs EXACTAMENTE:"
echo ""
echo "     Homepage URL:"
echo "     ${APP_URL}"
echo ""
echo "     Authorization callback URL:"
echo "     ${EXPECTED_CALLBACK}"
echo ""

# Test de autenticación
echo "🧪 Test Manual de Autenticación:"
echo "  1. Ve a: ${APP_URL}"
echo "  2. Haz clic en 'Sign In'"
echo "  3. Selecciona 'GitHub'"
echo "  4. Debe redirigir sin errores"
echo ""

# Resumen
if [[ $ERRORS -eq 0 ]]; then
    echo "✅ Configuración local correcta"
    echo "🔧 Verifica las URLs en GitHub y reinicia: ./restart-backstage.sh"
else
    echo "❌ Encontrados $ERRORS errores en configuración local"
    echo "🔧 Corrige los errores antes de continuar"
fi

# Link directo para configuración
echo ""
echo "🔗 Link directo para configurar OAuth App:"
echo "   https://github.com/settings/applications/${CLIENT_ID}"
