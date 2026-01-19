#!/bin/bash

echo "🔄 Reiniciando Backstage..."

cd /home/giovanemere/demos/backstage-idp/infra-ai-backstage

# Detener procesos existentes
echo "🛑 Deteniendo procesos existentes..."
pkill -f "backstage-cli"
pkill -f "yarn start"
sleep 3

# Cargar variables de entorno
echo "📋 Cargando configuración..."
export $(cat .env | grep -v '^#' | xargs)

# Reiniciar Backstage
echo "🚀 Iniciando Backstage..."
nohup yarn start > backstage.log 2>&1 &

sleep 10

# Verificar que esté corriendo
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
    echo "✅ Backstage reiniciado exitosamente"
    echo "🌐 UI: http://localhost:3000"
    echo "🔐 GitHub Auth configurado y persistente"
else
    echo "❌ Error al reiniciar Backstage"
    echo "📋 Revisa los logs: tail -f backstage.log"
fi
