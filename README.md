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

## Setup local (3 repositórios lado a lado)

```
gameeducator/                 # qualquer pasta
├── gameeducator-backend      # API + Jenkins local (jenkins/)
├── gameeducator-frontend     # app Vue
└── gameeducator-automation   # suítes Cucumber (API + UI)
```

```bash
mkdir gameeducator && cd gameeducator
for r in backend frontend automation; do git clone https://github.com/IHPNULL/gameeducator-$r.git; done
```

## Como rodar

```bash
# 1. sobe backend (:8080) + frontend (:8081), construídos dos repositórios no GitHub
docker compose -f docker/docker-compose.yml up -d --build
#    usando os checkouts locais em vez do GitHub: cp .env.example docker/.env (antes do comando acima)

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
