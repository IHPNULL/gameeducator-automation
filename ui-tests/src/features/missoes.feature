# language: pt
Funcionalidade: Aluno resolve os desafios de uma missao pela tela
  Como aluno, quero responder os desafios da missao e ver na tela se acertei ou errei.

  Cenario: Aluno responde corretamente e ve o resultado na tela
    Dado que acesso o GameEducator como "o segundo aluno da turma de automacao"
    E estou na aba "Missoes do aluno"
    Quando respondo a alternativa "4" do desafio "Quanto e 2 + 2 ?"
    Entao a tela mostra "Resposta correta"

  Cenario: Aluno responde incorretamente e ve o resultado na tela
    Dado que acesso o GameEducator como "o segundo aluno da turma de automacao"
    E estou na aba "Missoes do aluno"
    Quando respondo a alternativa "Rio de Janeiro" do desafio "Qual e a capital do Brasil ?"
    Entao a tela mostra "Resposta incorreta"
