# Отчет по заданию №1. Пункт №5

## 1. Внесённая ошибка
Удалил ; в файле WeatherController.cs

## 2. Анализ логов GitHub Actions
Workflow упал на шаге **Build Solution**. В логах обнаружено сообщение об ошибке:
Run dotnet build --no-restore --configuration Release
Error: /home/runner/work/LABA1/LABA1/MyFirstCI.Api/Controllers/WeatherController.cs(18,24): error CS1002: ; expected [/home/runner/work/LABA1/LABA1/MyFirstCI.Api/MyFirstCI.Api.csproj]

Build FAILED.

Error: /home/runner/work/LABA1/LABA1/MyFirstCI.Api/Controllers/WeatherController.cs(18,24): error CS1002: ; expected [/home/runner/work/LABA1/LABA1/MyFirstCI.Api/MyFirstCI.Api.csproj]
    0 Warning(s)
    1 Error(s)

Time Elapsed 00:00:04.41
Error: Process completed with exit code 1.


## 3. Причина падения
Ошибка произошла на этапе компиляции (`dotnet build`), так как синтаксис C# требует точку с запятой для завершения оператора. Её отсутствие не позволило скомпилировать проект.

## 4. Исправление
Вернул пропущенную ; в файл `WeatherController.cs`. После коммита и пуша workflow перезапустился и завершился успешно.