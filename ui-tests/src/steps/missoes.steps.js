import { When } from '@cucumber/cucumber';

When('respondo a alternativa {string} do desafio {string}', async function (alternativa, enunciado) {
  const desafio = this.page.locator('div', { hasText: enunciado });
  await desafio.getByRole('button', { name: alternativa, exact: true }).click();
});
