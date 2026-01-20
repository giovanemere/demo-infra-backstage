# 🛠️ Scripts de Gestión - Backstage IDP

## 📁 Estructura Organizada

```
backstage-idp/
├── scripts/                           # Scripts principales
│   ├── start-backstage.sh            # 🚀 Iniciar Backstage
│   ├── build-backstage.sh            # 🏗️ Build para producción
│   ├── system-check.sh               # 🔍 Diagnóstico completo
│   ├── validate-github-auth.sh       # 🔐 Validar GitHub
│   ├── configure-github-auth.sh      # ⚙️ Configurar GitHub
│   ├── test-github-auth.sh           # 🧪 Test GitHub OAuth
│   ├── verify-catalog-sync.sh        # 📋 Verificar catálogos
│   ├── check-template-sync.sh        # 📦 Verificar templates
│   ├── check-users.sh                # 👥 Verificar usuarios
│   └── organize-project.sh           # 🧹 Organizar proyecto
└── backup-scripts/                   # Scripts antiguos
```

## 🚀 Scripts Principales

### 🔍 Diagnóstico Completo
```bash
./scripts/system-check.sh
```
Ejecuta todas las validaciones y muestra el estado del sistema.

### 🚀 Iniciar Backstage
```bash
./scripts/start-backstage.sh
```
Inicia Backstage con todas las verificaciones previas.

### 🏗️ Build para Producción
```bash
./scripts/build-backstage.sh
```
Construye la aplicación para despliegue en producción.

## 🔐 Scripts de Autenticación GitHub

### ⚙️ Configurar GitHub
```bash
./scripts/configure-github-auth.sh
```
Guía para configurar la autenticación con GitHub.

### 🔐 Validar GitHub
```bash
./scripts/validate-github-auth.sh
```
Valida token, organización, repositorio y catálogo.

### 🧪 Test GitHub OAuth
```bash
./scripts/test-github-auth.sh
```
Prueba completa de autenticación OAuth con GitHub.

## 📋 Scripts de Catálogos

### 🔄 Verificar Sincronización
```bash
./scripts/verify-catalog-sync.sh
```
Verifica la sincronización automática desde GitHub.

### 📦 Verificar Templates
```bash
./scripts/check-template-sync.sh
```
Verifica el repositorio de templates y componentes generados.

### 👥 Verificar Usuarios
```bash
./scripts/check-users.sh
```
Verifica usuarios locales y de GitHub.

## 🧹 Mantenimiento

### 🗂️ Organizar Proyecto
```bash
./scripts/organize-project.sh
```
Organiza archivos backup y estructura del proyecto.

## 📊 Flujo de Uso Recomendado

1. **Primera configuración:**
   ```bash
   ./scripts/configure-github-auth.sh
   ./scripts/system-check.sh
   ```

2. **Uso diario:**
   ```bash
   ./scripts/start-backstage.sh
   ```

3. **Diagnóstico de problemas:**
   ```bash
   ./scripts/system-check.sh
   ./scripts/validate-github-auth.sh
   ```

4. **Verificar sincronización:**
   ```bash
   ./scripts/verify-catalog-sync.sh
   ./scripts/check-template-sync.sh
   ```

## ⚠️ Scripts Movidos a Backup

Los siguientes scripts se movieron a `backup-scripts/`:
- `*.backup` - Versiones anteriores
- `restart-backstage.sh` - Reemplazado por `start-backstage.sh`
- `start-backstage-simple.sh` - Versión simplificada obsoleta

## 🔧 Variables de Entorno Requeridas

```bash
# GitHub Integration
GITHUB_TOKEN=ghp_xxx
GITHUB_ORG=tu-organizacion
GITHUB_REPO=tu-repositorio
GITHUB_BRANCH=main
CATALOG_PATH=/catalog-info.yaml

# GitHub OAuth (opcional)
AUTH_GITHUB_CLIENT_ID=xxx
AUTH_GITHUB_CLIENT_SECRET=xxx

# URLs
APP_BASE_URL=http://localhost:3000
BACKEND_BASE_URL=http://localhost:7007

# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage123
POSTGRES_DB=backstage
```
