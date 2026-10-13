# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

End-to-end automation for GameEducator. Two Cucumber suites run against the real apps from the separate `gameeducator-backend` and `gameeducator-frontend` repos, started in the backend's `automation` Spring profile (H2 `create-drop`, fixed data from `AutomationSeedData` in the backend repo). If a feature needs different data, change that seeder in the backend repo and keep the features here in sync. Code and features are in Portuguese (no accents in code).

## Commands

```bash
docker compose -f docker/docker-compose.yml up -d --build   # backend :8080 + frontend :8081 (built from GitHub; override with BACKEND_CONTEXT / FRONTEND_CONTEXT)
cd api-tests && ./mvnw test                                  # Cucumber-JVM + REST-assured; -Dautomation.baseUrl=... to override
cd ui-tests && npm ci && npx playwright install --with-deps chromium && npm test   # Cucumber.js + Playwright; AUTOMATION_FRONTEND_URL=... to override
docker compose -f docker/docker-compose.yml down -v
```

Local sources instead of GitHub: `cp .env.example docker/.env`. In the local Jenkins (defined in the backend repo's `jenkins/`) the job `gameeducator-automation` builds backend/frontend from `/src/gameeducator-*` and auto-triggers after the backend or frontend job succeeds.

Reports: `api-tests/target/cucumber-report/`, `ui-tests/reports/`.

## Structure

- `api-tests/src/test/resources/features/*.feature` with steps in `.../automation/steps` and shared state in `.../automation/support` (`ApiContext`, `Fixture`); runner `RunCucumberTest`.
- `ui-tests/src/features/*.feature` with steps in `src/steps`, Playwright hooks/world in `src/support`; config in `cucumber.js`.
- `docker/api-tests.Dockerfile` (context `api-tests/`) and `docker/ui-tests.Dockerfile` (context `ui-tests/`, Playwright image version must match `@playwright/test` in `package-lock.json`). The `Jenkinsfile` builds both, starts the apps via compose and runs the suites on the compose network; the backend must allow CORS origin `http://frontend` (set in the compose file).
