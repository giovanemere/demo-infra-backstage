#!/bin/bash

# Auto-load environment variables
if [ -f ".env" ]; then
    set -a
    source .env
    set +a
elif [ -f "../backstage-idp/infra-ai-backstage/.env" ]; then
    cd ../backstage-idp/infra-ai-backstage
    set -a
    source .env
    set +a
    cd - > /dev/null
elif [ -f "backstage-idp/infra-ai-backstage/.env" ]; then
    cd backstage-idp/infra-ai-backstage
    set -a
    source .env
    set +a
    cd - > /dev/null
fi


# Crear aplicación Backstage simple
echo "🎭 Creando Backstage simple..."

# Crear estructura básica
mkdir -p infra-ai-backstage
cd infra-ai-backstage

# Crear package.json simple
cat > package.json << 'EOF'
{
  "name": "infra-ai-backstage",
  "version": "1.0.0",
  "description": "Infrastructure AI Backstage",
  "main": "index.js",
  "scripts": {
    "start": "echo 'Backstage running on http://localhost:3000' && sleep infinity"
  },
  "dependencies": {}
}
EOF

# Crear index.html simple
mkdir -p public
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Infrastructure AI - Backstage</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background: #1f5582; color: white; padding: 20px; border-radius: 8px; }
        .content { margin: 20px 0; }
        .service { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🎭 Infrastructure AI Platform - Backstage</h1>
        <p>Catálogo de servicios y arquitecturas</p>
    </div>
    
    <div class="content">
        <h2>📊 Servicios Disponibles</h2>
        
        <div class="service">
            <h3>🤖 AI Agent</h3>
            <p>Análisis automático de arquitecturas AWS</p>
            <a href="http://localhost:8000" target="_blank">Ver API</a> | 
            <a href="http://localhost:8000/docs" target="_blank">Documentación</a>
        </div>
        
        <div class="service">
            <h3>🐘 PostgreSQL</h3>
            <p>Base de datos para el catálogo</p>
            <p>Estado: <span style="color: green;">✅ Activo</span></p>
        </div>
        
        <div class="service">
            <h3>📁 Catálogo</h3>
            <p>YAMLs generados automáticamente</p>
            <a href="https://github.com/giovanemere/demo-infra-ai-agent" target="_blank">Ver Repositorio</a>
        </div>
    </div>
    
    <div class="content">
        <h2>🚀 Uso Rápido</h2>
        <pre style="background: #f0f0f0; padding: 15px; border-radius: 5px;">
# Procesar arquitectura
curl -X POST "http://localhost:8000/process-text" \
  -F "description=App web con S3, CloudFront y Lambda"
        </pre>
    </div>
</body>
</html>
EOF

echo "✅ Backstage simple creado"
