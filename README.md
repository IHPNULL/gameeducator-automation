# GameEducator - Automação de testes

Suítes Cucumber de ponta a ponta (End-to-End) do GameEducator, rodando contra o
[backend](https://github.com/IHPNULL/gameeducator-backend) e o
[frontend](https://github.com/IHPNULL/gameeducator-frontend) reais, no perfil `automation`
(H2 em memória com dados fixos e mocados via `AutomationSeedData` — nunca dados de produção).

| Suíte       | Nível        | Stack                              | Cobertura E2E |
|-------------|--------------|------------------------------------|---------------|
| `api-tests` | API REST     | Cucumber-JVM + REST-assured (Java 21) | Missões, Jogo/Respostas, Ranking, Notas, Fórum e Turma |
| `ui-tests`  | Navegador    | Cucumber.js + Playwright (Node.js)    | Missões, Nova Missão, Ranking e Medalhas, Notas, Fórum e Painel do Professor |

**Integrantes (Grupo 6):** Italo Haas Pascoli (190294) · Maria Eduarda Mota Zandonade (200953)

## Setup local (4 repositórios lado a lado)

```
gameeducator/                 # pasta raiz
├── gameeducator-backend      # API REST Core + Jenkins local (jenkins/) + Mini-labs (labs/)
├── gameeducator-frontend     # app Vue (estacao de trabalho anos 90)
├── gameeducator-ia           # servico de IA Python (FastAPI)
└── gameeducator-automation   # suítes Cucumber (API + UI)
```

```bash
mkdir gameeducator && cd gameeducator
for r in backend frontend ia automation; do git clone https://github.com/IHPNULL/gameeducator-$r.git; done
```

## Como rodar

### Opção 1: Execução Automatizada via Script

```bash
./scripts/run-e2e.sh
```

### Opção 2: Passo a Passo Manual

```bash
# 1. Sobe backend (:8080) + frontend (:8081), construídos dos repositórios
docker compose -f docker/docker-compose.yml up -d --build
#    usando os checkouts locais em vez do GitHub: cp .env.example docker/.env (antes do comando acima)

# 2. API (Cucumber-JVM)
cd api-tests && ./mvnw test                     # -Dautomation.baseUrl=http://localhost:8080

# 3. UI (Cucumber.js + Playwright)
cd ui-tests && npm ci
npx playwright install --with-deps chromium     # só na 1ª vez
AUTOMATION_FRONTEND_URL=http://localhost:8081 npm test

# 4. Finalização
docker compose -f docker/docker-compose.yml down -v
```

Relatórios gerados:
- **API:** `api-tests/target/cucumber-report/cucumber-report.html` e `target/surefire-reports/*.xml`
- **UI:** `ui-tests/reports/cucumber-report.html` e `ui-tests/reports/junit-report.xml`

## Pipelines de CI / CD

1. **GitHub Actions ([`.github/workflows/e2e-pipeline.yml`](.github/workflows/e2e-pipeline.yml)):**
   - Disparado em push e PR nas branches `main` e `b1-architecture-lab`.
   - Faz checkout coordenado de automação, backend e frontend.
   - Sobe os serviços no perfil `automation`, executa as suítes de API e UI e publica os relatórios de teste como artefatos.

2. **Jenkins Local ([`Jenkinsfile`](Jenkinsfile)):**
   - Executa as suítes em containers isolados na mesma rede Docker (`gameeducator-api-tests` e `gameeducator-ui-tests`).
   - Encadeado automaticamente após sucesso dos builds de `gameeducator-backend` e `gameeducator-frontend`.
   - Inclui estágio de Fake Deploy para validar a integridade de release.
