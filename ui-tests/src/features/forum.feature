# language: pt
Funcionalidade: Aluno interage com o forum do curso pela tela

  Cenario: Aluno publica um post e ve na lista
    Dado que acesso o GameEducator como "o primeiro aluno da turma de automacao"
    E estou na aba "Forum"
    Quando publico o post "Duvida da UI" com o conteudo "Alguem pode revisar o desafio 2?"
    Entao a tela mostra "Duvida da UI"
