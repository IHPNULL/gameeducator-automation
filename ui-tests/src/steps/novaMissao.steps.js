import { When } from '@cucumber/cucumber';

When('preencho e salvo uma nova missao chamada {string} com o desafio {string} cuja resposta correta e {string}',
    async function (titulo, enunciado, alternativaCorreta) {
      await this.page.getByTestId('titulo').fill(titulo);
      await this.page.getByTestId('descricao').fill('Missao criada pela suite de automacao de UI');
      await this.page.getByTestId('desafio-0-enunciado').fill(enunciado);
      await this.page.getByTestId('desafio-0-alternativa-0').fill('alternativa errada');
      await this.page.getByTestId('desafio-0-alternativa-1').fill(alternativaCorreta);
      await this.page.getByTestId('desafio-0-indiceCorreto').fill('1');
      await this.page.getByTestId('desafio-0-xp').fill('10');
      await this.page.getByTestId('salvar').click();
    });
