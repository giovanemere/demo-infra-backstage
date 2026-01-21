# 🎭 Backstage IDP - Infrastructure AI Platform

**Internal Developer Platform personalizado con integración de IA**

Backstage IDP configurado específicamente para Infrastructure AI Platform, incluyendo página personalizada para análisis de arquitecturas AWS con IA.

## 🏗️ Características

- ✅ **Página InfraAI personalizada** (`/infra-ai`)
- ✅ **Integración con AI Agent** (análisis de texto e imágenes)
- ✅ **Catálogo dinámico** sincronizado con GitHub
- ✅ **Templates Scaffolder** generados automáticamente por IA
- ✅ **Autenticación GitHub** configurada
- ✅ **TechDocs** para documentación

## 🚀 Inicio Rápido

### Prerrequisitos
```bash
# Node.js 18+ y Yarn
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g yarn

# PostgreSQL
sudo apt install postgresql postgresql-contrib
```

### Configuración
```bash
# Instalar dependencias
cd infra-ai-backstage
yarn install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales GitHub
```

### Variables de Entorno Requeridas
```bash
# GitHub Integration
GITHUB_TOKEN=tu_github_token
GITHUB_CLIENT_ID=tu_github_client_id
GITHUB_CLIENT_SECRET=tu_github_client_secret

# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage123
POSTGRES_DB=backstage
```

### Ejecutar
```bash
# Opción 1: Script automático
../scripts/start-backstage.sh

# Opción 2: Manual
yarn dev
```

## 🌐 URLs de Acceso

- **Backstage Home**: http://localhost:3000
- **InfraAI Page**: http://localhost:3000/infra-ai
- **Catalog**: http://localhost:3000/catalog
- **Create Templates**: http://localhost:3000/create
- **API Docs**: http://localhost:3000/api-docs

## 🎯 Página InfraAI Personalizada

### Funcionalidades
1. **Procesar Arquitectura**: Análisis de texto de arquitecturas AWS
2. **Analizar Imagen**: Procesamiento de diagramas de arquitectura
3. **Integración directa** con AI Agent (localhost:8000)
4. **Resultados en tiempo real** con enlaces a GitHub y templates

### Uso
1. Navegar a http://localhost:3000/infra-ai
2. Seleccionar función (texto o imagen)
3. Ingresar descripción o subir imagen
4. Ver resultados y templates generados

## 📁 Estructura del Proyecto

```
backstage-idp/
├── infra-ai-backstage/             # Aplicación Backstage
│   ├── packages/
│   │   ├── app/                    # Frontend
│   │   │   └── src/components/
│   │   │       └── InfraAI/        # Página personalizada
│   │   └── backend/                # Backend
│   ├── app-config.yaml             # Configuración principal
│   └── .env                        # Variables de entorno
├── scripts/                        # Scripts de gestión
└── README.md                       # Esta documentación
```

## 🔧 Configuración Avanzada

### Integración GitHub
```yaml
# app-config.yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}

catalog:
  locations:
    - type: url
      target: https://github.com/user/templates-repo/blob/main/catalog-info.yaml
```

### Base de Datos
```bash
# Crear base de datos
sudo -u postgres psql -c "CREATE USER backstage WITH PASSWORD 'backstage123';"
sudo -u postgres psql -c "CREATE DATABASE backstage OWNER backstage;"
```

## 🐛 Troubleshooting

### Problemas Comunes

**Error: Puerto ocupado**
```bash
sudo lsof -ti:3000 | xargs kill -9
sudo lsof -ti:7007 | xargs kill -9
```

**Error: Base de datos**
```bash
sudo systemctl restart postgresql
```

**Error: Dependencias**
```bash
rm -rf node_modules yarn.lock
yarn install
```

**Error: GitHub Auth**
```bash
# Verificar variables de entorno
echo $GITHUB_TOKEN
# Regenerar token en GitHub Settings
```

## 📚 Documentación

- **[Configuración GitHub](GITHUB_AUTH_SETUP.md)**
- **[Gestión de Catálogo](CATALOG_MANAGEMENT.md)**
- **[Scripts de Validación](VALIDATION_SCRIPTS.md)**

## 🤝 Contribución

1. Fork el repositorio
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

---

**Parte de**: [Infrastructure AI Platform](https://github.com/giovanemere/demo-infrastructure-ai-platform)  
**Versión**: v1.2.0  
**Última actualización**: Enero 2026
