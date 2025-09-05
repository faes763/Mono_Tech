# 🚀 Быстрый старт TechMage NX

## Development режим

```bash
cd Techmage_nx
make dev-up
```

## Production режим

```bash
cd Techmage_nx
make prod-up
```

## Что происходит при запуске

1. **Инфраструктура** (PostgreSQL, Redis, MinIO)
2. **Backend API** с автоматическими миграциями БД
3. **Frontend** приложение
4. **Admin** панель

## Доступные сервисы

- 🌐 **Frontend**: http://localhost:3000
- 🔧 **Admin**: http://localhost:3001  
- 🔌 **Backend API**: http://localhost:4000
- 🗄️ **PostgreSQL**: localhost:5432
- 📦 **Redis**: localhost:6379
- 📁 **MinIO**: http://localhost:9000

## Основные команды

### Development
```bash
make dev-up      # Запустить все в dev режиме
make dev-down    # Остановить все dev сервисы
make dev-logs    # Показать логи dev сервисов
make dev-build   # Пересобрать dev образы
make dev-clean   # Очистить dev данные
```

### Production
```bash
make prod-up     # Запустить все в prod режиме
make prod-down   # Остановить все prod сервисы
make prod-logs   # Показать логи prod сервисов
make prod-build  # Пересобрать prod образы
make prod-clean  # Очистить prod данные
```

### Общие
```bash
make status      # Статус сервисов
make health      # Проверить здоровье
make help        # Все команды
```

## Проверка готовности

```bash
make check       # Проверить систему перед запуском
```

## Остановка

### Development
```bash
make dev-down    # Остановить dev сервисы
make dev-clean   # Полная очистка dev (удалить данные)
```

### Production
```bash
make prod-down   # Остановить prod сервисы
make prod-clean  # Полная очистка prod (удалить данные)
```

## Требования

- Docker
- Docker Compose
- Make (опционально)

## Проблемы?

1. Проверьте: `make check`
2. Посмотрите логи: `make dev-logs` или `make prod-logs`
3. Перезапустите: `make dev-restart` или `make prod-restart`
4. Полная перезагрузка: `make dev-clean && make dev-up` или `make prod-clean && make prod-up`
