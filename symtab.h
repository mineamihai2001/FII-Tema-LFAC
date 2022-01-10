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

typedef struct var
{
    int intvalue;
    char *charvalue;
    char name[1024];
    int init;
};

struct var varTab[1024];
int varCounter = 0;

void createInt(char x[], int v)
{
    strcpy(varTab[varCounter].name, x);
    varTab[varCounter].init = 1;
    varTab[varCounter].intvalue = v;
    varCounter++;
}

void createString(char x[], char *v)
{
    strcpy(varTab[varCounter].name, x);
    varTab[varCounter].init = 1;
    strcpy(varTab[varCounter].charvalue, v);
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

void assignInt(char x[], int v)
{
    int p = checkDeclared(x);
    varTab[p].intvalue = v;
    varTab[p].init = 1;
}

void assignString(char x[], char *v)
{
    int p = checkDeclared(x);
    strcpy(varTab[p].charvalue, v);
    varTab[p].init = 1;
}

// int verifinit(char x[])
// {
//     int i;
//     for (i = 0; i <= varCounter; i++)
//         if (strcmp(x, varTab[i].name) == 0)
//             if (varTab[i].init == 0)
//                 return -1;
//             else
//                 return 1;
//     return -1;
// }
