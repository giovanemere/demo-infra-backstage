# 🔐 Configuración Persistente GitHub Auth

## ⚠️ Problema
GitHub Sign-in se pierde al reiniciar Backstage porque la configuración OAuth no está completa.

## ✅ Solución

### 1. Configurar GitHub OAuth App
Ve a: https://github.com/settings/developers

**Client ID**: `Ov23liCF48J5cW1bjMiC`

**URLs requeridas**:
- **Homepage URL**: `http://localhost:3000`
- **Authorization callback URL**: `http://localhost:7007/api/auth/github/handler/frame`

### 2. Variables de Entorno (.env)
```bash
# GitHub OAuth
GITHUB_CLIENT_ID=Ov23liCF48J5cW1bjMiC
GITHUB_CLIENT_SECRET=a947750076dfd49cf9030eae9206dce2960a12d9

# URLs
BACKEND_BASE_URL=http://localhost:7007
APP_BASE_URL=http://localhost:3000

# Secrets para persistencia
BACKEND_SECRET=infra-ai-platform-secret-key
AUTH_SESSION_SECRET=infra-ai-platform-session-secret-key-2026
```

### 3. Configuración app-config.yaml
```yaml
auth:
  environment: development
  providers:
    guest:
      dangerouslyAllowOutsideDevelopment: true
    github:
      development:
        clientId: ${GITHUB_CLIENT_ID}
        clientSecret: ${GITHUB_CLIENT_SECRET}
        callbackUrl: ${BACKEND_BASE_URL}/api/auth/github/handler/frame
        signIn:
          resolvers:
            - resolver: usernameMatchingUserEntityName
            - resolver: emailMatchingUserEntityProfileEmail
            - resolver: emailLocalPartMatchingUserEntityName
```

### 4. Scripts Disponibles
- `./configure-github-auth.sh` - Muestra configuración necesaria
- `./restart-backstage.sh` - Reinicia con configuración persistente

### 5. Verificación
1. Reinicia Backstage: `./restart-backstage.sh`
2. Ve a: http://localhost:3000
3. Haz clic en "Sign In"
4. Selecciona "GitHub"
5. La autenticación debe persistir entre reinicios

## 🔧 Troubleshooting

**Error "Invalid redirect_uri"**:
- Verifica que la callback URL en GitHub coincida exactamente
- URL debe ser: `http://localhost:7007/api/auth/github/handler/frame`

**Sesión se pierde**:
- Verifica que `BACKEND_SECRET` y `AUTH_SESSION_SECRET` estén configurados
- Usa el script `./restart-backstage.sh` para cargar variables correctamente
