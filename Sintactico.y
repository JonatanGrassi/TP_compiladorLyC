%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
%}

%token IF WHILE DECVAR ENDDEC INTEGER FLOAT WRITE ELSE OP_ASIG
%token OP_SUMA OP_MULT OP_MAY OP_MAYEIGU OP_MEN OP_MENEIGU OP_IGUAL
%token OP_DIF PAR_A PAR_C LLAV_A LLAV_C OP_RESTA OP_DIV
%token PYC COMA ID CONST_ENT CONST_REAL CTE_STRING

%%
programa: DECVAR bloque ENDDEC	  
	| programa DECVAR bloque ENDDEC {printf("\nFin analisis sintactico");}
	;
bloque: sentencia
		| bloque sentencia
		;
sentencia: asignacion PYC
        ;

asignacion: ID OP_ASIG expresion
            ;
		
expresion: termino
		   | expresion OP_SUMA termino {printf("\nla suma es correcta");}
		   | expresion OP_RESTA termino {printf("\nla resta es correcta");}
		   ;

termino:  factor
		 | termino OP_MULT factor	{printf("\nla multiplicacion es correcta");}
		 | termino OP_DIV factor	{printf("\nla division es correcta");}
		 ;

factor : CONST_ENT 
		| ID
		| PAR_A expresion PAR_C              ///-> preguntar por que sin los parentesis falla
		;	
%%
