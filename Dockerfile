# Этап 1: сборка приложения
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Копируем только файлы проектов (для кэширования restore)
COPY *.sln .
COPY MyFirstCI.Api/*.csproj ./MyFirstCI.Api/
COPY MyFirstCI.Tests/*.csproj ./MyFirstCI.Tests/

# Восстанавливаем зависимости
RUN dotnet restore

# Теперь копируем всё остальное
COPY . .

# Публикуем приложение (Release)
RUN dotnet publish MyFirstCI.Api/MyFirstCI.Api.csproj -c Release -o out

# Этап 2: финальный образ
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

# Переменная окружения для ASP.NET Core
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:8080

# Копируем собранное приложение из предыдущего этапа
COPY --from=build /app/out .

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/weatherforecast || exit 1

EXPOSE 8080

ENTRYPOINT ["dotnet", "MyFirstCI.Api.dll"]