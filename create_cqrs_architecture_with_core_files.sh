#!/bin/bash

# Proje adı
PROJECT_NAME="TestProject"

# Ana proje dizinini oluştur
mkdir -p src
cd src

# 1. API Katmanı (Web API projesi oluştur)
dotnet new webapi -n ${PROJECT_NAME}.API
cd ${PROJECT_NAME}.API
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.Extensions.DependencyInjection
dotnet add package MediatR
dotnet add package FluentValidation
mkdir -p Controllers Middlewares Models
cd ..

# 2. Application Katmanı (CQRS ve Command/Query işlemleri için Class Library)
dotnet new classlib -n ${PROJECT_NAME}.Application
cd ${PROJECT_NAME}.Application
dotnet add package MediatR
dotnet add package FluentValidation
mkdir -p Commands Queries DTOs Validators
cd ..

# 3. Domain Katmanı (Entity ve Unit of Work yapısı için Class Library)
dotnet new classlib -n ${PROJECT_NAME}.Domain
cd ${PROJECT_NAME}.Domain
mkdir -p Entities Repositories UnitOfWork ValueObjects Services Events

# Core dosyaları oluştur
touch Entities/BaseEntity.cs
touch Repositories/IRepository.cs
touch Repositories/Repository.cs
touch UnitOfWork/IUnitOfWork.cs
touch UnitOfWork/UnitOfWork.cs

cd ..

# 4. Infrastructure Katmanı (Persistence ve Repository Implementasyonları için Class Library)
dotnet new classlib -n ${PROJECT_NAME}.Infrastructure
cd ${PROJECT_NAME}.Infrastructure
dotnet add package Microsoft.EntityFrameworkCore
mkdir -p Persistence Repositories Configurations Migrations
cd ..

# 5. Projeleri birbirine referans ekleme
cd ${PROJECT_NAME}.API
dotnet add reference ../${PROJECT_NAME}.Application/${PROJECT_NAME}.Application.csproj
dotnet add reference ../${PROJECT_NAME}.Domain/${PROJECT_NAME}.Domain.csproj
dotnet add reference ../${PROJECT_NAME}.Infrastructure/${PROJECT_NAME}.Infrastructure.csproj
cd ..

cd ${PROJECT_NAME}.Application
dotnet add reference ../${PROJECT_NAME}.Domain/${PROJECT_NAME}.Domain.csproj
cd ..

cd ${PROJECT_NAME}.Infrastructure
dotnet add reference ../${PROJECT_NAME}.Domain/${PROJECT_NAME}.Domain.csproj
cd ..

# Çıktı mesajı
echo ".NET Core DDD proje dizini ve gerekli dosyalar başarıyla oluşturuldu!"
