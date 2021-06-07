#ifndef FUNCIONES_H
#define FUNCIONES_H

enum tipoError
{
    ErrorSintactico,
    ErrorLexico
};
/* Tipos de datos para la tabla de simbolos */
#define Integer 1
#define Float 2
#define String 3
#define CteInt 4
#define CteFloat 5
#define CteString 6
#define SinTipo 7
#define SIN_MEM -4
#define NODO_OK -3
#define TRUE 1
#define FALSE 0
#define PILA_VAC 0
#define MIN(x,y) ((x<y)?x:y)
#define LIMITE 30
#define LIMITEFLOAT 40
#define LIMITEENT 5

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define TAMANIO_TABLA 1000
#define TAM_NOMBRE 32
#define ES_CTE_CON_NOMBRE 1
/* Defino estructura de informacion para el arbol*/
	typedef struct {
		char dato[40];
		int tipoDato;		
	}tInfo;

/* Defino estructura de nodo de arbol*/
typedef struct sNodo{
	tInfo info;
	struct sNodo *izq, *der;
}tNodo;

/* Defino estructura de arbol*/
typedef tNodo* tArbol;
tInfo infoArbol;

FILE *graph;
FILE *tab;


typedef struct{
char lexema[50];
int tipoDeDato;
char valor[100];
int longitud;
}tSimbo;

tSimbo tablaSimb[TAMANIO_TABLA];
int cuentaRegs;
int _cantIds;

int verifRangoString(char*ptr,int linea);
int verifRangoCTE_ENT(char*ptr,int linea);
int verifRangoCTE_REAL(char*ptr,int linea);
void colocarEnTablaSimb(char*ptr,int esCte,int linea);
int verifRangoID(char*ptr,int linea);
int comparaLexemas(char*ptr1,char*ptr2);
void errorCaracter(char*ptr,int linea);
void grabarTablaSim();
void agregarTipoDeDatoVarAtabla(int tDato);
void agregarTiposDatosCte(int tDato);
int chequearVarEnTabla(char* nombre,int linea);
void mensajeDeError(enum tipoError error,const char* info, int linea);



















void agregarVarATabla(char* nombre,int esCteConNombre,int linea);

void agregarCteATabla(int num);
void agregarEnTabla(char* nombre,int linea,int tipo);

int verificarTipoDato(tArbol * p,int linea);
void verificarTipo(tArbol* p,int tipoAux,int linea);
int verificarCompatible(int tipo,int tipoAux);
int buscarEnTabla(char * nombre);
void grabarTabla(void);
char* normalizarNombre(const char* nombre);
char * reemplazarCaracter(char * aux);
char* normalizarId(const char* cadena);
void validarCteEnTabla(char* nombre,int linea);
void agregarValorACte(int tipo);
void generarAsm(tArbol *p);
void recorrerArbol(tArbol *arbol,FILE * pf);
void tratarNodo(tArbol* nodo,FILE *pf);
void crearNodoCMP(char * comp);
void invertirSalto(tArbol *p);
int resolverTipoDatoMaximo(int tipo);

tNodo* crearNodo(const char* dato, tNodo *pIzq, tNodo *pDer);
tNodo* crearHoja(char* dato,int tipo);
tArbol * hijoMasIzq(tArbol *p);
void enOrden(tArbol *p);
void verNodo(const char *p);

/* Declaraciones globales de punteros de elementos no terminales para el arbol de sentencias basicas*/

tArbol 	asigPtr,			//Puntero de asignaciones
		exprPtr,			//Puntero de expresiones
		exprCadPtr,			//Puntero de expresiones de cadenas
		exprAritPtr,		//Puntero de expresiones aritmeticas
		terminoPtr,			//Puntero de terminos
		factorPtr,			//Puntero de factores
		sentenciaPtr,		//Puntero de sentencia	
		bloqueWhPtr,		//Puntero de bloque de While	
		listaExpComaPtr,	//Puntero de lista expresion coma
		elseBloquePtr,		//Puntero para el bloque del else
		thenBloquePtr,		//Puntero para el bloque del then
		expreLogAuxPtr,
		auxBloquePtr,
		auxAritPtr,
		auxPtr,
		auxIfPtr,
		declConstantePtr,	//Puntero decl_constante
		exprCMPPtr,
		seleccionPtr,
		seleccionIFPtr,
		seleccionIFElsePtr,
		comparadorPtr,
		comparacionPtr,
		comparacionAuxPtr,
		condicionPtr,
		auxCondicionPtr,
		auxMaxNodo,
		exprMaximoPtr,
		auxEtiqPtr,
		auxWhilePtr,
		auxCond,
		operDerPtr,
		operIzqPtr,
		programaPtr,
		lecturaPtr,
		escrituraPtr,
		decisionesPtr,
		condiAuxPtr,
		cuerpoIfPtr,
		auxPtrIf2,
		condicionPtrIzq,
		cicloPtr;
	

//PILA



typedef struct sNodoP
{
    void           *info;
    unsigned        tamInfo;
    struct sNodoP   *sig;
} tNodoP;
typedef tNodoP *tPila;

tPila pilaExpresion;
tPila pilaTermino;
tPila pilaFactor;
tPila pilaOperadoresCond;
tPila pilaPrograma;
tPila pilaCondicion;
tPila pilaProgramaFalso;

void crearPila(tPila *p);
int  pilaLlena(const tPila *p, unsigned cantBytes);
int  ponerEnPila(tPila *p, const void *d, unsigned cantBytes);
int  verTope(const tPila *p, void *d, unsigned cantBytes);
int  pilaVacia(const tPila *p);
int  sacarDePila(tPila *p, void *d, unsigned cantBytes);
void vaciarPila(tPila *p);


tNodo *copiarDato(tNodo *);

#endif