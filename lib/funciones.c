#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "funciones.h"

char msg[100];
char aux_str[50];
char auxAssembE[50];
char auxAssembR[50];
int auxEntero = 0;
int auxReal = 0;

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

void enOrden(tArbol *p, FILE *pfIntermedia)
{
	if (*p)
	{
		enOrden(&(*p)->izq, pfIntermedia);
		verNodo((*p)->info.dato, pfIntermedia);
		enOrden(&(*p)->der, pfIntermedia);
	}
}

void postOrden(tArbol *p, FILE *pfIntermedia)
{
	if (*p)
	{
		postOrden(&(*p)->izq, pfIntermedia);
		postOrden(&(*p)->der, pfIntermedia);
		verNodo((*p)->info.dato, pfIntermedia);
	}
}

void verNodo(const char *p, FILE *pfIntermedia)
{
	printf("%s ", p);
	fprintf(pfIntermedia, "%s ", p);
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

void generaAssembler(tArbol *intemedia)
{
	int i;
	FILE *pf = fopen("Final.asm", "w+");
	if (!pf)
	{
		printf("Error al guardar el archivo assembler.\n");
		exit(1);
	}
	crearPila(&pilaAssembler);
	//includes
	fprintf(pf, "include macros2.asm\n");
	fprintf(pf, "include number.asm\n\n");
	fprintf(pf, ".MODEL LARGE\n.STACK 200h\n.386\n.DATA\n\n");
	fprintf(pf, "%-30s%-20s%-20s\n", "MAXTEXTSIZE", "equ", "40");

	for (i = 0; i < auxOp; i++)
	{
		sprintf(auxAssembR, "_auxR%d", i);
		sprintf(auxAssembE, "_auxE%d", i);
		fprintf(pf, "%-30s%-20s%-20s\n", auxAssembR, "dd", "0.0");
		fprintf(pf, "%-30s%-20s%-20s\n", auxAssembE, "dd", "0");
	}

	for (i = 0; i < cuentaRegs; i++)
	{
		fprintf(pf, "%-30s", tablaSimb[i].lexema);
		switch (tablaSimb[i].tipoDeDato)
		{
		case Float:
			fprintf(pf, "%-20s%-20s", "dd", "?");
			break;
		case Integer:
			fprintf(pf, "%-20s%-20s", "dd", "?");
			break;
		case String:
			fprintf(pf, "%-20s%-20s", "dd", "?");
			break;
		case CteFloat:
			fprintf(pf, "%-20s%-20s", "dd", tablaSimb[i].valor);
			break;
		case CteInt:
			fprintf(pf, "%-20s%-20s", "dd", tablaSimb[i].valor);
			break;
		case CteString:
			fprintf(pf, "%-20s%-20s", "dd", tablaSimb[i].valor);
			break;
		}
		fprintf(pf, "\n");
	}

	fprintf(pf,"\n.CODE\n.startup\n\tmov AX,@DATA\n\tmov DS,AX\nFINIT\n\n");
	fprintf(pf, "\n");

	recorrerIntermedia(intemedia, pf);

	fprintf(pf, "\nmov ax, 4c00h\nint 21h\n\n");

	//FUNCIONES PARA MANEJO DE ENTRADA/SALIDA Y CADENAS
	fprintf(pf,"\nstrlen proc\n\tmov bx, 0\n\tstrl01:\n\tcmp BYTE PTR [si+bx],'$'\n\tje strend\n\tinc bx\n\tjmp strl01\n\tstrend:\n\tret\nstrlen endp\n");
	fprintf(pf,"\ncopiar proc\n\tcall strlen\n\tcmp bx , MAXTEXTSIZE\n\tjle copiarSizeOk\n\tmov bx , MAXTEXTSIZE\n\tcopiarSizeOk:\n\tmov cx , bx\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\ncopiar endp\n");
	fprintf(pf,"\nconcat proc\n\tpush ds\n\tpush si\n\tcall strlen\n\tmov dx , bx\n\tmov si , di\n\tpush es\n\tpop ds\n\tcall strlen\n\tadd di, bx\n\tadd bx, dx\n\tcmp bx , MAXTEXTSIZE\n\tjg concatSizeMal\n\tconcatSizeOk:\n\tmov cx , dx\n\tjmp concatSigo\n\tconcatSizeMal:\n\tsub bx , MAXTEXTSIZE\n\tsub dx , bx\n\tmov cx , dx\n\tconcatSigo:\n\tpush ds\n\tpop es\n\tpop si\n\tpop ds\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\nconcat endp\n");

	fprintf(pf, "\nEND");

	vaciarPila(&pilaAssembler);

	fclose(pf);
}

void recorrerIntermedia(tArbol *arbol, FILE *pf)
{
	if (*arbol)
	{
		recorrerIntermedia(&(*arbol)->izq, pf);
		recorrerIntermedia(&(*arbol)->der, pf);
		tratarNodo(arbol, pf);
	}
}

void tratarNodo(tArbol *nodo, FILE *pf)
{
	int pos, i;
	tInfo infoHojaDer;
	tInfo infoHojaIzq;
	char auxDatoAr[100];
	strcpy(auxDatoAr, (*nodo)->info.dato);
	pos = buscarEnTabla(auxDatoAr);
	if (pos != -1)
		ponerEnPila(&pilaAssembler, &(*nodo)->info, sizeof(tInfo));
	else
	{
		if (!strcmp(auxDatoAr, "OP_ASIG"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case Integer:
			case CteInt:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fild \t%s\n", infoHojaDer.dato);
				fprintf(pf, "fistp \t%s\n", infoHojaIzq.dato);
				break;
			case Float:
			case CteFloat:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "\tfld \t%s\n", infoHojaDer.tipoDato);
				fprintf(pf, "\tfstp \t%s\n", infoHojaIzq.tipoDato);
				break;
			case String:
			case CteString:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "mov ax, @DATA\nmov ds, ax\nmov es, ax\n");
				fprintf(pf, "mov si, OFFSET\t%s\n", infoHojaDer.tipoDato);
				fprintf(pf, "\tmov di, OFFSET\t%s\n", infoHojaIzq.tipoDato);
				fprintf(pf, "\tcall copiar\n");
				break;
			}
		}

		if (!strcmp(auxDatoAr, "OP_SUMA"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case CteFloat:
			case Float:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fld \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fadd \t%s\n", infoHojaDer.dato);
				sprintf(auxAssembE, "%s%d", "_auxR", auxReal);
				fprintf(pf, "fstp \t%s\n", auxAssembR);
				strcpy(infoHojaIzq.dato, auxAssembR); /// uso el infoHojaizq para no definir otro auxiliar
				infoHojaIzq.tipoDato = Integer;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxReal++;
				break;
			case CteInt:
			case Integer:
				sacarDePila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				fprintf(pf, "fild \t%s\n", infoHojaIzq.dato);
				fprintf(pf, "fiadd \t%s\n", infoHojaDer.dato);
				sprintf(auxAssembE, "%s%d", "_auxE", auxEntero);
				fprintf(pf, "fistp \t%s\n", auxAssembE);
				strcpy(infoHojaIzq.dato, auxAssembE);
				infoHojaIzq.tipoDato = Integer;
				ponerEnPila(&pilaAssembler, &infoHojaIzq, sizeof(tInfo));
				auxEntero++;
				break;
			}
		}

		if (!strcmp(auxDatoAr, "WRITE"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case Integer:
			case CteInt:
				fprintf(pf, "displayInteger \t%s,3\n",infoHojaDer.dato);
				break;
			case Float:
			case CteFloat:
				fprintf(pf, "displayFloat \t%s,3\n",infoHojaDer.dato);
				break;
			case String:
			case CteString:
				fprintf(pf, "displayString \t%s\nn",infoHojaDer.dato);
				break;
			}
		
		}

		if (!strcmp(auxDatoAr, "READ"))
		{
			sacarDePila(&pilaAssembler, &infoHojaDer, sizeof(tInfo));
			switch (infoHojaDer.tipoDato)
			{
			case Integer:
				fprintf(pf, "getInteger \t%s\n", infoHojaDer.dato);
				break;
			case Float:
				fprintf(pf, "getFloat \t%s\n", infoHojaDer.dato);
				break;
			case String:
				fprintf(pf, "getString \t%s\n", infoHojaDer.dato);
				break;
			}
		}
	}
}
