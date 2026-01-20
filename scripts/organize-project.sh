#!/bin/bash
echo "🧹 Organizando archivos del proyecto..."

# Crear carpeta para archivos backup
mkdir -p backup-scripts

# Mover archivos backup
echo "📦 Moviendo archivos backup..."
mv *.backup backup-scripts/ 2>/dev/null || true

# Mover scripts antiguos que ya no se usan
echo "📁 Organizando scripts antiguos..."
for script in restart-backstage.sh start-backstage-simple.sh; do
    if [ -f "$script" ]; then
        mv "$script" backup-scripts/
    fi
done

# Verificar estructura final
echo "✅ Estructura organizada:"
echo "📁 catalogs/ - Catálogos locales del IDP"
echo "📁 scripts/ - Scripts principales de gestión"
echo "📁 backup-scripts/ - Scripts antiguos y backups"
echo "📁 infra-ai-backstage/ - Aplicación Backstage"
echo "📄 CATALOG_MANAGEMENT.md - Documentación de catálogos"

echo ""
echo "🚀 Scripts principales disponibles:"
echo "   ./scripts/start-backstage.sh - Iniciar Backstage con verificaciones"
echo "   ./scripts/build-backstage.sh - Build para producción"
echo "   ./scripts/verify-catalog-sync.sh - Verificar sincronización"
