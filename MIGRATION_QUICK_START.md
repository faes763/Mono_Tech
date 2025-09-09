# 🚀 Быстрый старт: Миграции базы данных

## ⚡ Основные команды для ежедневной работы:

### 1. **Создание новой миграции:**
```bash
# Измените schema.prisma, затем:
make db-migrate-create MIGRATION_NAME=add_user_table
```

### 2. **Применение миграций:**
```bash
make db-migrate-dev    # Для development
make db-migrate-prod   # Для production
```

### 3. **Быстрое прототипирование:**
```bash
# Измените schema.prisma и примените без миграций:
make db-push
```

### 4. **Просмотр данных:**
```bash
make db-studio         # Открыть Prisma Studio
```

### 5. **Проверка статуса:**
```bash
make db-migrate-status # Какие миграции применены
```

## 🎯 **Типичный workflow:**

```bash
# 1. Измените src/database/prisma/schema.prisma
# 2. Создайте миграцию
make db-migrate-create MIGRATION_NAME=my_changes

# 3. Примените миграцию
make db-migrate-dev

# 4. Проверьте результат
make db-studio
```

## ⚠️ **Важно:**
- Всегда тестируйте миграции в development перед production
- Используйте `make db-backup` перед важными изменениями
- Команда `make db-migrate-reset` удаляет все данные!

## 📚 **Полная документация:**
```bash
make docs-migrations   # Показать полную документацию
```
