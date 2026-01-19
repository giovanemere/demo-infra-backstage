# 🔐 Scripts de Validación GitHub OAuth

## 📋 Scripts Disponibles

### 1. `validate-github-auth.sh`
**Función**: Valida configuración local completa
```bash
./validate-github-auth.sh
```
**Verifica**:
- ✅ Variables de entorno (.env)
- ✅ Configuración app-config.yaml  
- ✅ Endpoints de Backstage
- ✅ Proporciona URLs exactas para GitHub

### 2. `test-github-auth.sh`
**Función**: Test técnico de endpoints de autenticación
```bash
./test-github-auth.sh
```
**Verifica**:
- ✅ Endpoints de auth funcionando
- ✅ Callback URL configurado
- ✅ Provider disponible en frontend
- ✅ Formato de credenciales

### 3. `configure-github-auth.sh`
**Función**: Muestra configuración necesaria
```bash
./configure-github-auth.sh
```
**Proporciona**:
- ✅ URLs exactas para GitHub OAuth App
- ✅ Instrucciones paso a paso

### 4. `restart-backstage.sh`
**Función**: Reinicia con configuración persistente
```bash
./restart-backstage.sh
```
**Hace**:
- ✅ Detiene procesos existentes
- ✅ Carga variables de entorno
- ✅ Reinicia con configuración completa

## 🔧 Configuración GitHub OAuth App

### URLs Requeridas:
- **Homepage URL**: `http://localhost:3000`
- **Callback URL**: `http://localhost:7007/api/auth/github/handler/frame`

### Link Directo:
https://github.com/settings/applications/Ov23liCF48J5cW1bjMiC

## ✅ Flujo de Validación Completo

1. **Validar configuración local**:
   ```bash
   ./validate-github-auth.sh
   ```

2. **Configurar URLs en GitHub** (manual)

3. **Reiniciar Backstage**:
   ```bash
   ./restart-backstage.sh
   ```

4. **Test técnico**:
   ```bash
   ./test-github-auth.sh
   ```

5. **Probar login** en http://localhost:3000

## 🎯 Estado Actual

- ✅ **Configuración local**: Completa
- ✅ **Scripts de validación**: Funcionando
- ⚠️ **GitHub OAuth URLs**: Requiere configuración manual
- ✅ **Backstage**: Corriendo con auth configurado

**Próximo paso**: Configurar las URLs en GitHub OAuth App usando el link directo.
