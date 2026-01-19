# 🎭 Configuración Backstage - Infrastructure AI Platform

## 📋 Módulos Configurados

### ✅ Módulos Instalados:
- `@backstage/plugin-catalog-backend-module-github` - Provider GitHub para catálogo
- `@backstage/plugin-auth-backend-module-github-provider` - Autenticación GitHub
- `pg` - Cliente PostgreSQL

### 🔧 Variables de Entorno (.env):
```bash
# PostgreSQL
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage123
POSTGRES_DB=backstage

# GitHub Integration
GITHUB_TOKEN=your_github_token_here
GITHUB_CLIENT_ID=Ov23liCF48J5cW1bjMiC
GITHUB_CLIENT_SECRET=a947750076dfd49cf9030eae9206dce2960a12d9

# Repository Configuration
GITHUB_ORG=giovanemere
GITHUB_REPO=demo-infra-ai-agent-template-idp
GITHUB_BRANCH=main
CATALOG_PATH=/catalog-info.yaml

# Backend Configuration
BACKEND_SECRET=infra-ai-platform-secret-key
BACKEND_BASE_URL=http://localhost:7007
APP_BASE_URL=http://localhost:3000

# Sync Configuration
CATALOG_SYNC_FREQUENCY=5  # minutos
CATALOG_SYNC_TIMEOUT=3    # minutos
```

### 🔄 Sincronización Automática:
- **Repositorio**: `git@github.com:giovanemere/demo-infra-ai-agent-template-idp.git`
- **Frecuencia**: Cada 5 minutos
- **Archivo**: `/catalog-info.yaml`
- **Rama**: `main`

### 🚀 Funcionalidades Activas:
- ✅ Provider GitHub para repositorios
- ✅ Catálogo conectado a GitHub
- ✅ Sincronización automática
- ✅ Autenticación GitHub + Guest
- ✅ Scaffolder para templates
- ✅ TechDocs local

### 📁 Archivos Clave:
- `.env` - Variables de entorno
- `app-config.yaml` - Configuración principal
- `start-backstage-simple.sh` - Script de inicio

### 🔗 URLs:
- **UI**: http://localhost:3000
- **API**: http://localhost:7007
- **Catálogo**: http://localhost:3000/catalog
