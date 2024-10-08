# Compilador Acadêmico

Este projeto é um compilador desenvolvido para a disciplina de Compiladores na UTFPR. O compilador faz análise léxica e sintática de uma linguagem fictícia definida pelos alunos.

## Estrutura do Projeto
- **src/**: Contém os arquivos fonte do compilador, incluindo a definição léxica e sintática.
- **build/**: Arquivos gerados a partir das ferramentas Flex e Bison.
- **tests/**: Exemplos de código para testar o compilador.
- **docs/**: Documentação do projeto e regras gramaticais.

## Tecnologias Utilizadas
- **Flex**: Para geração do analisador léxico.
- **Bison**: Para geração do analisador sintático.

## Como Compilar
Para compilar o projeto, siga os passos:

```bash
bison -d syntax-parser.y
flex lexical-parser.l
g++ syntax-parser.tab.c lex.yy.c -o compilador
