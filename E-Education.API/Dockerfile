# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY E-Education.API.csproj .
RUN dotnet restore E-Education.API.csproj

# Copy everything and build
COPY . .
RUN dotnet build E-Education.API.csproj -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish E-Education.API.csproj -c Release -o /app/publish /p:UseAppHost=false

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
EXPOSE 8080

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "E-Education.API.dll"]
