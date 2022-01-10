#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

typedef struct expr_info
{
    int intvalue;
    char *strvalue;
    int type;
} expr_info;

typedef struct symtab
{
    int valoare;
    char *nume;
    int tip;
} symtab;

struct var
{
    int intvalue;
    char *charvalue;
    char name[1024];
    int type; // 1-int, 2-char, 3-class
    int init; // is initialized
    int global;
} varTab[1024];

// struct var varTab[1024];
int varCounter = 0;

void createInt(char x[], int val)
{
    strcpy(varTab[varCounter].name, x);
    varTab[varCounter].init = 1;
    varTab[varCounter].intvalue = val;
    varTab[varCounter].type = 1;
    varCounter++;
}

void createString(char x[], char *val)
{
    strcpy(varTab[varCounter].name, x);
    varTab[varCounter].init = 1;
    strcpy(varTab[varCounter].charvalue, val);
    varTab[varCounter].type = 2;
    varCounter++;
}

void createClass(char x[], char *val)
{
    strcpy(varTab[varCounter].name, x);
    varTab[varCounter].init = 1;
    strcpy(varTab[varCounter].charvalue, val);
    varTab[varCounter].type = 3;
    varCounter++;
}

void declare(char x[])
{
    strcpy(varTab[varCounter].name, x);
    varTab[varCounter].init = 0;
    varCounter++;
}

int checkDeclared(char x[])
{
    int i;
    for (i = 0; i <= varCounter; i++)
        if (strcmp(x, varTab[i].name) == 0)
        {
            return i;
        }
    return -1;
}

void assignInt(char x[], int val)
{
    int p = checkDeclared(x);
    varTab[p].intvalue = val;
    varTab[p].init = 1;
}

void assignString(char x[], char *val)
{
    int p = checkDeclared(x);
    strcpy(varTab[p].charvalue, val);
    varTab[p].init = 1;
}

int assignID(char x[], char y[])
{
    int i = checkDeclared(x);
    int j = checkDeclared(y);

    if (varTab[i].type == varTab[j].type)
    {
        if (varTab[i].type == 1) // int
            varTab[i].intvalue = varTab[j].intvalue;
        else if (varTab[i].type == 2) // char
            strcpy(varTab[i].charvalue, varTab[j].charvalue);
    }
    else return -1;
    return 0;
}
void Print(char *string, char *variable)
{
    for (int i = 0; i <= varCounter; ++i)
    {
        if (strcmp(variable, varTab[i].name) == 0)
        {
            if (string != NULL)
            {
                // printf("String = %s\n", string);
                if (varTab[i].type == 1) // int
                    printf("%s %d\n", string, varTab[i].intvalue);
                if (varTab[i].type == 2) // char
                    printf("%s %s\n", string, varTab[i].charvalue);
            }
            else
            {
                if (varTab[i].type == 1) // int
                    printf("%d\n", varTab[i].intvalue);
                if (varTab[i].type == 2) // char
                    printf("%s\n", varTab[i].charvalue);
            }
        }
    }
}

int printTab()
{
    FILE *symTab;
    FILE *functTab;
    symTab = fopen("symbol_table.txt", "w+");             // for variables
    functTab = fopen("symbol_table_functions.txt", "w+"); // for functions

    if (symTab == NULL)
    {
        perror("Eroare la creare fisier pt simboluri\n");
        return errno;
    }
    if (functTab == NULL)
    {
        perror("Eroare la creare fisier pt functii\n");
        return errno;
    }

    for (int i = 0; i < varCounter; ++i)
    {
        if (varTab[i].type == 1)
            fprintf(symTab, "int %s = %d\n", varTab[i].name, varTab[i].intvalue);
        if (varTab[i].type == 2)
            fprintf(symTab, "int %s = %s\n", varTab[i].name, varTab[i].charvalue);
    }

    fclose(symTab);
    fclose(functTab);
    return 1;
}
