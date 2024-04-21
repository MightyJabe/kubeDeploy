# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy everything and build the application
COPY . ./
RUN dotnet clean
RUN dotnet build -c Release -r linux-x64 --no-self-contained
RUN dotnet publish -c Release -r linux-x64 --no-self-contained -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build-env /app/out ./

# Set the command to run your app using the ENTRYPOINT
ENTRYPOINT ["dotnet", "SimpleWebAppMVC.dll"]
