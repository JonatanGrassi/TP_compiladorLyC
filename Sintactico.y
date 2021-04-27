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
%token PYC COMA ID CONST_ENT CONST_REAL CTE_STRING AND NOT OR READ STRING 
%token COR_A COR_C INLIST MOD DIV

%%

iniciopro: DECVAR declaracion ENDDEC programa  {printf("\nFin analisis sintactico");}
          | escrituraSinVar 

programa: sentencia 	          
	      | programa sentencia 

sentencia: asignacion PYC		{printf("\n asignacion correcta");}
          | ciclo                   {printf("\n Ciclo while correcto");}
          | decisiones              {printf("\n decision correcta");}
          | escritura PYC           {printf("\n escritura correcta");}
          | lectura PYC             {printf("\n lectura correcta");}         
               
declaracion: listadeclara
            | declaracion listadeclara

listadeclara : listvar OP_ASIG tdato

listvar : listvar PYC ID
        | ID

tdato: INTEGER
      | FLOAT
      | STRING

escrituraSinVar: escrituraSinVarSente 
                 | escrituraSinVar escrituraSinVarSente

escrituraSinVarSente: WRITE CTE_STRING PYC {printf("\n escritura correcta");}

decisiones : IF PAR_A condicion AND condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C
            | IF PAR_A condicion OR condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C
            | IF PAR_A NOT condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C
            | IF PAR_A condicion PAR_C LLAV_A programa LLAV_C ELSE LLAV_A programa LLAV_C
            | IF PAR_A condicion AND condicion PAR_C LLAV_A programa LLAV_C 
            | IF PAR_A condicion OR condicion PAR_C LLAV_A programa LLAV_C
            | IF PAR_A NOT condicion PAR_C LLAV_A programa LLAV_C 
            | IF PAR_A condicion PAR_C LLAV_A programa LLAV_C 


ciclo : WHILE PAR_A condicion AND condicion PAR_C LLAV_A programa LLAV_C
        | WHILE PAR_A condicion OR condicion PAR_C LLAV_A programa LLAV_C
        | WHILE PAR_A NOT condicion PAR_C LLAV_A programa LLAV_C
        | WHILE PAR_A condicion PAR_C LLAV_A programa LLAV_C

escritura : WRITE ID
          | WRITE CTE_STRING

lectura : READ ID 

condicion : opera oplog opera
            | funcionlist      {printf("\n funcion lista correcta");}

opera: CONST_ENT
      | CONST_REAL
      | ID
      ;

oplog: OP_MAYEIGU
    | OP_MENEIGU
    | OP_IGUAL
    | OP_MAY
    | OP_MEN
    | OP_DIF
    ;

funcionlist: INLIST PAR_A ID PYC COR_A list COR_C PAR_C

list: list PYC var
      | var

var: expresion

asignacion: ID OP_ASIG expresion	{printf("\nla asignacion es correcta");}
            
		
expresion: termino
		   | expresion OP_SUMA termino {printf("\nla suma es correcta");}
		   | expresion OP_RESTA termino {printf("\nla resta es correcta");}
		   

termino:  factor
		 | termino OP_MULT factor	{printf("\nla multiplicacion es correcta");}
		 | termino OP_DIV factor	{printf("\nla division es correcta");}

factor : CONST_ENT 
		| ID
            | CONST_REAL
		| PAR_A expresion PAR_C
            | PAR_A expresion MOD expresion PAR_C     {printf("\nel modulo es correcto");}
            | PAR_A expresion DIV expresion PAR_C      {printf("\nla division entera es correcta");}
		;	
%%

