# TechMage NX - Единый запуск всех сервисов

Этот проект объединяет все сервисы TechMage в единую Docker-среду для простого развертывания.

## 🚀 Быстрый старт

### Требования
- Docker
- Docker Compose
- Make (опционально, для удобства)

### Запуск одной командой

#### Development режим
```bash
# Перейти в директорию проекта
cd Techmage_nx

# Запустить все сервисы в development
make dev-up
```

#### Production режим
```bash
# Запустить все сервисы в production
make prod-up
```

#### Без Make
```bash
# Development
docker-compose --profile development up -d

# Production
docker-compose --profile production up -d
```

## 📋 Доступные сервисы

После запуска будут доступны:

- **🌐 Frontend**: http://localhost:3000
- **🔧 Admin панель**: http://localhost:3001  
- **🔌 Backend API**: http://localhost:4000
- **🗄️ PostgreSQL**: localhost:5432
- **📦 Redis**: localhost:6379
- **📁 MinIO**: http://localhost:9000 (Console: http://localhost:9001)

## 🛠️ Команды управления

### Development команды
```bash
make dev-up      # Запустить все сервисы в development
make dev-down    # Остановить все development сервисы
make dev-restart # Перезапустить development сервисы
make dev-logs    # Показать логи development сервисов
make dev-build   # Пересобрать development образы
make dev-clean   # Очистить development данные
```

### Production команды
```bash
make prod-up     # Запустить все сервисы в production
make prod-down   # Остановить все production сервисы
make prod-restart # Перезапустить production сервисы
make prod-logs   # Показать логи production сервисов
make prod-build  # Пересобрать production образы
make prod-clean  # Очистить production данные
```

### Общие команды
```bash
make status      # Статус сервисов
make health      # Проверить здоровье сервисов
make check       # Проверить готовность системы
```

### Разработка
```bash
make dev-shell   # Подключиться к backend контейнеру
make db-migrate  # Выполнить миграции базы данных
make db-studio   # Открыть Prisma Studio
```

### Логи отдельных сервисов
```bash
make backend-logs  # Логи backend
make frontend-logs # Логи frontend
make admin-logs    # Логи admin
```

## 🔧 Конфигурация

Все переменные окружения находятся в файле `.env` в корне проекта.

### Основные настройки:
- `POSTGRES_USER/PASSWORD/DB` - настройки PostgreSQL
- `NEXT_PUBLIC_API_URL` - URL backend API для фронтенда
- `DISCORD_CLIENT_ID/SECRET` - настройки Discord OAuth
- `X_CLIENT_ID/SECRET` - настройки X (Twitter) OAuth
- `MINIO_ROOT_USER/PASSWORD` - настройки MinIO

## 🏗️ Архитектура

```
Techmage_nx/
├── docker-compose.yml    # Единая конфигурация всех сервисов
├── .env                  # Переменные окружения
├── Makefile             # Команды управления
├── techmage-backend/    # Backend API (Bun + Express)
├── techmage-front/      # Frontend (Next.js)
└── techmage-admin/      # Admin панель (Next.js)
```

## 🔄 Порядок запуска

1. **Инфраструктура**: PostgreSQL, Redis, MinIO
2. **Backend**: API сервер с миграциями БД (development или production)
3. **Frontend**: Пользовательский интерфейс (development или production)
4. **Admin**: Административная панель (development или production)

### Профили Docker Compose

- **development**: Запускает сервисы с dev настройками
- **production**: Запускает сервисы с prod настройками

## 🐛 Отладка

### Проверка статуса
```bash
make status
```

### Просмотр логов
```bash
# Development
make dev-logs
# Production
make prod-logs
# или для конкретного сервиса
make backend-logs
```

### Проверка здоровья
```bash
make health
```

### Полная перезагрузка
```bash
# Development
make dev-clean && make dev-up
# Production
make prod-clean && make prod-up
```

## 📝 Примечания

- Все данные сохраняются в Docker volumes
- При первом запуске выполняются миграции базы данных
- Сервисы автоматически перезапускаются при сбоях
- Сеть `techmage-network` обеспечивает связь между контейнерами
