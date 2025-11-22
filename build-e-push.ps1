# build-e-push.ps1

$registry = "eniwhere.azurecr.io"
$tag = "v10"

$ErrorActionPreference = "Stop"

Write-Host "Iniciando o build e push para o registro: $registry"
Write-Host "----------------------------------------------------"

Write-Host "Garantindo que você está logado no ACR..."
az acr login --name eniwhere

Write-Host ""
Write-Host ">>> Construindo landingpage..."
docker build -t "$registry/landingpage:$tag" ./landingpage
Write-Host ">>> Enviando landingpage..."
docker push "$registry/landingpage:$tag"

Write-Host ""
Write-Host ">>> Construindo frontend-app..."
docker build -t "$registry/frontend-app:$tag" ./frontend
Write-Host ">>> Enviando frontend-app..."
docker push "$registry/frontend-app:$tag"

Write-Host ""
Write-Host ">>> Construindo backend-app..."
docker build -t "$registry/backend-app:$tag" ./backend
Write-Host ">>> Enviando backend-app..."
docker push "$registry/backend-app:$tag"

Write-Host ""
Write-Host ">>> Construindo enithing-backend..."
docker build -t "$registry/enithing-backend:$tag" ./enithing-backend
Write-Host ">>> Enviando enithing-backend..."
docker push "$registry/enithing-backend:$tag"

Write-Host ""
Write-Host "----------------------------------------------------"
Write-Host "SUCESSO! Todas as imagens foram enviadas para o Azure."
Write-Host "Próximo passo: rode o comando 'az containerapp compose create...'"