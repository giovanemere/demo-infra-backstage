#!/bin/bash
echo "🔍 Verificando sincronización del catálogo..."

cd infra-ai-backstage

# Cargar variables de entorno
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

source .env

# Verificar conexión a GitHub
echo "📡 Verificando conexión a GitHub..."
if ! curl -s -f -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user > /dev/null; then
    echo "❌ Error: No se puede conectar a GitHub. Verifica el GITHUB_TOKEN"
    exit 1
fi

# Verificar catálogo principal (AI Agent)
echo "📋 Verificando catálogo principal..."
CATALOG_URL="https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO/contents$CATALOG_PATH"
if curl -s -f -H "Authorization: token $GITHUB_TOKEN" "$CATALOG_URL" > /dev/null; then
    echo "✅ Catálogo principal accesible: $GITHUB_ORG/$GITHUB_REPO$CATALOG_PATH"
else
    echo "❌ Error: No se encuentra el catálogo en $CATALOG_URL"
    exit 1
fi

# Verificar repositorio de templates/IDP
TEMPLATE_REPO="demo-infra-ai-agent-template-idp"
echo "📦 Verificando repositorio IDP..."
TEMPLATE_URL="https://api.github.com/repos/$GITHUB_ORG/$TEMPLATE_REPO/contents/catalog-info.yaml"
if curl -s -f -H "Authorization: token $GITHUB_TOKEN" "$TEMPLATE_URL" > /dev/null; then
    echo "✅ Catálogo IDP accesible: $GITHUB_ORG/$TEMPLATE_REPO"
else
    echo "❌ Error: No se encuentra el catálogo IDP"
    exit 1
fi

echo ""
echo "✅ Configuración de sincronización correcta:"
echo "   📡 Catálogo principal: $GITHUB_ORG/$GITHUB_REPO$CATALOG_PATH"
echo "   📦 Catálogo IDP: $GITHUB_ORG/$TEMPLATE_REPO/catalog-info.yaml"
echo "   🔄 Sincronización automática cada 5 minutos"
echo ""
echo "💡 Todos los catálogos se sincronizan desde GitHub"
echo "💡 No hay archivos locales - todo está centralizado en repositorios"
