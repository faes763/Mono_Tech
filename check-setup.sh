#!/bin/bash

# TechMage NX - Скрипт проверки готовности системы

set -e

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Проверка готовности TechMage NX...${NC}"
echo ""

# Проверка Docker
echo -e "${YELLOW}Проверка Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker не установлен${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker не запущен${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker готов${NC}"

# Проверка Docker Compose
echo -e "${YELLOW}Проверка Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose не установлен${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker Compose готов${NC}"

# Проверка Make (опционально)
echo -e "${YELLOW}Проверка Make...${NC}"
if command -v make &> /dev/null; then
    echo -e "${GREEN}✅ Make доступен${NC}"
else
    echo -e "${YELLOW}⚠️  Make не найден (можно использовать docker-compose напрямую)${NC}"
fi

# Проверка файлов
echo -e "${YELLOW}Проверка конфигурационных файлов...${NC}"

if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ docker-compose.yml не найден${NC}"
    exit 1
fi
echo -e "${GREEN}✅ docker-compose.yml найден${NC}"

if [ ! -f ".env" ]; then
    echo -e "${RED}❌ .env файл не найден${NC}"
    exit 1
fi
echo -e "${GREEN}✅ .env файл найден${NC}"

# Проверка директорий проектов
echo -e "${YELLOW}Проверка директорий проектов...${NC}"

if [ ! -d "techmage-backend" ]; then
    echo -e "${RED}❌ Директория techmage-backend не найдена${NC}"
    exit 1
fi
echo -e "${GREEN}✅ techmage-backend найден${NC}"

if [ ! -d "techmage-front" ]; then
    echo -e "${RED}❌ Директория techmage-front не найдена${NC}"
    exit 1
fi
echo -e "${GREEN}✅ techmage-front найден${NC}"

if [ ! -d "techmage-admin" ]; then
    echo -e "${RED}❌ Директория techmage-admin не найдена${NC}"
    exit 1
fi
echo -e "${GREEN}✅ techmage-admin найден${NC}"

# Проверка Dockerfile'ов
echo -e "${YELLOW}Проверка Dockerfile'ов...${NC}"

if [ ! -f "techmage-backend/Dockerfile" ]; then
    echo -e "${RED}❌ Dockerfile в techmage-backend не найден${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Backend Dockerfile найден${NC}"

if [ ! -f "techmage-front/Dockerfile" ]; then
    echo -e "${RED}❌ Dockerfile в techmage-front не найден${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Frontend Dockerfile найден${NC}"

if [ ! -f "techmage-admin/Dockerfile" ]; then
    echo -e "${RED}❌ Dockerfile в techmage-admin не найден${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Admin Dockerfile найден${NC}"

# Проверка портов
echo -e "${YELLOW}Проверка доступности портов...${NC}"

check_port() {
    local port=$1
    local service=$2
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Порт $port занят (возможно, уже запущен $service)${NC}"
    else
        echo -e "${GREEN}✅ Порт $port свободен${NC}"
    fi
}

check_port 3000 "Frontend"
check_port 3001 "Admin"
check_port 4000 "Backend"
check_port 5432 "PostgreSQL"
check_port 6379 "Redis"
check_port 9000 "MinIO"
check_port 9001 "MinIO Console"

echo ""
echo -e "${GREEN}🎉 Система готова к запуску!${NC}"
echo ""
echo -e "${YELLOW}Для запуска используйте:${NC}"
echo -e "  ${GREEN}make dev-up${NC}     # или docker-compose up -d"
echo ""
echo -e "${YELLOW}Для получения справки:${NC}"
echo -e "  ${GREEN}make help${NC}       # или docker-compose --help"
