# language: pt
Funcionalidade: Ranking - consulta e classificacao via API
  Como aluno matriculado, quero consultar o ranking da turma
  para verificar as posicoes e pontuacoes registradas.

  Cenario: Aluno matriculado consulta o ranking com sucesso
    Dado que estou autenticado como um aluno matriculado no curso de automacao
    Quando consulto o ranking do curso de automacao
    Entao a resposta tem status 200
    E a lista de ranking tem ao menos 1 item

  Cenario: Usuario nao matriculado nao pode consultar o ranking
    Dado que estou autenticado como um usuario inexistente
    Quando consulto o ranking do curso de automacao
    Entao a resposta tem status 403
