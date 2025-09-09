# Docker Build Optimization Guide

## 🚀 Оптимизации сборки Docker образов

### Основные улучшения:

#### 1. **BuildKit кэширование**
- Включен `DOCKER_BUILDKIT=1` для всех команд сборки
- Используется многоуровневое кэширование слоев
- Кэширование зависимостей между сборками

#### 2. **Оптимизированные Dockerfile**
- **Frontend**: Кэширование pnpm store и Next.js cache
- **Backend**: Кэширование bun cache и Prisma cache
- Правильный порядок копирования файлов для максимального кэширования

#### 3. **Новые команды Makefile**

##### Development:
```bash
make dev-build-fast    # Быстрая сборка (только измененные слои)
make dev-build         # Полная сборка с кэшированием
```

##### Production:
```bash
make prod-build-fast   # Быстрая сборка (только измененные слои)
make prod-build        # Полная сборка с кэшированием
make prod-build-sequential  # Последовательная сборка для маломощных систем
```

##### Управление кэшем:
```bash
make cache-clean       # Очистить все Docker кэши
make cache-inspect     # Показать информацию о кэшах
```

### 📊 Ожидаемые улучшения:

#### Время сборки:
- **Первая сборка**: Без изменений
- **Повторная сборка без изменений**: ~90% быстрее
- **Сборка с изменениями в коде**: ~70% быстрее
- **Сборка с изменениями зависимостей**: ~50% быстрее

#### Использование дискового пространства:
- **pnpm store**: Переиспользуется между сборками
- **Next.js cache**: Кэшируется между сборками
- **Bun cache**: Кэшируется между сборками
- **Prisma cache**: Кэшируется между сборками

### 🔧 Технические детали:

#### Frontend оптимизации:
```dockerfile
# Кэширование pnpm store
RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store \
    pnpm config set store-dir /root/.local/share/pnpm/store && \
    pnpm install --frozen-lockfile --prefer-offline

# Кэширование Next.js cache
RUN --mount=type=cache,id=nextjs,target=/app/.next/cache \
    pnpm run build
```

#### Backend оптимизации:
```dockerfile
# Кэширование bun cache
RUN --mount=type=cache,id=bun,target=/root/.bun/install/cache \
    bun install --frozen-lockfile

# Кэширование Prisma cache
RUN --mount=type=cache,id=prisma,target=/root/.cache/prisma \
    bunx prisma generate --schema=./src/database/prisma/schema.prisma
```

### 📁 .dockerignore файлы
Созданы оптимизированные .dockerignore файлы для исключения ненужных файлов из контекста сборки.

### 🎯 Рекомендации по использованию:

1. **Для ежедневной разработки**: Используйте `make dev-build-fast`
2. **Для production деплоя**: Используйте `make prod-build-fast`
3. **При проблемах с кэшем**: Используйте `make cache-clean`
4. **Для маломощных систем**: Используйте `make prod-build-sequential`

### ⚡ Дополнительные оптимизации:

- Параллельная сборка с `--parallel`
- Исключение ненужных файлов через .dockerignore
- Многостадийная сборка для уменьшения размера образов
- Оптимизация порядка команд в Dockerfile
