%{
    
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// this is needed to define what a simbol is
typedef struct {
    char* id;
    int address;
} _symbol;

typedef struct {
    int id;
    int start;
    int end;
} _action;

// and this is the vector of symbols used
_symbol tabsymb[1000];
int _nsymbs = 0;
_action tabaction[1000];
int _naction = 0;

// we need to check if the ID is already in the programm everytime a new ID is identified
int getAddress(char *id) {
    for (int i=0;i<_nsymbs;i++)
        if (!strcmp(tabsymb[i].id, id))
            return tabsymb[i].address;

    return -1;
}

// this function verifies if the action exists and returns its start label
int getActionStart(int id) {
    for (int i=0;i<=_naction;i++)
        if (tabaction[i].id == id)
            return tabaction[i].start;

    return -1;
}

// this function verifies if the action exists and returns its end label
int getActionEnding(int id) {
    for (int i=0;i<=_naction;i++)
        if (tabaction[i].id == id)
            return tabaction[i].end;

    return -1;
}

%}

%union {
    char *str_val;
    int int_val;
}

%token <str_val>INT ID PRINT SCAN SE SENAO RETURN MAIS MENOS VEZES DIVIDIDO RESTO ATRIBUICAO MENOR MAIOR MENOR_IGUAL MAIOR_IGUAL IGUAL DIFERENTE PEV <int_val>NUM ABRE_CHAVES FECHA_CHAVES ABRE_PARENTESES FECHA_PARENTESES ENQUANTO

%%

S : declaracao S_linha
    | condicao  S_linha
    | atrib S_linha 
    | leitura S_linha
    | escrita S_linha
    | laco S_linha
    | end ;

S_linha : PEV S
    | PEV ;

end : RETURN NUM PEV                        {printf("SAIR\n");} 
    | RETURN PEV                            {printf("SAIR\n");} ;

bloco : declaracao bloco_linha
    | condicao bloco_linha
    | atrib bloco_linha 
    | leitura bloco_linha
    | escrita bloco_linha
    | laco bloco_linha ;

bloco_linha : PEV bloco
    | PEV ;

laco :  ENQUANTO                            {
                                            tabaction[_naction].id = _naction;
                                            tabaction[_naction].start = (_naction*2);
                                            tabaction[_naction].end = ((_naction*2)+1);

                                            if(getActionStart(_naction) < 10)
                                                printf("R0%d: NADA\n", getActionStart(_naction)); 
                                            else
                                                printf("R%d: NADA\n", getActionStart(_naction)) ;
                                            }

        ABRE_PARENTESES 
        comparacao
        FECHA_PARENTESES
        ABRE_CHAVES                         {
                                            if(getActionEnding(_naction) < 10)
                                                printf("GFALSE R0%d\n", getActionEnding(_naction)); 
                                            else
                                                printf("GFALSE R%d\n", getActionEnding(_naction));
                                            _naction++;
                                            }
        bloco      
        FECHA_CHAVES                        {
                                            _naction--;
                                            if(getActionStart(_naction) < 10)
                                                printf("GOTO R0%d\n", getActionStart(_naction) ); 
                                            else
                                                printf("GOTO R%d\n", getActionStart(_naction) ); 
                                              
                                            if(getActionEnding(_naction) < 10)
                                                printf("R0%d: NADA\n", getActionEnding(_naction)  ); 
                                            else
                                                printf("R%d: NADA\n", getActionEnding(_naction)  ); 
                                            } ;

declaracao : INT ID ATRIBUICAO exprecao     {
                                            if(getAddress($2)==-1) {
                                                tabsymb[_nsymbs].id = $2;
                                                tabsymb[_nsymbs].address = _nsymbs;
                                                _nsymbs++;
                                            }
                                            printf("ATR %%%d\n", getAddress($2));
                                            } 

    | INT ID ATRIBUICAO SCAN ABRE_PARENTESES FECHA_PARENTESES 
                                            {
                                            if(getAddress($3)==-1) {
                                                tabsymb[_nsymbs].id = $2;
                                                tabsymb[_nsymbs].address = _nsymbs;
                                                _nsymbs++;
                                            }
                                            printf("LEIA\nATR %%%d\n", getAddress($3));
                                            } ;

atrib : ID ATRIBUICAO exprecao              {
                                            if(getAddress($1)==-1) {
                                                printf("ERRO: semantic error");
                                                return 1;
                                            }
                                            printf("ATR %%%d\n", getAddress($1));
                                            } 

    | ID ATRIBUICAO SCAN ABRE_PARENTESES FECHA_PARENTESES 
                                            {
                                            if(getAddress($3)==-1) {
                                                printf("ERRO: semantic error");
                                                return 1;
                                            }
                                            printf("LEIA\nATR %%%d\n", getAddress($3));
                                            } ;

condicao :  SE                              {
                                            tabaction[_naction].id = _naction;
                                            tabaction[_naction].start = (_naction*2);
                                            tabaction[_naction].end = ((_naction*2)+1);
                                            }
            ABRE_PARENTESES 
            comparacao 
            FECHA_PARENTESES 
            ABRE_CHAVES                     {
                                            if(getActionStart(_naction) < 10)
                                                printf("GFALSE R0%d\n", getActionStart(_naction)); 
                                            else
                                                printf("GFALSE R%d\n", getActionStart(_naction));
                                            _naction++;
                                            }
            bloco
            FECHA_CHAVES                    {
                                            _naction--;
                                            if(getActionEnding(_naction) < 10)
                                                printf("GOTO R0%d\n", getActionEnding(_naction) ); 
                                            else
                                                printf("GOTO R%d\n", getActionEnding(_naction) );
                                            } 
            SENAO
            ABRE_CHAVES                     {
                                            if(getActionStart(_naction) < 10)
                                                printf("R0%d: NADA\n", getActionStart(_naction)  ); 
                                            else
                                                printf("R%d: NADA\n", getActionStart(_naction)  ); 
                                            _naction++;
                                            }
            bloco
            FECHA_CHAVES                    {
                                            _naction--;
                                            if(getActionEnding(_naction) < 10)
                                                printf("R0%d: NADA\n", getActionEnding(_naction)  ); 
                                            else
                                                printf("R%d: NADA\n", getActionEnding(_naction)  ); 
                                            } ;

comparacao : exprecao IGUAL exprecao              {printf("IGUAL\n");} 
        | exprecao DIFERENTE exprecao             {printf("DIFER\n");} 
        | exprecao MAIOR exprecao                 {printf("MAIOR\n");} 
        | exprecao MENOR exprecao                 {printf("MENOR\n");} 
        | exprecao MAIOR_IGUAL exprecao           {printf("MAIOREQ\n");} 
        | exprecao MENOR_IGUAL exprecao           {printf("MENOREQ\n");} ;

leitura : SCAN ABRE_PARENTESES ID FECHA_PARENTESES 
                                            {
                                            if(getAddress($3)==-1) {
                                                printf("ERRO: semantic error");
                                                return 1;
                                            }
                                            printf("LEIA\nATR %%%d\n", getAddress($3));
                                            } ;

escrita : PRINT ABRE_PARENTESES exprecao FECHA_PARENTESES
                                            {printf("IMPR\n"); } ;

exprecao : exprecao MAIS termo              {printf("SOMA\n");}
        | exprecao MENOS termo              {printf("SUB\n");}
        | termo ;

termo : termo VEZES fator                   {printf("MULT\n");}
        | termo DIVIDIDO fator              {printf("DIV\n");}
        | termo RESTO fator                 {printf("MOD\n");}
        | fator ;

fator : ID                                  {
                                            if(getAddress($1)==-1) {
                                                printf("ERRO: semantic error");
                                                return 1;
                                            }
                                            printf("PUSH %%%d\n", getAddress($1));
                                            }
                                            
        | NUM                               {printf("PUSH %d\n", $1); }
 
        | ABRE_PARENTESES exprecao FECHA_PARENTESES ;

%%

extern FILE *yyin;


int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <arquivo_de_entrada>\n", argv[0]);
        return EXIT_FAILURE;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erro ao abrir arquivo de entrada");
        return EXIT_FAILURE;
    }

    if (yyparse() == 0) {  // Verifica se a análise sintática foi bem-sucedida
        FILE *outputFile = fopen("output.pil", "w");
        if (!outputFile) {
            perror("Erro ao criar arquivo de saída");
            fclose(yyin);
            return EXIT_FAILURE;
        }

        // Escreva as informações desejadas no arquivo de saída
        fprintf(outputFile, "Sucesso na análise sintática!\n");

        fclose(outputFile);
    }

    fclose(yyin);

    return EXIT_SUCCESS;
}
void yyerror(char *s) { printf(stderr,"ERRO: %s\n", s); }
