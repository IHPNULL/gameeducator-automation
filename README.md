# GameEducator - Automação de testes

Suítes Cucumber de ponta a ponta do GameEducator, rodando contra o
[backend](https://github.com/IHPNULL/gameeducator-backend) e o
[frontend](https://github.com/IHPNULL/gameeducator-frontend) reais, no perfil `automation`
(H2 em memória com dados fixos e mocados — nunca dados de produção).

| Suíte       | Nível        | Stack                              |
|-------------|--------------|------------------------------------|
| `api-tests` | API REST     | Cucumber-JVM + REST-assured (Java) |
| `ui-tests`  | Navegador    | Cucumber.js + Playwright (Node.js) |

**Integrantes (Grupo 6):** Italo Haas Pascoli (190294) · Maria Eduarda Mota Zandonade (200953)

## Como rodar

```bash
# 1. sobe backend (:8080) + frontend (:8081), construídos dos repositórios no GitHub
docker compose -f docker/docker-compose.yml up -d --build
#    usando checkouts locais: BACKEND_CONTEXT=../gameeducator-backend FRONTEND_CONTEXT=../gameeducator-frontend docker compose ...

# 2. API
cd api-tests && ./mvnw test                     # -Dautomation.baseUrl=http://outro:porta

# 3. UI
cd ui-tests && npm ci
npx playwright install --with-deps chromium     # só na 1ª vez
npm test                                        # AUTOMATION_FRONTEND_URL=http://outro

# 4. derruba
docker compose -f docker/docker-compose.yml down -v
```

Relatórios: `api-tests/target/cucumber-report/cucumber-report.html` e `ui-tests/reports/cucumber-report.html`.

O `Jenkinsfile` faz tudo isso containerizado (imagens `docker/api-tests.Dockerfile` e `docker/ui-tests.Dockerfile`).
