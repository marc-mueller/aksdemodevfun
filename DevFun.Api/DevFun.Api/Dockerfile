FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY DevFun.Api/DevFun.Api.csproj DevFun.Api/
COPY DevFun.DataInitializer/DevFun.DataInitializer.csproj DevFun.DataInitializer/
COPY DevFun.Common/DevFun.Common.csproj DevFun.Common/
COPY DevFun.Logic/DevFun.Logic.csproj DevFun.Logic/
COPY DevFun.Storage/DevFun.Storage.csproj DevFun.Storage/
RUN dotnet restore DevFun.Api/DevFun.Api.csproj
COPY . .
WORKDIR /src/DevFun.Api
RUN dotnet build DevFun.Api.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish DevFun.Api.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DevFun.Api.dll"]
