FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["./Catalog.csproj", "src/"]
RUN dotnet restore "src/Catalog.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "Catalog.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "Catalog.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

#For running docker locally uncomment this and commnet last lines
#ENTRYPOINT ["dotnet", "Catalog.dll"]

CMD export ASPNETCORE_URLS=http://*:$PORT
RUN echo 'we are running some # of cool things'

CMD ASPNETCORE_URLS=http://*:$PORT dotnet Catalog.dll
