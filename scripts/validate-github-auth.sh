#!/bin/bash
echo "🔐 Validando autenticación GitHub..."

cd infra-ai-backstage

# Cargar variables de entorno
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

source .env

# Verificar variables requeridas
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GITHUB_TOKEN no configurado"
    exit 1
fi

if [ -z "$GITHUB_ORG" ]; then
    echo "❌ GITHUB_ORG no configurado"
    exit 1
fi

# Test 1: Verificar token básico
echo "🧪 Test 1: Verificando token básico..."
RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user)
if echo "$RESPONSE" | grep -q '"login"'; then
    USER=$(echo "$RESPONSE" | grep '"login"' | cut -d'"' -f4)
    echo "✅ Token válido para usuario: $USER"
else
    echo "❌ Token inválido"
    exit 1
fi

# Test 2: Verificar acceso a organización
echo "🧪 Test 2: Verificando acceso a organización $GITHUB_ORG..."
ORG_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/orgs/$GITHUB_ORG")
if echo "$ORG_RESPONSE" | grep -q '"login"'; then
    echo "✅ Acceso a organización confirmado"
else
    echo "❌ Sin acceso a organización $GITHUB_ORG"
    exit 1
fi

# Test 3: Verificar repositorio principal
echo "🧪 Test 3: Verificando repositorio $GITHUB_REPO..."
REPO_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO")
if echo "$REPO_RESPONSE" | grep -q '"full_name"'; then
    echo "✅ Repositorio accesible"
else
    echo "❌ Repositorio no accesible"
    exit 1
fi

# Test 4: Verificar catálogo
echo "🧪 Test 4: Verificando catálogo..."
CATALOG_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO/contents$CATALOG_PATH")
if echo "$CATALOG_RESPONSE" | grep -q '"name"'; then
    echo "✅ Catálogo encontrado"
else
    echo "❌ Catálogo no encontrado en $CATALOG_PATH"
    exit 1
fi

echo ""
echo "🎉 Todas las validaciones pasaron correctamente"
echo "📋 Configuración GitHub:"
echo "   Usuario: $USER"
echo "   Organización: $GITHUB_ORG"
echo "   Repositorio: $GITHUB_REPO"
echo "   Catálogo: $CATALOG_PATH"
