# TechMage NX - Единая команда для запуска всего проекта

.PHONY: help dev-up dev-down dev-restart dev-logs dev-build dev-clean status check prod-up prod-down prod-restart prod-logs prod-build prod-clean

# Цвета для вывода
GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m # No Color

help: ## Показать справку по командам
	@echo "$(GREEN)TechMage NX - Команды управления$(NC)"
	@echo ""
	@echo "$(YELLOW)Основные команды:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)📚 Документация:$(NC)"
	@echo "  $(GREEN)DATABASE_MIGRATIONS.md$(NC) - Работа с миграциями"
	@echo "  $(GREEN)DOCKER_OPTIMIZATION.md$(NC) - Оптимизация Docker сборки"

check: ## Проверить готовность системы к запуску
	@echo "$(GREEN)🔍 Проверка готовности системы...$(NC)"
	@./check-setup.sh

docs-migrations: ## Показать документацию по миграциям
	@echo "$(GREEN)📚 Документация по миграциям базы данных:$(NC)"
	@cat DATABASE_MIGRATIONS.md

docs-docker: ## Показать документацию по оптимизации Docker
	@echo "$(GREEN)📚 Документация по оптимизации Docker:$(NC)"
	@cat DOCKER_OPTIMIZATION.md

dev-up: ## Запустить все сервисы в development режиме
	@echo "$(GREEN)🚀 Запуск TechMage NX в development режиме...$(NC)"
	@docker-compose --profile development up -d
	@echo "$(GREEN)✅ Все сервисы запущены в development!$(NC)"
	@echo ""
	@echo "$(YELLOW)Доступные сервисы:$(NC)"
	@echo "  🌐 Frontend:    http://localhost:3000"
	@echo "  🔧 Admin:       http://localhost:3001"
	@echo "  🔌 Backend API: http://localhost:4000"
	@echo "  🗄️  PostgreSQL:  localhost:5432"
	@echo "  📦 Redis:       localhost:6379"
	@echo "  📁 MinIO:       http://localhost:9000 (Console: http://localhost:9001)"

dev-down: ## Остановить все development сервисы
	@echo "$(YELLOW)🛑 Остановка всех development сервисов...$(NC)"
	@docker-compose --profile development down
	@echo "$(GREEN)✅ Все development сервисы остановлены$(NC)"

dev-restart: ## Перезапустить все development сервисы
	@echo "$(YELLOW)🔄 Перезапуск development сервисов...$(NC)"
	@docker-compose --profile development restart
	@echo "$(GREEN)✅ Development сервисы перезапущены$(NC)"

dev-logs: ## Показать логи всех development сервисов
	@docker-compose --profile development logs -f

dev-build: ## Пересобрать все development образы
	@echo "$(YELLOW)🔨 Пересборка development образов с BuildKit кэшированием...$(NC)"
	@export $(cat docker.env | xargs) && docker-compose --profile development build
	@echo "$(GREEN)✅ Development образы пересобраны$(NC)"

dev-build-fast: ## Быстрая пересборка development образов (только измененные слои)
	@echo "$(YELLOW)⚡ Быстрая пересборка development образов...$(NC)"
	@export $(cat docker.env | xargs) && docker-compose --profile development build --parallel
	@echo "$(GREEN)✅ Development образы быстро пересобраны$(NC)"

dev-clean: ## Полная очистка development (остановка + удаление контейнеров, сетей, томов)
	@echo "$(RED)🧹 Полная очистка development Docker...$(NC)"
	@docker-compose --profile development down -v --remove-orphans
	@docker system prune -f
	@echo "$(GREEN)✅ Development очистка завершена$(NC)"

status: ## Показать статус всех сервисов
	@echo "$(GREEN)📊 Статус сервисов:$(NC)"
	@docker-compose ps

# Команды для отдельных сервисов
backend-logs: ## Показать логи только backend
	@docker-compose logs -f backend

frontend-logs: ## Показать логи только frontend
	@docker-compose logs -f frontend

admin-logs: ## Показать логи только admin
	@docker-compose logs -f admin

# Команды для базы данных
db-migrate: ## Выполнить миграции базы данных
	@echo "$(YELLOW)🗄️ Выполнение миграций...$(NC)"
	@docker-compose exec backend bunx prisma migrate deploy --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ Миграции выполнены$(NC)"

db-migrate-dev: ## Выполнить миграции в development контейнере
	@echo "$(YELLOW)🗄️ Выполнение миграций в development...$(NC)"
	@docker-compose --profile development exec backend bunx prisma migrate deploy --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ Development миграции выполнены$(NC)"

db-migrate-prod: ## Выполнить миграции в production контейнере
	@echo "$(YELLOW)🗄️ Выполнение миграций в production...$(NC)"
	@docker-compose --profile production exec backend-prod bunx prisma migrate deploy --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ Production миграции выполнены$(NC)"

db-migrate-create: ## Создать новую миграцию (введите MIGRATION_NAME=название)
	@echo "$(YELLOW)📝 Создание новой миграции: $(MIGRATION_NAME)...$(NC)"
	@docker-compose exec backend bunx prisma migrate dev --name $(MIGRATION_NAME) --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ Миграция $(MIGRATION_NAME) создана$(NC)"

db-migrate-reset: ## Сбросить базу данных и применить все миграции
	@echo "$(RED)⚠️ Сброс базы данных и применение миграций...$(NC)"
	@docker-compose exec backend bunx prisma migrate reset --force --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ База данных сброшена и миграции применены$(NC)"

db-migrate-status: ## Показать статус миграций
	@echo "$(GREEN)📊 Статус миграций:$(NC)"
	@docker-compose exec backend bunx prisma migrate status --schema=./src/database/prisma/schema.prisma

db-studio: ## Открыть Prisma Studio
	@echo "$(GREEN)🔍 Запуск Prisma Studio...$(NC)"
	@docker-compose exec backend bunx prisma studio --schema=./src/database/prisma/schema.prisma

db-studio-prod: ## Открыть Prisma Studio для production
	@echo "$(GREEN)🔍 Запуск Prisma Studio для production...$(NC)"
	@docker-compose --profile production exec backend-prod bunx prisma studio --schema=./src/database/prisma/schema.prisma

# Дополнительные команды для базы данных
db-generate: ## Сгенерировать Prisma клиент
	@echo "$(YELLOW)🔧 Генерация Prisma клиента...$(NC)"
	@docker-compose exec backend bunx prisma generate --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ Prisma клиент сгенерирован$(NC)"

db-push: ## Применить изменения схемы к базе данных (без миграций)
	@echo "$(YELLOW)📤 Применение изменений схемы к базе данных...$(NC)"
	@docker-compose exec backend bunx prisma db push --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ Изменения схемы применены$(NC)"

db-pull: ## Извлечь схему из существующей базы данных
	@echo "$(YELLOW)📥 Извлечение схемы из базы данных...$(NC)"
	@docker-compose exec backend bunx prisma db pull --schema=./src/database/prisma/schema.prisma
	@echo "$(GREEN)✅ Схема извлечена$(NC)"

db-seed: ## Заполнить базу данных тестовыми данными
	@echo "$(YELLOW)🌱 Заполнение базы данных тестовыми данными...$(NC)"
	@docker-compose exec backend bun run seed
	@echo "$(GREEN)✅ База данных заполнена тестовыми данными$(NC)"

db-backup: ## Создать резервную копию базы данных
	@echo "$(YELLOW)💾 Создание резервной копии базы данных...$(NC)"
	@docker-compose exec postgres pg_dump -U ${POSTGRES_USER:-ciel} -d ${POSTGRES_DB:-techmage} > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Резервная копия создана$(NC)"

db-restore: ## Восстановить базу данных из резервной копии (введите BACKUP_FILE=файл.sql)
	@echo "$(YELLOW)🔄 Восстановление базы данных из $(BACKUP_FILE)...$(NC)"
	@docker-compose exec -T postgres psql -U ${POSTGRES_USER:-ciel} -d ${POSTGRES_DB:-techmage} < $(BACKUP_FILE)
	@echo "$(GREEN)✅ База данных восстановлена$(NC)"

# Команды для разработки
dev-shell: ## Подключиться к контейнеру backend для разработки
	@docker-compose exec backend sh

dev-shell-prod: ## Подключиться к production контейнеру backend
	@docker-compose --profile production exec backend-prod sh

dev-shell-db: ## Подключиться к контейнеру PostgreSQL
	@docker-compose exec postgres psql -U ${POSTGRES_USER:-ciel} -d ${POSTGRES_DB:-techmage}

# ===========================================
# PRODUCTION КОМАНДЫ
# ===========================================

prod-up: ## Запустить все сервисы в production режиме
	@echo "$(GREEN)🚀 Запуск TechMage NX в production режиме...$(NC)"
	@echo "$(YELLOW)🧹 Очистка Docker кэша перед запуском...$(NC)"
	@docker system prune -f
	@docker-compose --profile production up -d
	@echo "$(GREEN)✅ Все сервисы запущены в production!$(NC)"
	@echo ""
	@echo "$(YELLOW)Доступные сервисы:$(NC)"
	@echo "  🌐 Frontend:    http://localhost:3000"
	@echo "  🔧 Admin:       http://localhost:3001"
	@echo "  🔌 Backend API: http://localhost:4000"
	@echo "  🗄️  PostgreSQL:  localhost:5432"
	@echo "  📦 Redis:       localhost:6379"
	@echo "  📁 MinIO:       http://localhost:9000 (Console: http://localhost:9001)"

prod-up-low-memory: ## Запустить production с оптимизацией для маломощных систем (2GB RAM)
	@echo "$(GREEN)🚀 Запуск TechMage NX в production режиме (оптимизация для 2GB RAM)...$(NC)"
	@echo "$(YELLOW)🧹 Очистка Docker кэша перед запуском...$(NC)"
	@docker system prune -f
	@echo "$(YELLOW)🔨 Последовательная сборка и запуск...$(NC)"
	@docker-compose build backend-prod --no-cache
	@docker-compose up -d postgres redis minio backend-prod
	@echo "$(YELLOW)⏳ Ожидание запуска backend...$(NC)"
	@sleep 30
	@docker-compose build frontend-prod --no-cache
	@docker-compose up -d frontend-prod
	@docker-compose build admin-prod --no-cache
	@docker-compose up -d admin-prod
	@echo "$(GREEN)✅ Все сервисы запущены в production!$(NC)"
	@echo ""
	@echo "$(YELLOW)Доступные сервисы:$(NC)"
	@echo "  🌐 Frontend:    http://localhost:3000"
	@echo "  🔧 Admin:       http://localhost:3001"
	@echo "  🔌 Backend API: http://localhost:4000"
	@echo "  🗄️  PostgreSQL:  localhost:5432"
	@echo "  📦 Redis:       localhost:6379"
	@echo "  📁 MinIO:       http://localhost:9000 (Console: http://localhost:9001)"

prod-down: ## Остановить все production сервисы
	@echo "$(YELLOW)🛑 Остановка всех production сервисов...$(NC)"
	@docker-compose --profile production down
	@echo "$(GREEN)✅ Все production сервисы остановлены$(NC)"

prod-restart: ## Перезапустить все production сервисы
	@echo "$(YELLOW)🔄 Перезапуск production сервисов...$(NC)"
	@docker-compose --profile production restart
	@echo "$(GREEN)✅ Production сервисы перезапущены$(NC)"

prod-logs: ## Показать логи всех production сервисов
	@docker-compose --profile production logs -f

prod-build: ## Пересобрать все production образы
	@echo "$(YELLOW)🔨 Пересборка production образов с BuildKit кэшированием...$(NC)"
	@echo "$(YELLOW)🧹 Очистка Docker кэша...$(NC)"
	@docker system prune -f
	@docker builder prune -f
	@echo "$(YELLOW)🔨 Сборка production образов...$(NC)"
	@export $(cat docker.env | xargs) && docker-compose --profile production build
	@echo "$(GREEN)✅ Production образы пересобраны$(NC)"

prod-build-fast: ## Быстрая пересборка production образов (только измененные слои)
	@echo "$(YELLOW)⚡ Быстрая пересборка production образов...$(NC)"
	@export $(cat docker.env | xargs) && docker-compose --profile production build --parallel
	@echo "$(GREEN)✅ Production образы быстро пересобраны$(NC)"

prod-build-sequential: ## Пересобрать production образы последовательно (для маломощных систем)
	@echo "$(YELLOW)🔨 Последовательная сборка production образов с BuildKit...$(NC)"
	@echo "$(YELLOW)🧹 Очистка Docker кэша...$(NC)"
	@docker system prune -f
	@docker builder prune -f
	@echo "$(YELLOW)🔨 Сборка backend...$(NC)"
	@export $(cat docker.env | xargs) && docker-compose build backend-prod
	@echo "$(YELLOW)🔨 Сборка frontend...$(NC)"
	@export $(cat docker.env | xargs) && docker-compose build frontend-prod
	@echo "$(YELLOW)🔨 Сборка admin...$(NC)"
	@export $(cat docker.env | xargs) && docker-compose build admin-prod
	@echo "$(GREEN)✅ Все production образы пересобраны последовательно$(NC)"

prod-clean: ## Полная очистка production (остановка + удаление контейнеров, сетей, томов)
	@echo "$(RED)🧹 Полная очистка production Docker...$(NC)"
	@docker-compose --profile production down -v --remove-orphans
	@docker system prune -f
	@echo "$(GREEN)✅ Production очистка завершена$(NC)"

prod-status: ## Показать статус всех production сервисов
	@echo "$(GREEN)📊 Статус production сервисов:$(NC)"
	@docker-compose --profile production ps

# Управление кэшем
cache-clean: ## Очистить все Docker кэши
	@echo "$(YELLOW)🧹 Очистка всех Docker кэшей...$(NC)"
	@docker builder prune -f
	@docker system prune -f
	@echo "$(GREEN)✅ Кэши очищены$(NC)"

cache-inspect: ## Показать информацию о Docker кэшах
	@echo "$(GREEN)📊 Информация о Docker кэшах:$(NC)"
	@docker system df
	@echo ""
	@echo "$(YELLOW)BuildKit кэши:$(NC)"
	@docker buildx du

# Проверка здоровья сервисов
health: ## Проверить здоровье всех сервисов
	@echo "$(GREEN)🏥 Проверка здоровья сервисов:$(NC)"
	@echo ""
	@echo "$(YELLOW)Backend API:$(NC)"
	@curl -s http://localhost:4000/health || echo "$(RED)❌ Backend недоступен$(NC)"
	@echo ""
	@echo "$(YELLOW)Frontend:$(NC)"
	@curl -s http://localhost:3000 > /dev/null && echo "$(GREEN)✅ Frontend доступен$(NC)" || echo "$(RED)❌ Frontend недоступен$(NC)"
	@echo ""
	@echo "$(YELLOW)Admin:$(NC)"
	@curl -s http://localhost:3001 > /dev/null && echo "$(GREEN)✅ Admin доступен$(NC)" || echo "$(RED)❌ Admin недоступен$(NC)"
