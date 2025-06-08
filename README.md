### Начало работы

### Установка зависимостей
```bash
flutter pub get
flutter build
```

### Запуск приложения под Windows
```bash
flutter run -d windows --release
```

### Сборка приложения под Android (универсальный .apk)
```bash
flutter build apk --target-platform android-arm,android-arm64,android-x64
```

### Сборка приложения под Android (разделить на .apk по архитектурам)
```bash
flutter build apk --split-per-abi
```

### Очистка проекта
```bash
flutter clean
```

