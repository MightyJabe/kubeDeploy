FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY . .
RUN dotnet publish -c Release -o out
ENTRYPOINT ["dotnet", "out/ApnaBank.dll"]
