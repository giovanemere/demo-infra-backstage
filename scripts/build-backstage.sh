#!/bin/bash
echo "🏗️ Construyendo Backstage para producción..."

cd infra-ai-backstage

# Build del frontend
yarn build:frontend

# Build del backend
yarn build:backend

echo "✅ Build completado"
echo "📦 Archivos en: packages/backend/dist/"
