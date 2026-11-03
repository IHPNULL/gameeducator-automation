#!/usr/bin/env bash
# Script para executar a esteira E2E (API + UI) localmente via Docker Compose
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"

echo "=== INICIANDO PIPELINE DE TESTES END-TO-END (GAMEEDUCATOR) ==="

# 1. Build e subida dos containers em perfil automation
echo "1. Subindo backend e frontend conteinerizados..."
docker compose -f docker/docker-compose.yml up -d --build backend frontend

# 2. Aguarda backend e frontend estarem prontos
echo "2. Aguardando prontidao dos servicos..."
for i in $(seq 1 45); do
    if curl -fs http://localhost:8080/actuator/health >/dev/null 2>&1 && curl -fs http://localhost:8081 >/dev/null 2>&1; then
        echo "Servicos no ar com sucesso!"
        break
    fi
    sleep 2
done

# 3. Execucao da suite de API
echo "3. Executando suite E2E de API (Cucumber-JVM + REST-assured)..."
cd api-tests
./mvnw test -Dautomation.baseUrl=http://localhost:8080
cd ..

# 4. Execucao da suite de UI
echo "4. Executando suite E2E de UI (Playwright + Cucumber.js)..."
cd ui-tests
npm ci
npx playwright install --with-deps chromium
AUTOMATION_FRONTEND_URL=http://localhost:8081 npm test
cd ..

echo "=== PIPELINE E2E CONCLUIDO COM SUCESSO! ==="
