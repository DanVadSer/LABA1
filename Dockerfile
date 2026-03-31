# Этап сборки
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# --- Требование 1: слой dotnet restore выполняется только при изменении .csproj ---
COPY MyFirstCI.Api/*.csproj MyFirstCI.Api/
COPY MyFirstCI.Tests/*.csproj MyFirstCI.Tests/
COPY MyFirstCI.sln .

RUN dotnet restore
# --- конец требования 1 ---

# --- Требование 2: копирование исходного кода ПОСЛЕ восстановления ---
COPY . .
# --- конец требования 2 ---

RUN dotnet publish MyFirstCI.Api/MyFirstCI.Api.csproj -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "MyFirstCI.Api.dll"]

# Установка curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/out .

# HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/weatherforecast || exit 1

ENTRYPOINT ["dotnet", "MyFirstCI.Api.dll"]