import { When } from '@cucumber/cucumber';

When('publico o post {string} com o conteudo {string}', async function (titulo, conteudo) {
  await this.page.getByTestId('novo-post-titulo').fill(titulo);
  await this.page.getByTestId('novo-post-conteudo').fill(conteudo);
  await this.page.getByTestId('publicar-post').click();
});
