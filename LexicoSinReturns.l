%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#define LIMITE 30

typedef struct{
char lexema[50];
char tipoDeDato[50];
char valor[50];
int longitud;
}tSimbo;

tSimbo tablaSimb[1000];
FILE  *yyin;
FILE *tab;
int yylval;
int cuentaRegs=0;
char *yyltext;
int verifRangoString(char*ptr);
int verifRangoCTE_ENT(char*ptr);
int verifRangoCTE_REAL(char*ptr);
void colocarEnTablaSimb(char*ptr);
%}
%option noyywrap  
%option yylineno 

LETRA			[A-Za-z]
DIGITO			[0-9]
ESPACIO			[" "]
CARACTERCOM		@|\?|¿|\*|{LETRA}|{DIGITO}|{ESPACIO}

CTE_STRING		\".+\"      
CONST_ENT	({DIGITO})+ 
CONST_REAL	  ({DIGITO})*"."({DIGITO})+|({DIGITO})+"."({DIGITO})*
COMENTARIO  	("-")(\/)({CARACTERCOM})*(("-")(\/)({CARACTERCOM})*(\/)("-"))?({CARACTERCOM})*(\/)("-")
ID			({LETRA})({LETRA}|{DIGITO})*

IF			"if"
WHILE		"while"
DECVAR		"DECVAR"
ENDDEC		"ENDDEC"
INTEGER		"integer"
FLOAT		"float"
WRITE		"write"
ELSE		"else"
  
OP_ASIG		[:]
OP_SUMA		[+]

OP_RESTA   [-]
OP_DIV    [/]

OP_MULT		[*]
OP_MAY		[>]
OP_MAYEIGU	">="
OP_MEN		[<]
OP_MENEIGU	"<="
OP_IGUAL	"=="
OP_DIF		"!="
COR_A   [[]
COR_C   []]

PAR_A	[(]
PAR_C	[)]
LLAV_A	[{]
LLAV_C	[}]

PYC		[;]

COMA		[,]

%%
{COMENTARIO} 		{printf("\n%s es un comentario\n",yytext);}
{IF}		      {printf("\nPalabra reservada: [%s]\n",yytext);}
{COR_A}   {printf("\n corchete abre: [%s]\n",yytext);}
{COR_C}   {printf("\n corchete cierra: [%s]\n",yytext);}
{WHILE}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{DECVAR}	{printf("\nPalabra reservada: [%s]\n",yytext);}
{ENDDEC}	{printf("\nPalabra reservada: [%s]\n",yytext);}
{INTEGER}	{printf("\nPalabra reservada: [%s]\n",yytext);}
{FLOAT}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{WRITE}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{ELSE}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{CONST_ENT} {verifRangoCTE_ENT(yytext);colocarEnTablaSimb(yytext);printf("\nConstante entera: [%s]\n",yytext);}
{CONST_REAL} {colocarEnTablaSimb(yytext);printf("\nConstante Real: [%s]\n",yytext);}
{ID}	{colocarEnTablaSimb(yytext);verifRangoString(yytext);printf("\nIdentificador: [%s]\n",yytext);}

{PAR_A}	{printf("\nParentesis: [%s]\n",yytext);}
{PAR_C}	{printf("\nParentesis: [%s]\n",yytext);}
{LLAV_A}	{printf("\nLlave: [%s]\n",yytext);}
{LLAV_C}	{printf("\nLlave: [%s]\n",yytext);}

{PYC}		{printf("\nPuntuacion: [%s]\n",yytext);}
{CTE_STRING}		{colocarEnTablaSimb(yytext);verifRangoString(yytext);printf("\nString: [%s]\n",yytext);}
{COMA}			{printf("\nPuntuacion: [%s]\n",yytext);}

{OP_ASIG}		{printf("\nOperadores: [%s]\n",yytext);}


{OP_MULT}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_MAY}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_MAYEIGU}	{printf("\nOperadores: [%s]\n",yytext);}
{OP_MEN}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_MENEIGU}	{printf("\nOperadores: [%s]\n",yytext);}
{OP_IGUAL}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_DIF}		{printf("\nOperadores: [%s]\n",yytext);}

{OP_RESTA}	{printf("\nOperadores: [%s]\n",yytext);}
{OP_DIV}    {printf("\nOperadores: [%s]\n",yytext);}


"\n"      		
"\t"
" "
.                  yyerror();
%%

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    return 1;
  }
  if((tab = fopen("tabla_de_simbolos.bin", "wb")) == NULL)
      {
        printf("\nNo se puedo crear el archivo tabla_de_simbolos.bin\n");
      return 1;
      }
	yylex();
  fwrite(&tablaSimb,sizeof(tSimbo),cuentaRegs,tab);
  fclose(tab);
  fclose(yyin);
  return 0;
}
int verifRangoString(char*ptr)
{
  if((strlen(ptr) - 2) > LIMITE)       //-2 para que no cuente las comillas
  { 
     printf("\nla cadena (%s) supera el rango permitido\n",ptr);
    return yyerror();
  }
    return 0;
}
int verifRangoCTE_ENT(char*ptr)
{ 
  if(strlen(ptr) > 5 || atoi(ptr) < -32768 || atoi(ptr) > 32767)
  { 
     printf("\nla constante (%s) supera el rango permitido\n",ptr);
    return yyerror();
  }
    return 0;
}
/*
int verifRangoCTE_REAL(char*ptr)
{
  if(strlen(ptr) > 5)
  { 
     printf("\nla constante (%s) supera el rango permitido\n",ptr);
    return yyerror();
  }
    return 0;
}
*/

void colocarEnTablaSimb(char*ptr)
{   
    tablaSimb[cuentaRegs].longitud = strlen(ptr);
    strcpy(tablaSimb[cuentaRegs].lexema,ptr);
    cuentaRegs++;
}

int yyerror(void)
    {
       printf("Syntax Error\n");
	    system ("Pause");
	  exit (1);
     }