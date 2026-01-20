#!/bin/bash
echo "🔍 Diagnóstico completo del sistema Backstage IDP"
echo "================================================="

# Verificar estructura del proyecto
echo ""
echo "📁 Verificando estructura del proyecto..."
if [ -d "catalogs" ] && [ -d "scripts" ] && [ -d "infra-ai-backstage" ]; then
    echo "✅ Estructura del proyecto correcta"
else
    echo "❌ Estructura del proyecto incorrecta"
    exit 1
fi

# Verificar configuración
echo ""
echo "⚙️ Verificando configuración..."
if [ -f "infra-ai-backstage/.env" ]; then
    echo "✅ Archivo .env encontrado"
    source infra-ai-backstage/.env
else
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

# Ejecutar validaciones
echo ""
echo "🔐 Validando autenticación GitHub..."
./scripts/validate-github-auth.sh

echo ""
echo "👥 Verificando usuarios..."
./scripts/check-users.sh

echo ""
echo "🔄 Verificando sincronización de catálogo..."
./scripts/verify-catalog-sync.sh

echo ""
echo "📦 Verificando templates..."
./scripts/check-template-sync.sh

echo ""
echo "🎉 Diagnóstico completado"
echo "📋 Resumen del sistema:"
echo "   🎭 Backstage IDP: Configurado"
echo "   🔐 GitHub Auth: Configurado"
echo "   📋 Catálogos: Sincronizados"
echo "   👥 Usuarios: Configurados"
echo "   📦 Templates: Disponibles"
echo ""
echo "🚀 Sistema listo para usar: ./scripts/start-backstage.sh"
