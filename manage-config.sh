#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🔧 Backstage Config Manager${NC}"
echo "================================"

case "$1" in
  "save")
    echo -e "${YELLOW}💾 Guardando configuración...${NC}"
    node config-manager.js save
    ;;
  "restore")
    echo -e "${YELLOW}🔄 Restaurando configuración...${NC}"
    node config-manager.js restore
    ;;
  "backup")
    echo -e "${YELLOW}📦 Creando backup completo...${NC}"
    node config-manager.js save
    cp infra-ai-backstage/.env "backup-env-$(date +%Y%m%d-%H%M%S).env"
    echo -e "${GREEN}✅ Backup creado${NC}"
    ;;
  *)
    echo "Uso: $0 {save|restore|backup}"
    echo ""
    echo "Comandos:"
    echo "  save    - Guardar .env actual en DB"
    echo "  restore - Restaurar .env desde DB"
    echo "  backup  - Guardar en DB + crear archivo backup"
    exit 1
    ;;
esac
