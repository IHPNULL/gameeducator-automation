import { Given, When, Then } from '@cucumber/cucumber';
import assert from 'node:assert/strict';
import { ALUNO_DOIS_ID, ALUNO_UM_ID, PROFESSOR_ID } from '../support/fixture.js';

const USUARIOS = {
  'o professor da turma de automacao': PROFESSOR_ID,
  'o primeiro aluno da turma de automacao': ALUNO_UM_ID,
  'o segundo aluno da turma de automacao': ALUNO_DOIS_ID,
};

Given('que acesso o GameEducator como {string}', async function (quem) {
  const usuarioId = USUARIOS[quem];
  if (!usuarioId) {
    throw new Error(`Usuario desconhecido no cenario de UI: "${quem}"`);
  }

  await this.page.goto(this.baseUrl);
  const inputUsuario = this.page.locator('input[type="number"]');
  await inputUsuario.fill(String(usuarioId));
  // O app so grava o X-Usuario-Id no evento nativo "change" (@change="salvarUsuario"):
  // um blur via clique nem sempre dispara esse evento de forma confiavel, entao disparamos direto.
  await inputUsuario.dispatchEvent('change');

  // "Missoes do aluno" e a aba inicial: ja monta e busca dados antes do X-Usuario-Id acima
  // ser aplicado. Troca para outra aba primeiro para garantir que a aba escolhida no proximo
  // passo sempre monte (e busque dados) do zero, com o usuario correto.
  await this.page.getByRole('button', { name: 'Nova missao (professor)', exact: true }).click();
});

Given('estou na aba {string}', async function (aba) {
  await this.page.getByRole('button', { name: aba, exact: true }).click();
});

Then('a tela mostra {string}', async function (textoEsperado) {
  await this.page.getByText(textoEsperado).first().waitFor();
});

Then('a tela nao mostra {string}', async function (texto) {
  const quantidade = await this.page.getByText(texto).count();
  assert.equal(quantidade, 0, `Esperava nao encontrar o texto "${texto}" na tela`);
});
