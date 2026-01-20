#!/bin/bash
echo "👥 Verificando usuarios en Backstage..."

cd infra-ai-backstage

# Cargar variables de entorno
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

source .env

# Verificar conexión a base de datos
echo "🐘 Verificando conexión a PostgreSQL..."
if ! nc -z $POSTGRES_HOST $POSTGRES_PORT; then
    echo "❌ No se puede conectar a PostgreSQL"
    exit 1
fi

# Verificar usuarios en repositorio IDP
TEMPLATE_REPO="demo-infra-ai-agent-template-idp"
echo "📋 Verificando usuarios en repositorio IDP..."
if [ ! -z "$GITHUB_TOKEN" ] && [ ! -z "$GITHUB_ORG" ]; then
    CATALOG_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_ORG/$TEMPLATE_REPO/contents/catalog-info.yaml")
    
    if echo "$CATALOG_RESPONSE" | grep -q '"content"'; then
        echo "✅ Catálogo IDP encontrado en GitHub"
    else
        echo "❌ Catálogo IDP no encontrado"
    fi
else
    echo "❌ Configuración GitHub no disponible"
fi

# Verificar usuarios en GitHub
echo "🔍 Verificando usuarios en GitHub..."
if [ ! -z "$GITHUB_TOKEN" ] && [ ! -z "$GITHUB_ORG" ]; then
    ORG_MEMBERS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/orgs/$GITHUB_ORG/members" | grep -c '"login"')
    echo "✅ Miembros de organización GitHub: $ORG_MEMBERS"
else
    echo "⚠️  Configuración GitHub no disponible"
fi

echo ""
echo "📊 Resumen de usuarios:"
echo "   📦 Catálogo IDP: En GitHub ($GITHUB_ORG/$TEMPLATE_REPO)"
echo "   🐙 Miembros GitHub: ${ORG_MEMBERS:-N/A}"
echo "   💡 Todos los usuarios se gestionan desde GitHub"
