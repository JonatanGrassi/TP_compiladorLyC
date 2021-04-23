%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
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
int verifRangoID(char*ptr);
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
STRING    "string"
FLOAT		"float"
WRITE		"write"
ELSE		"else"
AND     "AND"
OR      "OR"
NOT     "NOT"
READ    "read"
  
OP_ASIG		[:]
OP_SUMA		[+]
OP_MULT		[*]
OP_MAY		[>]
OP_MAYEIGU	">="
OP_MEN		[<]
OP_MENEIGU	"<="
OP_IGUAL	"=="
OP_DIF		"!="
OP_RESTA  [-]
OP_DIV    [/]

PAR_A	[(]
PAR_C	[)]
LLAV_A	[{]
LLAV_C	[}]

PYC		[;]

COMA		[,]

%%
	
{IF}		      {return IF;}
{ELSE}        {return ELSE;}
{WHILE}       {return WHILE;}
{DECVAR}	    {return DECVAR;}
{READ}        {return READ;}
{NOT}         {return NOT;}
{OR}          {return OR;}
{AND}         {return AND;}
{ENDDEC}	    {return ENDDEC;}
{INTEGER}	    {return INTEGER;}
{FLOAT}		    {return FLOAT;}
{WRITE}		    {return WRITE;}
{ELSE}		    {return ELSE;}
{CONST_ENT}   {verifRangoCTE_ENT(yytext);colocarEnTablaSimb(yytext); return CONST_ENT;}
{CONST_REAL}  {colocarEnTablaSimb(yytext);return CONST_REAL;}

{PAR_A}		{return PAR_A;}
{ID}	        {colocarEnTablaSimb(yytext);verifRangoID(yytext);return ID;}
{PAR_C}		{return PAR_C;}
{LLAV_A}	{return LLAV_A;}
{LLAV_C}	{return LLAV_C;}


{PYC}		  {return PYC;}
{COMA}			  {return COMA;}
{CTE_STRING}	{colocarEnTablaSimb(yytext);verifRangoString(yytext);return CTE_STRING;}
{STRING}      {return STRING;}

{OP_ASIG}		{return OP_ASIG;}
{OP_SUMA}		{return OP_SUMA;}
{OP_RESTA}		{return OP_RESTA;}
{OP_MULT}		{return OP_MULT;}
{OP_DIV}		{return OP_DIV;}
{OP_MAY}		{return OP_MAY;}
{OP_MAYEIGU}	{return OP_MAYEIGU;}
{OP_MEN}		{return OP_MEN;}
{OP_MENEIGU}	{return OP_MENEIGU;}
{OP_IGUAL}		{return OP_IGUAL;}
{OP_DIF}		{return OP_DIF;}

{COMENTARIO} 

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
  if((tab = fopen("ts.txt", "wt")) == NULL)
      {
        printf("\nNo se puedo crear el archivo tabla_de_simbolos.bin\n");
      return 1;
      }
	yyparse();
  fprintf(tab,"%-*s\t%s\n",LIMITE,"Lexemas","Longitud");
  int i;
  for(i=0;i<cuentaRegs;i++)
  {
      fprintf(tab,"%-*s\t%d\n",LIMITE,tablaSimb[i].lexema,tablaSimb[i].longitud);
  }
  //fwrite(&tablaSimb,sizeof(tSimbo),cuentaRegs,tab);
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
int verifRangoID(char*ptr)
{
  if((strlen(ptr)) > LIMITE)      
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