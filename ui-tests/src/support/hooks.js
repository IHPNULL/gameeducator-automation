import { AfterAll, BeforeAll, Before, After } from '@cucumber/cucumber';
import { chromium } from '@playwright/test';

let browser;

BeforeAll(async function () {
  // PLAYWRIGHT_CHROMIUM_EXECUTABLE: opcional, aponta para um Chromium ja instalado
  // (ex.: ambientes com o browser pre-empacotado) em vez de baixar um novo.
  const executablePath = process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE;
  browser = await chromium.launch(executablePath ? { executablePath } : {});
});

AfterAll(async function () {
  await browser.close();
});

Before(async function () {
  this.page = await browser.newPage();
});

After(async function () {
  await this.page.close();
});
