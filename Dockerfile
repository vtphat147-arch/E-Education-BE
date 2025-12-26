# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY E-Education.API/E-Education.API.csproj E-Education.API/
RUN dotnet restore E-Education.API/E-Education.API.csproj

# Copy everything and build
COPY E-Education.API/ E-Education.API/
WORKDIR /src/E-Education.API
RUN dotnet build E-Education.API.csproj -c Release -o /app/build

# Publish
FROM build AS publish
WORKDIR /src/E-Education.API
RUN dotnet publish E-Education.API.csproj -c Release -o /app/publish /p:UseAppHost=false

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
EXPOSE 8080

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "E-Education.API.dll"]

