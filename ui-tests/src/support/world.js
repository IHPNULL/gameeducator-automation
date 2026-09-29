import { setWorldConstructor, World } from '@cucumber/cucumber';

const BASE_URL = process.env.AUTOMATION_FRONTEND_URL ?? 'http://localhost:8081';

/**
 * Estado compartilhado entre os step definitions de um mesmo cenario: a pagina
 * Playwright atual e a URL base do frontend (que roda contra o backend "automation",
 * com H2 em memoria e dados mocados - ver AutomationSeedData no backend).
 */
class GameEducatorWorld extends World {
  baseUrl = BASE_URL;
  page;
}

setWorldConstructor(GameEducatorWorld);
