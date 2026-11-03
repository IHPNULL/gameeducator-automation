import { Then } from '@cucumber/cucumber';
import assert from 'node:assert/strict';

Then('a linha do aluno {string} esta destacada no ranking', async function (nomeAluno) {
  const linha = this.page.locator('tr.ranking-eu');
  await linha.waitFor();
  const texto = await linha.textContent();
  assert.match(texto, new RegExp(nomeAluno), `A linha destacada deveria conter "${nomeAluno}"`);
});
