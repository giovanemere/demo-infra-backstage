# 🎭 Backstage IDP Setup

## Inicio Rápido

```bash
./setup-backstage.sh
echo "GITHUB_TOKEN=tu_token" >> infra-ai-backstage/.env
./scripts/start-backstage.sh
```

**URL**: http://localhost:3000

## Prerequisitos

- Node.js 18+
- PostgreSQL ejecutándose (:5432)
- GitHub token configurado

## Configuración

### Variables (.env)
```bash
GITHUB_TOKEN=tu_github_token
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage123
POSTGRES_DB=backstage
```

### Integración GitHub
- Token con permisos: `repo`, `read:org`, `read:user`
- Repositorios monitoreados automáticamente
- Actualización del catálogo cada 5 minutos

## Scripts

```bash
./setup-backstage.sh      # Setup inicial
./scripts/start-backstage.sh  # Iniciar Backstage
```

## URLs

- **UI**: http://localhost:3000
- **API**: http://localhost:7007
