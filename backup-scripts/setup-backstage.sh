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


# =============================================================================
# Backstage IDP - Setup Script
# =============================================================================

set -e

echo "🎭 Iniciando setup de Backstage IDP..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Verificar Node.js
check_nodejs() {
    log_info "Verificando Node.js..."
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        log_success "Node.js $NODE_VERSION encontrado"
    else
        log_warning "Node.js no encontrado. Instalando..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
        log_success "Node.js instalado"
    fi
}

# Verificar Yarn
check_yarn() {
    log_info "Verificando Yarn..."
    if command -v yarn &> /dev/null; then
        YARN_VERSION=$(yarn --version)
        log_success "Yarn $YARN_VERSION encontrado"
    else
        log_info "Instalando Yarn..."
        npm install -g yarn
        log_success "Yarn instalado"
    fi
}

# Crear aplicación Backstage
create_backstage_app() {
    log_info "Creando aplicación Backstage..."
    
    if [ ! -d "infra-ai-backstage" ]; then
        log_info "Ejecutando create-app..."
        npx @backstage/create-app@latest infra-ai-backstage --skip-install
        log_success "Aplicación Backstage creada"
    else
        log_warning "Aplicación Backstage ya existe"
    fi
}

# Configurar app-config.yaml
configure_backstage() {
    log_info "Configurando Backstage..."
    
    cd infra-ai-backstage
    
    # Crear configuración personalizada
    cat > app-config.local.yaml << 'EOF'
app:
  title: Infrastructure AI Platform
  baseUrl: http://localhost:3000

organization:
  name: Platform Engineering Team

backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
  cors:
    origin: http://localhost:3000
    methods: [GET, HEAD, PATCH, POST, PUT, DELETE]
    credentials: true
  database:
    client: pg
    connection:
      host: ${POSTGRES_HOST}
      port: ${POSTGRES_PORT}
      user: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
      database: ${POSTGRES_DB}

catalog:
  import:
    entityFilename: catalog-info.yaml
  rules:
    - allow: [Component, System, API, Resource, Location, User, Group]
  locations:
    # Catálogo del Agente IA
    - type: url
      target: https://github.com/giovanemere/demo-infra-ai-agent/blob/main/catalog-info.yaml
    
    # Templates Repository - Componentes generados
    - type: url
      target: https://github.com/giovanemere/demo-infra-ai-agent-template-idp/blob/main/components/
      rules:
        - allow: [Component, Resource, System]
    
    # Ejemplos de Backstage
    - type: url
      target: https://github.com/backstage/backstage/blob/master/packages/catalog-model/examples/all.yaml

  processors:
    github:
      providers:
        - target: github.com
          apiBaseUrl: https://api.github.com
          token: ${GITHUB_TOKEN}

integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
      apps:
        - $include: github-app-backstage-credentials.yaml

auth:
  providers:
    github:
      development:
        clientId: ${AUTH_GITHUB_CLIENT_ID}
        clientSecret: ${AUTH_GITHUB_CLIENT_SECRET}
    guest: {}

techdocs:
  builder: 'local'
  generator:
    runIn: 'local'
  publisher:
    type: 'local'

scaffolder:
  defaultAuthor:
    name: Platform Team
    email: platform@company.com
  defaultCommitMessage: 'Initial commit'

# Configuración para actualización automática del catálogo
catalog:
  refresh:
    schedule:
      frequency: { minutes: 5 }
      timeout: { minutes: 3 }
EOF
    
    # Crear archivo de variables de entorno
    cat > .env << 'EOF'
# GitHub Integration
GITHUB_TOKEN=your_github_token_here

# Database PostgreSQL
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage123
POSTGRES_DB=backstage

# GitHub OAuth (opcional)
AUTH_GITHUB_CLIENT_ID=your_github_client_id
AUTH_GITHUB_CLIENT_SECRET=your_github_client_secret
EOF
    
    log_success "Configuración de Backstage completada"
    cd ..
}

# Instalar dependencias
install_dependencies() {
    log_info "Instalando dependencias..."
    cd infra-ai-backstage
    yarn install
    log_success "Dependencias instaladas"
    cd ..
}

# Crear scripts de utilidad
create_scripts() {
    log_info "Creando scripts de utilidad..."
    
    mkdir -p scripts
    
    # Script de inicio
    cat > scripts/start-backstage.sh << 'EOF'
#!/bin/bash
echo "🎭 Iniciando Backstage IDP..."

cd infra-ai-backstage

# Verificar variables de entorno
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    echo "💡 Copia .env.example y configura las variables necesarias"
    exit 1
fi

# Verificar PostgreSQL
echo "🐘 Verificando conexión a PostgreSQL..."
if ! nc -z localhost 5432; then
    echo "❌ PostgreSQL no está ejecutándose"
    echo "💡 Inicia PostgreSQL: cd /home/giovanemere/docker/postgres && ./start-postgres.sh"
    exit 1
fi

# Iniciar en modo desarrollo
echo "🚀 Iniciando Backstage..."
echo "📱 Frontend: http://localhost:3000"
echo "🔧 Backend: http://localhost:7007"
echo "🐘 PostgreSQL: localhost:5432"
echo ""
echo "Presiona Ctrl+C para detener"

yarn dev
EOF
    
    chmod +x scripts/start-backstage.sh
    
    # Script de build
    cat > scripts/build-backstage.sh << 'EOF'
#!/bin/bash
echo "🏗️ Construyendo Backstage para producción..."

cd infra-ai-backstage

# Build del frontend
yarn build:frontend

# Build del backend
yarn build:backend

echo "✅ Build completado"
echo "📦 Archivos en: packages/backend/dist/"
EOF
    
    chmod +x scripts/build-backstage.sh
    
    log_success "Scripts de utilidad creados"
}

# Crear catálogo local
create_local_catalog() {
    log_info "Creando catálogo local..."
    
    mkdir -p catalogs
    
    cat > catalogs/infra-ai-platform.yaml << 'EOF'
apiVersion: backstage.io/v1alpha1
kind: System
metadata:
  name: infrastructure-ai-platform
  title: "Infrastructure AI Platform"
  description: "Plataforma completa de IA para análisis de infraestructura AWS"
  tags:
    - platform
    - ai
    - infrastructure
    - aws
  annotations:
    backstage.io/managed-by-location: file:catalogs/infra-ai-platform.yaml
spec:
  owner: platform-team
  domain: platform-engineering
---
apiVersion: backstage.io/v1alpha1
kind: Location
metadata:
  name: infra-ai-agent-catalog
  description: "Catálogo del Agente IA para análisis de arquitecturas"
spec:
  type: url
  target: https://github.com/giovanemere/demo-infra-ai-agent/blob/main/catalog-info.yaml
---
apiVersion: backstage.io/v1alpha1
kind: User
metadata:
  name: platform-team
spec:
  displayName: Platform Engineering Team
  email: platform@company.com
  memberOf: [platform-engineering]
---
apiVersion: backstage.io/v1alpha1
kind: Group
metadata:
  name: platform-engineering
spec:
  type: team
  displayName: Platform Engineering
  email: platform@company.com
  children: []
EOF
    
    log_success "Catálogo local creado"
}

# Función principal
main() {
    echo "🎭 Backstage IDP Setup"
    echo "====================="
    echo ""
    
    check_nodejs
    check_yarn
    create_backstage_app
    configure_backstage
    install_dependencies
    create_scripts
    create_local_catalog
    
    echo ""
    echo "🎉 Setup de Backstage completado!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Inicia PostgreSQL: cd /home/giovanemere/docker/postgres && ./start-postgres.sh"
    echo "2. Configura GITHUB_TOKEN en infra-ai-backstage/.env"
    echo "3. Ejecuta ./scripts/start-backstage.sh"
    echo "4. Visita http://localhost:3000"
    echo ""
    echo "🔧 Scripts disponibles:"
    echo "  ./scripts/start-backstage.sh  - Iniciar Backstage"
    echo "  ./scripts/build-backstage.sh  - Build para producción"
    echo ""
    echo "🌐 URLs cuando esté ejecutándose:"
    echo "  http://localhost:3000         - Backstage UI"
    echo "  http://localhost:7007         - Backstage API"
    echo "  http://localhost:5432         - PostgreSQL"
    echo ""
    echo "📚 Documentación:"
    echo "  /home/giovanemere/docker/postgres/README.md - Configuración PostgreSQL"
    echo "  ../PLATFORM_GUIDE.md          - Guía completa de la plataforma"
    echo ""
}

main "$@"
