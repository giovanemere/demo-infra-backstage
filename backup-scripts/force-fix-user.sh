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


echo "🔧 Solucionando Error de Identidad de Usuario"
echo "============================================"

cd /home/giovanemere/demos/backstage-idp/infra-ai-backstage

# Cargar variables
export $(cat .env | grep -v '^#' | xargs)

echo "1️⃣ Verificando archivo catalog-users.yaml..."
if [ -f "catalog-users.yaml" ]; then
    echo "✅ Archivo existe"
    echo "👤 Usuario configurado:"
    grep -A 5 "kind: User" catalog-users.yaml
else
    echo "❌ Archivo no existe, creándolo..."
    cat > catalog-users.yaml << 'EOF'
apiVersion: backstage.io/v1alpha1
kind: User
metadata:
  name: giovanemere
  namespace: default
  annotations:
    github.com/user-login: giovanemere
spec:
  profile:
    displayName: giovanemere
    email: giovanemere@example.com
  memberOf: [developers]
---
apiVersion: backstage.io/v1alpha1
kind: Group
metadata:
  name: developers
  namespace: default
  description: Development team
spec:
  type: team
  children: []
EOF
fi

echo ""
echo "2️⃣ Verificando configuración en app-config.yaml..."
if grep -q "catalog-users.yaml" app-config.yaml; then
    echo "✅ catalog-users.yaml está configurado"
else
    echo "❌ Agregando catalog-users.yaml a configuración..."
    # Backup y agregar
    cp app-config.yaml app-config.yaml.bak
    sed -i '/target: https:\/\/github.com/a\    # Usuarios locales\n    - type: file\n      target: ./catalog-users.yaml\n      rules:\n        - allow: [User, Group]' app-config.yaml
fi

echo ""
echo "3️⃣ Reiniciando Backstage..."
cd ..
./restart-backstage.sh

echo ""
echo "4️⃣ Esperando que Backstage cargue completamente..."
sleep 15

echo ""
echo "5️⃣ Verificando que el usuario esté disponible..."
cd infra-ai-backstage

# Intentar varias veces
for i in {1..5}; do
    echo "Intento $i/5..."
    RESPONSE=$(curl -s "http://localhost:3000/api/catalog/entities" 2>/dev/null)
    if echo "$RESPONSE" | grep -q "giovanemere"; then
        echo "✅ Usuario 'giovanemere' encontrado en el catálogo!"
        break
    else
        echo "⏳ Usuario no encontrado aún, esperando..."
        sleep 5
    fi
done

echo ""
echo "🧪 Ahora prueba el login:"
echo "1. Ve a: http://localhost:3000"
echo "2. Haz clic en 'Sign In'"
echo "3. Selecciona 'GitHub'"
echo "4. Autoriza la aplicación"
echo ""
echo "📋 Si aún falla:"
echo "- Verifica que tu usuario GitHub sea exactamente 'giovanemere'"
echo "- Revisa logs: tail -f backstage.log"
