%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include "lib\pila.c"
#include "lib\funciones.c"
int yystopparser=0;
FILE  *yyin;
extern int yylineno;
char str_aux[50];
char str_aux2[50];
char conector[10];
char compara[10];
int cuerpoCont=0;
int auxDato;
int posEnTabla;
int isNegado=0;
int cuentaSent;
int yyerror();
int yyparse();
int yylex();
%}
%union {
int intval;
float val;
char *str_val;
}

%token <str_val>ID
%token <int>CONST_ENT
%token <float>CONST_REAL
%token <str_val>CTE_STRING


%token IF WHILE DECVAR ENDDEC INTEGER FLOAT WRITE ELSE OP_ASIG
%token OP_SUMA OP_MULT OP_MAY OP_MAYEIGU OP_MEN OP_MENEIGU OP_IGUAL
%token OP_DIF PAR_A PAR_C LLAV_A LLAV_C OP_RESTA OP_DIV
%token PYC COMA AND NOT OR READ STRING 
%token COR_A COR_C INLIST MOD DIV
%right MENOS_UNARIO
%left OP_RESTA OP_SUMA
%%

iniciopro: DECVAR declaracion ENDDEC programa   {grabarTabla();tree_print_dot(&programaPtr,graph);}
          | escrituraSinVar 



programa: sentencia 	                  {printf("\nsentencia");
                                          if(programaPtr!=NULL)
                                          {
                                              sprintf(str_aux, "CUERPO%d",cuerpoCont++);
							    programaPtr = crearNodo(str_aux, sentenciaPtr, NULL);
                                              printf("entro");
							} else   
                                          {
							    programaPtr = sentenciaPtr;
			                        }}
	      | programa sentencia          
                                          {printf("\nprograma sentencia");
                                                if(programaPtr!=NULL)
                                          {     
                           
                                              sprintf(str_aux, "CUERPO%d",cuerpoCont++);
							    programaPtr = crearNodo(str_aux, programaPtr, sentenciaPtr);
							} else 
                                          {    
                                             
                                              sprintf(str_aux, "CUERPO%d",cuerpoCont++);
							    programaPtr = crearNodo(str_aux, sentenciaPtr,NULL);
			                        }}

                                          

sentencia: asignacion PYC		{sentenciaPtr = asigPtr; 
                                          printf("\nREGLA 3: <sentencia>--><asignacion> PYC\n");}
          | ciclo                   {sentenciaPtr = cicloPtr;printf("\nREGLA 4: <sentencia>--><ciclo>\n");}
          | decisiones              {sentenciaPtr = decisionesPtr;printf("\nREGLA 5: <sentencia>--><decisiones>\n");}
          | escritura PYC           {sentenciaPtr = escrituraPtr;printf("\nREGLA 6: <sentencia>--><escritura> PYC\n");}
          | lectura PYC             {sentenciaPtr = lecturaPtr;printf("\nREGLA 7: <sentencia>--><lectura> PYC\n");}
               
               
declaracion: listadeclara                  {printf("\nREGLA 8: <declaracion>--><listadeclara> PYC\n");}      
            | declaracion listadeclara            

listadeclara : {_cantIds=0;} listvar OP_ASIG tdato      {agregarTipoDeDatoVarAtabla(auxDato);printf("\nREGLA 10: <listadeclara>--><listvar> OP_ASIG <tdato>\n");}

listvar : listvar PYC ID             {_cantIds++;colocarEnTablaSimb($<str_val>3,0,yylineno);printf("\nREGLA 11: <listvar>--><listvar> PYC ID\n");}
        | ID                        {_cantIds++;colocarEnTablaSimb($<str_val>1,0,yylineno);printf("\nREGLA 12: <listvar>-->ID\n");}

tdato: INTEGER                {auxDato = Integer ;printf("\nREGLA 13: <tdato>-->INTEGER\n");}
      | FLOAT                 {auxDato = Float ;printf("\nREGLA 14: <tdato>-->FLOAT\n");}
      | STRING                {auxDato = String ;printf("\nREGLA 15: <tdato>-->STRING\n");}

escrituraSinVar: escrituraSinVarSente {printf("\nREGLA 16: <escrituraSinVar>--><escrituraSinVarSente>\n");}
                 | escrituraSinVar escrituraSinVarSente 

escrituraSinVarSente: WRITE CTE_STRING PYC {printf("\nREGLA 18: <escrituraSinVarSente>-->WRITE CTE_STRING PYC\n");}

decisiones : IF PAR_A condicion conectLog condicion subrutIf4 PAR_C LLAV_A subrutIf programa LLAV_C subrutIf3  ELSE LLAV_A programa LLAV_C { sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));
                                                                                                                              sacarDePila(&pilaPrograma,&auxBloquePtr,sizeof(programaPtr));
                                                                                                                              
                                                                                                                              cuerpoIfPtr=crearNodo("CUERPOIF",programaPtr,auxBloquePtr);                                                                                    
                                                                                                                              decisionesPtr=crearNodo("IF",condicionPtr,cuerpoIfPtr);
                                                                                                                              if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                                                                    programaPtr=NULL;
                                                                                                                                  printf("\nREGLA 20: <decisiones>-->IF PAR_A <condicion> <conectLog> <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            
            
            | IF PAR_A subrutIf2 NOT condicion subrutIf PAR_C LLAV_A programa LLAV_C subrutIf3  ELSE LLAV_A programa LLAV_C { sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));
                                                                                                                              sacarDePila(&pilaPrograma,&auxBloquePtr,sizeof(programaPtr));
                                                                                                                              
                                                                                                                              cuerpoIfPtr=crearNodo("CUERPOIF",programaPtr,auxBloquePtr);                                                                                    
                                                                                                                              decisionesPtr=crearNodo("IF",condicionPtr,cuerpoIfPtr);
                                                                                                                              if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                                                                    programaPtr=NULL;
                                                                                                                                    printf("\nREGLA 22: <decisiones>-->IF PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion subrutIf PAR_C  LLAV_A programa LLAV_C subrutIf3  ELSE LLAV_A programa LLAV_C { 
                                                                                                                              sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));
                                                                                                                              sacarDePila(&pilaPrograma,&auxBloquePtr,sizeof(programaPtr));
                                                                                                                                   
                                                                                                                              cuerpoIfPtr=crearNodo("CUERPOIF",programaPtr,auxBloquePtr);                                                                                    
                                                                                                                              decisionesPtr=crearNodo("IF",condicionPtr,cuerpoIfPtr);
                                                                                                                              if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                                                                    programaPtr=NULL;
                                                                                                                              printf("\nREGLA 23: <decisiones>-->IF PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C ELSE LLAV_A <programa> LLAV_C\n");}                                                                                                                   

                                                                                                                            
                                                                                                                              
                                                                                                  
                                                                                                 
            | IF PAR_A condicion conectLog condicion subrutIf4 PAR_C LLAV_A subrutIf programa  LLAV_C  {
                                                                                                      {sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));                                                                                    
                                                                                                decisionesPtr=crearNodo("IF",condicionPtr,programaPtr);
                                                                                                      if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                                            programaPtr=NULL;
                                                                                                printf("\nREGLA 26: <decisiones>-->IF PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
                                                                                    printf("\nREGLA 24: <decisiones>-->IF PAR_A <condicion> <conectLog> <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
            
            | IF PAR_A subrutIf2 NOT condicion subrutIf PAR_C LLAV_A  programa LLAV_C  {sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));                                                                                    
                                                                                      decisionesPtr=crearNodo("IF",condicionPtr,programaPtr);
                                                                                        if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                          programaPtr=NULL;
                                                                                                printf("\nREGLA 26: <decisiones>-->IF PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
            | IF PAR_A condicion subrutIf PAR_C LLAV_A programa LLAV_C  {                   
                                                                                          sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));                                                                                    
                                                                                    decisionesPtr=crearNodo("IF",condicionPtr,programaPtr);
                                                                                     if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                          programaPtr=NULL;
                                                                                     printf("\nREGLA 27: <decisiones>-->IF PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
                                                                                     
subrutIf: /* vacio */ { if(programaPtr!=NULL){
                                                ponerEnPila(&pilaPrograma,&programaPtr,sizeof(programaPtr));
                                                programaPtr=NULL;
                                          }
                                          else{
                                                if(sentenciaPtr!=NULL)
                                                      ponerEnPila(&pilaPrograma,&sentenciaPtr,sizeof(sentenciaPtr));
                                          }
                        ponerEnPila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));
                        isNegado=0;
                        }

subrutIf3: /* vacio */ { if(programaPtr!=NULL){
                                                ponerEnPila(&pilaPrograma,&programaPtr,sizeof(programaPtr));
                                                programaPtr=NULL;
                                          }
                                          else{
                                                if(sentenciaPtr!=NULL)
                                                      ponerEnPila(&pilaPrograma,&sentenciaPtr,sizeof(sentenciaPtr));
                                          }}
subrutIf2:/* vacio */ {isNegado=1;}

subrutIf4:/* vacio */ {condicionPtr = crearNodo(conector,condicionPtrIzq,condicionPtr);}

conectLog: AND  {condicionPtrIzq = condicionPtr; strcpy(conector,"AND");}
           |OR   {condicionPtrIzq = condicionPtr; strcpy(conector,"OR");}
                  

ciclo : WHILE PAR_A condicion conectLog  condicion subrutIf4 subrutIf PAR_C LLAV_A programa LLAV_C {       sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));                                                                                                                                                        
                                                                                     cicloPtr = crearNodo("WHILE",condicionPtr,programaPtr);
                                                                                    if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                          programaPtr=NULL;
                                                                                                printf("\nREGLA 28: <ciclo>-->WHILE PAR_A <condicion> AND <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
        | WHILE PAR_A NOT subrutIf2 condicion subrutIf PAR_C LLAV_A programa LLAV_C {
                                                                                       sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));                                                                                                                                                        
                                                                                cicloPtr = crearNodo("WHILE",condicionPtr,programaPtr);
                                                                                    if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                          programaPtr=NULL;  printf("\nREGLA 30: <ciclo>-->WHILE PAR_A NOT <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}
        | WHILE PAR_A condicion PAR_C subrutIf LLAV_A programa LLAV_C {   sacarDePila(&pilaCondicion,&condicionPtr,sizeof(condicionPtr));                                                                                                                                                        
                                                                                cicloPtr = crearNodo("WHILE",condicionPtr,programaPtr);
                                                                                    if(!sacarDePila(&pilaPrograma,&programaPtr,sizeof(programaPtr)))
                                                                                          programaPtr=NULL;  
                                                                              printf("\nREGLA 31: <ciclo>-->WHILE PAR_A <condicion> PAR_C LLAV_A <programa> LLAV_C\n");}

escritura : WRITE ID          {posEnTabla=chequearVarEnTabla($<str_val>2,yylineno);
                                    escrituraPtr=crearNodo("WRITE",crearHoja($<str_val>2,tablaSimb[posEnTabla].tipoDeDato),NULL);
                                          printf("\nREGLA 32: <escritura>-->WRITE ID\n");}
          | WRITE CTE_STRING  {escrituraPtr=crearNodo("WRITE",crearHoja($<str_val>2,CteString),NULL);
                                    printf("\nREGLA 33: <escritura>-->WRITE CTE_STRING\n");}

lectura : READ ID             {posEnTabla=chequearVarEnTabla($<str_val>2,yylineno);
                                    lecturaPtr= crearNodo("READ",crearHoja($<str_val>2,tablaSimb[posEnTabla].tipoDeDato),NULL);
                                    printf("\nREGLA 34: <lectura>-->READ ID\n");}

condicion : opera oplog opera   {sacarDePila(&pilaOperadoresCond,&operDerPtr,sizeof(operDerPtr));
                                    sacarDePila(&pilaOperadoresCond,&operIzqPtr,sizeof(operDerPtr));
                                    if(isNegado)
                                          invertirCondicion(compara);
                                    condicionPtr=crearNodo(compara,operIzqPtr,operDerPtr);
                                    printf("\nREGLA 35:<condicion>--><opera> <oplog> <opera>\n");}
            | funcionlist      {printf("\nREGLA 36:<condicion>--><funcionList>\n");}

opera: CONST_ENT        {auxCond =crearHoja($<str_val>1,CteInt);
                              ponerEnPila(&pilaOperadoresCond,&auxCond,sizeof(condicionPtr));
                              printf("\nREGLA 37: <opera>-->CONST_ENT\n");}
      | CONST_REAL      {auxCond=crearHoja($<str_val>1,CteFloat);
                              ponerEnPila(&pilaOperadoresCond,&auxCond,sizeof(condicionPtr));
                              printf("\nREGLA 38: <opera>-->CONST_REAL\n");}
      | ID              {chequearVarEnTabla($<str_val>1,yylineno);
                        auxCond = crearHoja($<str_val>1,CteString);
                              ponerEnPila(&pilaOperadoresCond,&auxCond,sizeof(condicionPtr));
                              printf("\nREGLA 39: <opera>-->ID\n");}
      ;

oplog: OP_MAYEIGU       {strcpy(compara,"BLT");
                              printf("\nREGLA 40: <opera>-->OP_MAYEIGU\n");}
    | OP_MENEIGU         {strcpy(compara,"BGT");
                              printf("\nREGLA 41: <opera>-->OP_MENEIGU\n");}
    | OP_IGUAL             {strcpy(compara,"BNE");
                              printf("\nREGLA 42: <opera>-->OP_IGUAL\n");}
    | OP_MAY              {strcpy(compara,"BLE");
                              printf("\nREGLA 43: <opera>-->OP_MAY\n");}
    | OP_MEN             {strcpy(compara,"BGE");
                              printf("\nREGLA 44: <opera>-->OP_MEN\n");}
    | OP_DIF             {strcpy(compara,"BNQ");
                              printf("\nREGLA 45: <opera>-->OP_DIF\n");}
    ;

funcionlist: INLIST PAR_A ID PYC COR_A list COR_C PAR_C {printf("\nREGLA 46: <funcionlist>-->INLIST PAR_A ID PYC COR_A <list> COR_C PAR_C\n");}

list: list PYC var      
      | var             {printf("\nREGLA 48: <list>--><var>\n");}

var: expresion           {printf("\nREGLA 49: <list>--><expresion>\n");}

asignacion: ID OP_ASIG {strcpy(str_aux2,$<str_val>1);} expresion	    
                                                {     
                                                      chequearVarEnTabla($<str_val>1,yylineno);
                                                      sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                      asigPtr = crearNodo("OP_ASIG",crearHoja(str_aux2,CteString),exprPtr) ;
                                                      printf("\nREGLA 50: <asignacion>-->ID OP_ASIG <expresion>\n");}
            | ID OP_ASIG {strcpy(str_aux2,$<str_val>1);} CTE_STRING       
                                                {     chequearVarEnTabla($<str_val>1,yylineno);
                                                      asigPtr = crearNodo("OP_ASIG",crearHoja(str_aux2,CteString),crearHoja($<str_val>4,CteString)) ;
                                                      printf("\nREGLA 51: <asignacion>-->ID OP_ASIG CTE_STRING\n");}
            
		
expresion: termino                        {//exprPtr = terminoPtr ;
                                                      sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                      ponerEnPila(&pilaExpresion,&terminoPtr,sizeof(terminoPtr)); 
                                                      printf("\nREGLA 52: <expresion>--><termino>\n");}
		   | expresion OP_SUMA termino {//exprPtr = crearNodo("OP_SUMA",exprPtr,terminoPtr);
                                                      sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                      sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                      exprPtr = crearNodo("OP_SUMA",exprPtr,terminoPtr);
                                                      ponerEnPila(&pilaExpresion,&exprPtr,sizeof(exprPtr));    
                                                      printf("\nREGLA 53: <expresion>--><expresion> OP_SUMA <termino>\n");}
		   | expresion OP_RESTA termino {//exprPtr = crearNodo("OP_RESTA",exprPtr,terminoPtr);
                                                      sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                      sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                      exprPtr = crearNodo("OP_RESTA",exprPtr,terminoPtr);
                                                      ponerEnPila(&pilaExpresion,&exprPtr,sizeof(exprPtr));       
                                                      printf("\nREGLA 54: <expresion>--><expresion> OP_RESTA <termino>\n");}
               | OP_RESTA expresion %prec MENOS_UNARIO 
                                                      { //exprPtr=crearNodo("OP_RESTA",exprPtr,NULL);
                                                       sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                       exprPtr=crearNodo("OP_RESTA",exprPtr,NULL);
                                                       ponerEnPila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                                  printf("\nREGLA 55: <expresion>-->OP_RESTA <expresion>\n");}
		   

termino:  factor                          {//terminoPtr = factorPtr ;
                                                      sacarDePila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                      ponerEnPila(&pilaTermino,&factorPtr,sizeof(factorPtr)); 
                                                      printf("\nREGLA 56: <termino>--><factor>\n");}
		 | termino OP_MULT factor	{//terminoPtr=crearNodo("OP_MULT",terminoPtr,factorPtr);
                                                      sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                      sacarDePila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                      terminoPtr=crearNodo("OP_MULT",terminoPtr,factorPtr);
                                                      ponerEnPila(&pilaTermino,&terminoPtr,sizeof(terminoPtr)); 
                                                      printf("\nREGLA 57: <termino>--><termino> OP_MULT <factor>\n");}
		 | termino OP_DIV factor	{ //terminoPtr=crearNodo("OP_DIV",terminoPtr,factorPtr); 
                                                      sacarDePila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                      sacarDePila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                      terminoPtr=crearNodo("OP_DIV",terminoPtr,factorPtr); 
                                                      ponerEnPila(&pilaTermino,&terminoPtr,sizeof(terminoPtr));
                                                      printf("\nREGLA 58: <termino>--><termino> OP_DIV <factor>\n");}

factor : CONST_ENT                         {sprintf(str_aux, "%d",yylval.intval);
                                                factorPtr = crearHoja(str_aux ,CteInt) ;
                                                ponerEnPila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                            printf("\nREGLA 59: <factor>-->CONST_ENT\n");
                                                                        }
		| ID                            {posEnTabla=chequearVarEnTabla(yylval.str_val,yylineno);
                                                      factorPtr = crearHoja(yylval.str_val,tablaSimb[posEnTabla].tipoDeDato);
                                                      ponerEnPila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                            printf("\nREGLA 60: <factor>-->ID\n");
                                                                  }
            | CONST_REAL                         {sprintf(str_aux, "%f",yylval.val);
                                                      factorPtr = crearHoja(str_aux,CteFloat) ;
                                                                        ponerEnPila(&pilaFactor,&factorPtr,sizeof(factorPtr));
                                                            printf("\nREGLA 61: <factor>-->CONST_REAL\n");}
		| PAR_A   expresion  PAR_C                               {//factorPtr = exprPtr;
                                                                        sacarDePila(&pilaExpresion,&exprPtr,sizeof(exprPtr));
                                                                        ponerEnPila(&pilaFactor,&exprPtr,sizeof(exprPtr));
                                                                        
                                                                       printf("\nREGLA 62: <factor>-->PAR_A <expresion> PAR_C\n");}
            | PAR_A  expresion MOD expresion PAR_C      {printf("\nREGLA 63: <factor>-->PAR_A <expresion> MOD <expresion> PAR_C\n");}
            | PAR_A  expresion DIV expresion PAR_C       {printf("\nREGLA 64: <factor>-->PAR_A <expresion> DIV <expresion> PAR_C\n");}
 
           
   
                                           		
%%

