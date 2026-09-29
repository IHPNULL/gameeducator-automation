# language: pt
Funcionalidade: Professor cria uma nova missao pela tela
  Como professor, quero cadastrar uma missao com um desafio para o meu curso.

  Cenario: Professor cria uma missao com um desafio e ve na lista
    Dado que acesso o GameEducator como "o professor da turma de automacao"
    E estou na aba "Nova missao (professor)"
    Quando preencho e salvo uma nova missao chamada "Missao via UI" com o desafio "Quanto e 3 + 3 ?" cuja resposta correta e "6"
    Entao a tela mostra "Missao via UI"
