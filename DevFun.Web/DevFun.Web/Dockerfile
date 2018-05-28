FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY DevFun.Web/DevFun.Web.csproj DevFun.Web/
RUN dotnet restore DevFun.Web/DevFun.Web.csproj
COPY . .
WORKDIR /src/DevFun.Web
RUN dotnet build DevFun.Web.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish DevFun.Web.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DevFun.Web.dll"]
