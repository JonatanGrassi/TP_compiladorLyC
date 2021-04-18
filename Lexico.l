%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
FILE  *yyin;
int yylval;
char *yyltext;
%}
%option noyywrap  
%option yylineno 

LETRA			[A-Za-z]
DIGITO			[0-9]
ESPACIO			[" "]
CARACTERCOM		@|\?|¿|\*|{LETRA}|{DIGITO}|{ESPACIO}

STRING		\".+\"
CONST_ENT	({DIGITO})+
CONST_REAL	({DIGITO})*"."({DIGITO})*
COMENTARIO  	("-")(\/)({CARACTERCOM})*?(("-")(\/)({CARACTERCOM})*(\/)("-"))({CARACTERCOM})*(\/)("-")
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

OP_MULT		[*]
OP_MAY		[>]
OP_MAYEIGU	">="
OP_MEN		[<]
OP_MENEIGU	"<="
OP_IGUAL	"=="
OP_DIF		"!="

PAR_A	[(]
PAR_C	[)]
LLAV_A	[{]
LLAV_C	[}]

PUNYCOM		[;]

COMA		[,]

%%
{COMENTARIO} 		{printf("\n%s es un comentario\n",yytext);}
{IF}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{WHILE}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{DECVAR}	{printf("\nPalabra reservada: [%s]\n",yytext);}
{ENDDEC}	{printf("\nPalabra reservada: [%s]\n",yytext);}
{INTEGER}	{printf("\nPalabra reservada: [%s]\n",yytext);}
{FLOAT}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{WRITE}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{ELSE}		{printf("\nPalabra reservada: [%s]\n",yytext);}
{CONST_ENT} {printf("\nConstante entera: [%s]\n",yytext);}
{CONST_REAL} {printf("\nConstante Real: [%s]\n",yytext);}
{ID}	{printf("\nIdentificador: [%s]\n",yytext);}

{PAR_A}	{printf("\nParentesis: [%s]\n",yytext);}
{PAR_C}	{printf("\nParentesis: [%s]\n",yytext);}
{LLAV_A}	{printf("\nLlave: [%s]\n",yytext);}
{LLAV_C}	{printf("\nLlave: [%s]\n",yytext);}

{PUNYCOM}		{printf("\nPuntuacion: [%s]\n",yytext);}
{STRING}		{printf("\nString: [%s]\n",yytext);}
{COMA}			{printf("\nPuntuacion: [%s]\n",yytext);}

{OP_ASIG}		{printf("\nOperadores: [%s]\n",yytext);}


{OP_MULT}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_MAY}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_MAYEIGU}	{printf("\nOperadores: [%s]\n",yytext);}
{OP_MEN}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_MENEIGU}	{printf("\nOperadores: [%s]\n",yytext);}
{OP_IGUAL}		{printf("\nOperadores: [%s]\n",yytext);}
{OP_DIF}		{printf("\nOperadores: [%s]\n",yytext);}



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
  }
  else
  {
	yylex();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
	 system ("Pause");
	 exit (1);
     }