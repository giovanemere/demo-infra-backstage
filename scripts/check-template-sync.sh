#!/bin/bash
echo "🔄 Verificando sincronización de templates..."

cd infra-ai-backstage

# Cargar variables de entorno
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

source .env

# Verificar repositorio de templates
TEMPLATE_REPO="demo-infra-ai-agent-template-idp"
echo "📦 Verificando repositorio de templates: $TEMPLATE_REPO..."

if [ ! -z "$GITHUB_TOKEN" ] && [ ! -z "$GITHUB_ORG" ]; then
    TEMPLATE_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_ORG/$TEMPLATE_REPO")
    
    if echo "$TEMPLATE_RESPONSE" | grep -q '"full_name"'; then
        echo "✅ Repositorio de templates accesible"
        
        # Verificar carpeta components
        COMPONENTS_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_ORG/$TEMPLATE_REPO/contents/components")
        
        if echo "$COMPONENTS_RESPONSE" | grep -q '"name"'; then
            COMPONENT_COUNT=$(echo "$COMPONENTS_RESPONSE" | grep -c '"name"')
            echo "✅ Componentes encontrados: $COMPONENT_COUNT"
        else
            echo "⚠️  Carpeta components vacía o no existe"
        fi
        
        # Verificar última actualización
        UPDATED_AT=$(echo "$TEMPLATE_RESPONSE" | grep '"updated_at"' | cut -d'"' -f4)
        echo "📅 Última actualización: $UPDATED_AT"
        
    else
        echo "❌ Repositorio de templates no accesible"
        echo "💡 Crear repositorio: https://github.com/$GITHUB_ORG/$TEMPLATE_REPO"
    fi
else
    echo "❌ Configuración GitHub no disponible"
    exit 1
fi

echo ""
echo "📋 Configuración de templates:"
echo "   📦 Repositorio: $GITHUB_ORG/$TEMPLATE_REPO"
echo "   📁 Ruta: /components/"
echo "   🔄 Sincronización: Automática desde app-config.yaml"
