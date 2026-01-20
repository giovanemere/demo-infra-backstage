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


echo "🔧 Solucionando Error: Unable to resolve user identity"
echo "===================================================="

# Cargar variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

GITHUB_USERNAME="giovanemere"  # Cambiar por tu usuario GitHub
USER_EMAIL="giovanemere@example.com"  # Cambiar por tu email

echo "👤 Configurando usuario: $GITHUB_USERNAME"

# Crear archivo de usuarios si no existe
if [ ! -f "catalog-users.yaml" ]; then
    echo "📝 Creando catalog-users.yaml..."
    cat > catalog-users.yaml << EOF
apiVersion: backstage.io/v1alpha1
kind: User
metadata:
  name: $GITHUB_USERNAME
  annotations:
    github.com/user-login: $GITHUB_USERNAME
spec:
  profile:
    displayName: $GITHUB_USERNAME
    email: $USER_EMAIL
  memberOf: [developers]
---
apiVersion: backstage.io/v1alpha1
kind: Group
metadata:
  name: developers
  description: Development team
spec:
  type: team
  children: []
EOF
    echo "✅ Archivo catalog-users.yaml creado"
else
    echo "✅ Archivo catalog-users.yaml ya existe"
fi

# Verificar configuración en app-config.yaml
if grep -q "catalog-users.yaml" app-config.yaml; then
    echo "✅ catalog-users.yaml ya está en app-config.yaml"
else
    echo "📝 Agregando catalog-users.yaml a app-config.yaml..."
    # Agregar al final de locations
    sed -i '/locations:/a\    - type: file\n      target: ./catalog-users.yaml\n      rules:\n        - allow: [User, Group]' app-config.yaml
    echo "✅ catalog-users.yaml agregado a configuración"
fi

# Reiniciar Backstage
echo ""
echo "🔄 Reiniciando Backstage para cargar usuarios..."
cd ..
./restart-backstage.sh

echo ""
echo "✅ Solución aplicada!"
echo ""
echo "🧪 Ahora prueba el login:"
echo "1. Ve a: http://localhost:3000"
echo "2. Haz clic en 'Sign In'"
echo "3. Selecciona 'GitHub'"
echo "4. El usuario '$GITHUB_USERNAME' debe funcionar"
echo ""
echo "📋 Si aún hay problemas:"
echo "- Verifica que tu usuario GitHub sea exactamente: $GITHUB_USERNAME"
echo "- Cambia el nombre en catalog-users.yaml si es diferente"
