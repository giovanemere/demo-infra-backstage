#!/bin/bash
echo "🎭 Iniciando Backstage IDP..."

cd infra-ai-backstage

# Verificar variables de entorno
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    echo "💡 Copia .env.example y configura las variables necesarias"
    exit 1
fi

# Cargar variables de entorno
source .env

# Verificar PostgreSQL
echo "🐘 Verificando conexión a PostgreSQL..."
if ! nc -z localhost 5432; then
    echo "❌ PostgreSQL no está ejecutándose"
    echo "💡 Inicia PostgreSQL: cd /home/giovanemere/docker/postgres && ./start-postgres.sh"
    exit 1
fi

# Verificar sincronización del catálogo
echo "🔄 Verificando sincronización del catálogo..."
../scripts/verify-catalog-sync.sh

# Iniciar en modo desarrollo
echo ""
echo "🚀 Iniciando Backstage..."
echo "📱 Frontend: http://localhost:3000"
echo "🔧 Backend: http://localhost:7007"
echo "🐘 PostgreSQL: localhost:5432"
echo "📋 Catálogo sincronizado desde: $GITHUB_ORG/$GITHUB_REPO"
echo ""
echo "Presiona Ctrl+C para detener"

yarn dev
