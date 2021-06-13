#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "funciones.h"

char msg[100];
char aux_str[50];

void colocarEnTablaSimb(char *ptr, int esCte, int linea, int tDatoCte)
{
	int i = 0, dupli = 0;
	if (esCte)
		sprintf(aux_str, "_%s", ptr);
	while (i < cuentaRegs && !dupli)
	{
		if (!strcmp(tablaSimb[i].lexema, esCte ? aux_str : ptr))
			dupli = 1;
		i++;
	}
	if (!dupli)
	{
		tablaSimb[cuentaRegs].longitud = strlen(ptr);
		if (esCte)
		{
			strcpy(tablaSimb[cuentaRegs].valor, ptr);
			strcpy(tablaSimb[cuentaRegs].lexema, aux_str);
			tablaSimb[cuentaRegs].tipoDeDato = tDatoCte;
		}
		else
			strcpy(tablaSimb[cuentaRegs].lexema, ptr);

		cuentaRegs++;
	}
	else
	{
		if (!esCte)
		{
			sprintf(msg, "'%s' ya se encuentra declarada previamente.", ptr);
			mensajeDeError(ErrorSintactico, msg, linea);
		}
	}
}

void generaIntermediaIf()
{
	sacarDePila(&pilaCondicion, &condicionPtr, sizeof(condicionPtr));
	decisionesPtr = crearNodo("IF", condicionPtr, programaPtr);
	if (!sacarDePila(&pilaPrograma, &programaPtr, sizeof(programaPtr)))
		programaPtr = NULL;
}

void generaIntermediaIfConElse()
{
	sacarDePila(&pilaCondicion, &condicionPtr, sizeof(condicionPtr));
	sacarDePila(&pilaPrograma, &auxBloquePtr, sizeof(programaPtr));
	cuerpoIfPtr = crearNodo("CUERPOIF", auxBloquePtr, programaPtr);
	decisionesPtr = crearNodo("IF", condicionPtr, cuerpoIfPtr);
	if (!sacarDePila(&pilaPrograma, &programaPtr, sizeof(programaPtr)))
		programaPtr = NULL;
}
void generaIntermediaWhile()
{
	sacarDePila(&pilaCondicion, &condicionPtr, sizeof(condicionPtr));
	cicloPtr = crearNodo("WHILE", condicionPtr, programaPtr);
	if (!sacarDePila(&pilaPrograma, &programaPtr, sizeof(programaPtr)))
		programaPtr = NULL;
}

int chequearVarEnTabla(char *lexema, int linea)
{
	int pos = 0;
	pos = buscarEnTabla(lexema);
	//Si no existe en la tabla, error
	if (pos == -1)
	{
		sprintf(msg, "La variable '%s' debe ser declarada previamente en la seccion de declaracion de variables", lexema);
		mensajeDeError(ErrorSintactico, msg, linea);
	}
	//Si existe en la tabla, dejo que la compilacion siga
	return pos;
}

int buscarEnTabla(char *nombre)
{
	int i = 0, pos = -1;
	while (i < cuentaRegs)
	{
		if (!strcmp(tablaSimb[i].lexema, nombre))
		{
			pos = i;
		}
		i++;
	}
	return pos;
}

void mensajeDeError(enum tipoError error, const char *info, int linea)
{
	switch (error)
	{
	case ErrorLexico:
		printf("ERROR Lexico en la linea %d. Descripcion: %s\n", linea, info);
		break;

	case ErrorSintactico:
		printf("ERROR Sintactico en la linea %d. Descripcion: %s.\n", linea, info);
		break;
	}
	system("Pause");
	exit(1);
}

void agregarTiposDatosCte(int tDato)
{
	tablaSimb[cuentaRegs - 1].tipoDeDato = tDato;
}

void agregarTipoDeDatoVarAtabla(int tDato)
{
	int i = 0, actual = 0;
	while (actual < _cantIds)
	{
		tablaSimb[cuentaRegs - actual - 1].tipoDeDato = tDato;
		actual++;
	}
}

void grabarTabla()
{
	int i;
	fprintf(tab, "%-30s|%-30s|%-30s|%s\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
	fprintf(tab, "---------------------------------------------------------------------------------------------------------------------------------------------\n");

	for (i = 0; i < cuentaRegs; i++)
	{
		fprintf(tab, "%-30s", tablaSimb[i].lexema);
		switch (tablaSimb[i].tipoDeDato)
		{
		case Float:
			fprintf(tab, "|%-30s|%-30s|%d", "FLOAT", "--", tablaSimb[i].longitud);
			break;
		case Integer:
			fprintf(tab, "|%-30s|%-30s|%d", "INTEGER", "--", tablaSimb[i].longitud);
			break;
		case String:
			fprintf(tab, "|%-30s|%-30s|%d", "STRING", "--", tablaSimb[i].longitud);
			break;
		case CteFloat:
			fprintf(tab, "|%-30s|%-30s|%d", "CTE_FLOAT", tablaSimb[i].valor, tablaSimb[i].longitud);
			break;
		case CteInt:

			fprintf(tab, "|%-30s|%-30s|%d", "CTE_INT", tablaSimb[i].valor, tablaSimb[i].longitud);
			break;
		case CteString:
			fprintf(tab, "|%-30s|%-30s|%d", "CTE_STRING", tablaSimb[i].valor, tablaSimb[i].longitud);
			break;
		}
		fprintf(tab, "\n");
	}
	fclose(tab);
}

void invertirCondicion(char *condicion)
{
	if (strcmp(condicion, "BEQ") == 0)
	{
		strcpy(condicion, "BNE");
	}
	else if (strcmp(condicion, "BNE") == 0)
	{
		strcpy(condicion, "BEQ");
	}
	else if (strcmp(condicion, "BGT") == 0)
	{
		strcpy(condicion, "BLT");
	}
	else if (strcmp(condicion, "BLT") == 0)
	{
		strcpy(condicion, "BGT");
	}
	else if (strcmp(condicion, "BGE") == 0)
	{
		strcpy(condicion, "BLE");
	}
	else if (strcmp(condicion, "BLE") == 0)
	{
		strcpy(condicion, "BGE");
	}
}

int verifRangoString(char *ptr, int linea)
{
	if ((strlen(ptr) - 2) > LIMITE) //-2 para que no cuente las comillas
	{
		sprintf(msg, "la cadena (%s) supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}

void esVariableNumerica(int posDeTabla, int linea)
{
	int tDato = tablaSimb[posDeTabla].tipoDeDato;
	if (tDato != Integer && tDato != Float)
	{
		sprintf(msg, "Solo se muestran variables numericas:la variable (%s) no es una variable numerica", tablaSimb[posDeTabla].lexema);
		mensajeDeError(ErrorSintactico, msg, linea);
	}
}

void errorDeCompatibilidadOperadores(tArbol *operaIzq, tArbol *operaDer, int linea)
{
	if (!verificarCompatible((*operaDer)->info.tipoDato, (*operaIzq)->info.tipoDato))
	{
		sprintf(msg, "Los operadores %s y %s de la condicion no son compatibles", (*operaIzq)->info.dato, (*operaDer)->info.dato);
		mensajeDeError(ErrorSintactico, msg, linea);
	}
}

int verifRangoID(char *ptr, int linea)
{
	if ((strlen(ptr)) > LIMITE)
	{
		sprintf(msg, "La variable: %s supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}
int verifRangoCTE_ENT(char *ptr, int linea)
{
	if (strlen(ptr) > LIMITEENT || atoi(ptr) > 32767) //no hay numeros negativos en el lexico
	{
		sprintf(msg, "La constante: %s supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}

int verifRangoCTE_REAL(char *ptr, int linea)
{
	if (atof(ptr) > 3.40282347e+38F || atof(ptr) < 3.40282347e-38F)
	{
		sprintf(msg, "la constante real: %s supera el rango permitido", ptr);
		mensajeDeError(ErrorLexico, msg, linea);
	}
	return 0;
}
void errorCaracter(char *ptr, int linea)
{
	sprintf(msg, "Caracter: %s invalido", ptr);
	mensajeDeError(ErrorLexico, msg, linea);
}

tNodo *crearNodo(const char *dato, tNodo *pIzq, tNodo *pDer)
{

	tNodo *nodo = malloc(sizeof(tNodo));
	tInfo info;
	strcpy(info.dato, dato);
	nodo->info = info;
	nodo->izq = pIzq;
	nodo->der = pDer;

	return nodo;
}

tNodo *crearHoja(char *dato, int tipo)
{
	tNodo *nodoNuevo = (tNodo *)malloc(sizeof(tNodo));

	strcpy(nodoNuevo->info.dato, dato);
	nodoNuevo->info.tipoDato = tipo;
	nodoNuevo->izq = NULL;
	nodoNuevo->der = NULL;

	return nodoNuevo;
}

tArbol *hijoMasIzq(tArbol *p)
{
	if (*p)
	{
		if ((*p)->izq)
			return hijoMasIzq(&(*p)->izq);
		else
			return p;
	}
	return NULL;
}

void enOrden(tArbol *p)
{
	if (*p)
	{
		enOrden(&(*p)->izq);
		verNodo((*p)->info.dato);
		enOrden(&(*p)->der);
	}
}

void postOrden(tArbol *p)
{
	if (*p)
	{
		postOrden(&(*p)->izq);
		postOrden(&(*p)->der);
		verNodo((*p)->info.dato);
	}
}

void verNodo(const char *p)
{
	printf("%s ", p);
}

void _tree_print_dot_subtree(int nro_padre, tNodo *padre, int nro, tArbol *nodo, FILE *stream)
{
	if (*nodo != NULL)
	{
		fprintf(stream, "x%d [label=<%s>];\n", nro, (*nodo)->info.dato);
		if (padre != NULL)
		{
			fprintf(stream, "x%d -> x%d;\n", nro_padre, nro);
		}
		_tree_print_dot_subtree(nro, *nodo, 2 * nro + 1, &(*nodo)->izq, stream);
		_tree_print_dot_subtree(nro, *nodo, 2 * nro + 2, &(*nodo)->der, stream);
	}
}

void tree_print_dot(tArbol *p, FILE *stream)
{
	fprintf(stream, "digraph BST {\n");
	if (*p)
		_tree_print_dot_subtree(-1, NULL, 0, &(*p), stream);
	fprintf(stream, "}");
}

void verificarTipo(tArbol *p, int tipoAux, int linea)
{
	int compatible, tipo;
	if (*p)
	{
		verificarTipo(&(*p)->izq, tipoAux, linea);
		verificarTipo(&(*p)->der, tipoAux, linea);
		if ((*p)->izq == NULL && (*p)->der == NULL)
		{
			tipo = (*p)->info.tipoDato;
			compatible = verificarCompatible(tipo, tipoAux);
			printf("   ");
		}
		if (!compatible)
		{
			mensajeDeError(ErrorSintactico, "tipos no compatibles", linea);
		}
	}
}

int verificarTipoDato(tArbol *p, int linea)
{
	tArbol *pAux = hijoMasIzq(p); //tipo a comparar contra el resto
	int tipoAux = (*pAux)->info.tipoDato;
	verificarTipo(p, tipoAux, linea);
}

int verificarCompatible(int tipo, int tipoAux)
{
	if (tipo == tipoAux)
		return TRUE;
	if (tipo == CteInt && tipoAux == Integer || tipoAux == CteInt && tipo == Integer)
		return TRUE;
	if (tipo == CteFloat && tipoAux == Float || tipoAux == CteFloat && tipo == Float)
		return TRUE;
	if (tipo == CteString && tipoAux == String || tipoAux == CteString && tipo == String)
		return TRUE;
	return FALSE;
}
