# 🔧 Gestión de Configuración Backstage

## Funcionalidad Implementada

Sistema para respaldar y restaurar la configuración `.env` en PostgreSQL.

## Comandos Disponibles

```bash
# Guardar configuración actual en DB
./manage-config.sh save

# Restaurar configuración desde DB
./manage-config.sh restore

# Crear backup completo (DB + archivo)
./manage-config.sh backup
```

## Estructura

- `config-manager.js` - Script principal Node.js
- `manage-config.sh` - Wrapper con interfaz amigable
- Tabla `config_backup` en PostgreSQL

## Base de Datos

```sql
CREATE TABLE config_backup (
  id SERIAL PRIMARY KEY,
  config_data TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Uso Típico

1. **Antes de cambios**: `./manage-config.sh backup`
2. **Si se pierde config**: `./manage-config.sh restore`
3. **Respaldo rutinario**: `./manage-config.sh save`

## Características

- ✅ Almacenamiento seguro en PostgreSQL
- ✅ Restauración automática del último backup
- ✅ Historial de configuraciones
- ✅ Backup adicional en archivos locales
- ✅ Interfaz simple y clara
