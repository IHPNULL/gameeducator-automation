# language: pt
Funcionalidade: Aluno visualiza o ranking da turma e suas conquistas
  Como aluno matriculado, quero acessar a tela de ranking
  para acompanhar a pontuacao de XP dos colegas e verificar meu posicionamento na turma.

  Cenario: Aluno consulta a classificacao geral e identifica seu usuario destacado
    Dado que acesso o GameEducator como "o primeiro aluno da turma de automacao"
    E estou na aba "Ranking da turma"
    Entao a tela mostra "Ranking da turma"
    E a tela mostra "Quadro de Medalhas"
    E a tela mostra "Classificacao Geral"
    E a tela mostra "Aluno Um Automacao"
    E a tela mostra "10 XP"
    E a linha do aluno "Aluno Um Automacao" esta destacada no ranking
