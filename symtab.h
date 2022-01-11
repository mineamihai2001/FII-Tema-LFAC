#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <stdarg.h>

typedef struct AST
{
    int operator_type, value;
    char *operator;
    struct AST *left_tree;
    struct AST *right_tree;
} AST;

typedef struct expr_info
{
    int intvalue;
    int type;
    AST *tree;
} expr_info;

typedef struct symtab
{
    int valoare;
    char *nume;
} symtab;

struct var
{
    int intvalue;
    float floatvalue;
    char *charvalue;
    char name[1024];
    int type; // 1-int, 2-char, 3-float
    int init; // is initialized
    int global;
} varTab[1024];

struct funct
{
    int intvalue;
    float floatvalue;
    char *charvalue;
    char name[1024];
    int type; // 1-int, 2-char, 3-float
    int init; // is initialized
    int paramCounter;
    struct var params[16];
} functTab[128];

struct scope
{
    struct var members[64];
    struct funct methods[64];
};

struct class
{
    char *name;
    struct scope private;
    struct scope public;
} class[128];

int varCounter = 0;
int functCounter = 0;

void assignInt(char varName[], int val)
{
    int i = checkDeclared(varName);
    varTab[i].init = 1;
    varTab[i].intvalue = val;
}

void assignString(char varName[], char *val)
{
    int i = checkDeclared(varName);
    varTab[i].init = 1;
    varTab[i].charvalue = val;
}

void createFunction(char functName[], char *type, char varName[])
{
    strcpy(functTab[functCounter].name, functName);
    // printf("%s creat %d\n", functTab[functCounter].name, functCounter);
    // for(int i=0; i<functTab[functCounter].paramCounter;++i)
    // {
    //         printf("FCT: %s\tparam: %d\t counter: %d\n", functTab[functCounter].name, i, functCounter);

    // }
    int i = checkDeclared(varName);
    if (strcmp(type, "int") == 0)
    {
        functTab[functCounter].type = 1;
        functTab[functCounter].intvalue = varTab[i].intvalue;
    }
    else if (strcmp(type, "char") == 0)
    {
        functTab[functCounter].type = 2;
        functTab[functCounter].charvalue = varTab[i].charvalue;
    }
    else if (strcmp(type, "float") == 0)
        functTab[functCounter].type = 3;
    ++functCounter;
    functTab[functCounter].paramCounter = 0;
}

void addParam(char paramName[], char *type)
{
    char functName[100];
    int paramCounter = functTab[functCounter].paramCounter;

    strcpy(functName, functTab[functCounter].name);

    // int i = checkFunctDeclared(functName)functCounter
    if (strcmp(type, "int") == 0)
        functTab[functCounter].params[paramCounter].type = 1;
    else if (strcmp(type, "char") == 0)
        functTab[functCounter].params[paramCounter].type = 2;
    if (strcmp(type, "float") == 0)
        functTab[functCounter].params[paramCounter].type = 3;
    strcpy(functTab[functCounter].params[paramCounter].name, paramName);
    functTab[functCounter].params[paramCounter].init = 0;

    functTab[functCounter].paramCounter++;
}

void createClass(char className[])
{
    //...add class name to the class[i] struct

    //...add members and methods to each scope[i] struct
}

void declare(char varName[], char *type)
{
    // printf("type: %s\n", type);
    if (strcmp(type, "int") == 0)
        varTab[varCounter].type = 1;
    else if (strcmp(type, "char") == 0)
        varTab[varCounter].type = 2;
    else if (strcmp(type, "float") == 0)
        varTab[varCounter].type = 3;
    strcpy(varTab[varCounter].name, varName);
    varTab[varCounter].init = 0;
    varTab[varCounter].init = 0;
    varCounter++;
}

void declareGlobal(char varName[], char *type)
{
    // printf("type: %s\n", type);
    if (strcmp(type, "int") == 0)
        varTab[varCounter].type = 1;
    else if (strcmp(type, "char") == 0)
        varTab[varCounter].type = 2;
    if (strcmp(type, "float") == 0)
        varTab[varCounter].type = 3;
    strcpy(varTab[varCounter].name, varName);
    varTab[varCounter].init = 1;
    varTab[varCounter].global = 1;
    varCounter++;
}

int checkDeclared(char varName[])
{
    int i;
    for (i = 0; i <= varCounter; i++)
        if (strcmp(varName, varTab[i].name) == 0)
        {
            return i;
        }
    return -1;
}

int checkFunctDeclared(char functName[])
{
    int i;
    for (i = 0; i <= functCounter; i++)
        if (strcmp(functName, functTab[i].name) == 0)
        {
            return i;
        }
    
    return -1;
}

int assignID(char x[], char y[])
{
    int i = checkDeclared(x);
    int j = checkDeclared(y);

    if (varTab[i].type == varTab[j].type)
    {
        if (varTab[i].type == 1) // int
        {
            // printf("%s (%d) = %s (%d)\n", x, varTab[i].intvalue, y, varTab[j].intvalue);
            varTab[i].intvalue = varTab[j].intvalue;
        }
        else if (varTab[i].type == 2) // char
        {
            strcpy(varTab[i].charvalue, varTab[j].charvalue);
        }
    }
    else
        return -1;
    return 0;
}

int assignFunct(char varName[], char functName[])
{
    int i = checkDeclared(varName);
    int j = checkFunctDeclared(functName);

    if (varTab[i].type == functTab[j].type)
    {
        if (varTab[i].type == 1) // int
        {
            // printf("%s (%d) = %s (%d)\n",  varTab[i].name, varTab[i].intvalue, functName, functTab[j].intvalue);
            varTab[i].intvalue = functTab[j].intvalue;
        }
        else if (varTab[i].type == 2) // char
        {
            varTab[i].charvalue = functTab[j].charvalue;
        }
    }
    else
        return -1;
    return 0;
}

void Print(char *string, char *variable)
{
    for (int i = 0; i < varCounter; ++i)
    {
        if (strcmp(variable, varTab[i].name) == 0)
        {
            if (string != NULL)
            {
                // printf("String = %s\n", string);
                if (varTab[i].type == 1) // int
                    printf("%s %d\n", string, varTab[i].intvalue);
                else if (varTab[i].type == 2) // char
                    printf("%s %s\n", string, varTab[i].charvalue);
            }
            else
            {
                if (varTab[i].type == 1) // int
                    printf("%d\n", varTab[i].intvalue);
                else if (varTab[i].type == 2) // char
                    printf("%s\n", varTab[i].charvalue);
            }
        }
    }
}

int printTab()
{
    FILE *symTab;
    FILE *fctTab;
    symTab = fopen("symbol_table.txt", "w+");           // for variables
    fctTab = fopen("symbol_table_functions.txt", "w+"); // for functions

    if (symTab == NULL)
    {
        perror("Eroare la creare fisier pt simboluri\n");
        return errno;
    }
    if (fctTab == NULL)
    {
        perror("Eroare la creare fisier pt functii\n");
        return errno;
    }

    char *isGlobal;
    for (int i = 0; i < varCounter; ++i)
    {
        if (varTab[i].global == 1)
            isGlobal = "global";
        else
            isGlobal = "local";
        if (varTab[i].type == 1)
            fprintf(symTab, "int %s = %d (%s)\n", varTab[i].name, varTab[i].intvalue, isGlobal);
        if (varTab[i].type == 2)
            fprintf(symTab, "char %s = %s (%s)\n", varTab[i].name, varTab[i].charvalue, isGlobal);
    }

    for (int i = 0; i < functCounter; ++i)
    {
        if (functTab[i].type == 1)
            fprintf(fctTab, "int %s (", functTab[i].name);
        else if (functTab[i].type == 2)
            fprintf(fctTab, "char %s (", functTab[i].name);
        int length = functTab[i].paramCounter;
        for (int j = 0; j < length - 1; ++j)
        {
            if (functTab[i].params[j].type == 1)
                fprintf(fctTab, "int %s, ", functTab[i].params[j].name);
            else if (functTab[i].params[j].type == 2)
                fprintf(fctTab, "char %s, ", functTab[i].params[j].name);
            else if (functTab[i].params[j].type == 3)
                fprintf(fctTab, "float %s, ", functTab[i].params[j].name);
        }
        if (functTab[i].params[length - 1].type == 1)
            fprintf(fctTab, "int %s)\n", functTab[i].params[length - 1].name);
        else if (functTab[i].params[length - 1].type == 2)
            fprintf(fctTab, "char %s)\n", functTab[i].params[length - 1].name);
        else if (functTab[i].params[length - 1].type == 3)
            fprintf(fctTab, "float %s)\n", functTab[i].params[length - 1].name);
    }

    fclose(symTab);
    fclose(fctTab);
    return 1;
}




symtab *assign(int value, char *nume)
{
    symtab *id = (symtab *)malloc(sizeof(symtab));
    id->valoare = value;
    return id;
}

int print_var_info(symtab *id)
{
    printf("ID %s with value:%d\n", id->nume, id->valoare);
    return id->valoare;
}

expr_info *create_bool_expr(int value)
{
    expr_info *expr = (expr_info *)malloc(sizeof(expr_info));
    expr->intvalue = 0;
    if (value)
        expr->intvalue = 1;
    expr->type = 1;
    return expr;
}

expr_info *create_int_expr(int value)
{
    expr_info *expr = (expr_info *)malloc(sizeof(expr_info));
    expr->intvalue = value;
    expr->type = 1;
    return expr;
}

// void free_expr(expr_info* expr)
// {
//   if(expr->type == 2)
//   {
//      free(expr->strvalue);
//   }
//   free(expr);
// }
