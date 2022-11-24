/*** Definition Section ***/
%{
#include <string.h>

typedef struct {
    char token[257];
    int symbolTableCode;
}PIF;

typedef struct{
    char token[257];
    int index;
}ST;

ST SymbolTable[100];
int stLength = 0;

PIF ProgramInternalForm[300];
int pifLength = 0;

int errorFound = 0;
int lineNumber = 1;


int addToST(char* token) {
	for(int i = 0; i < stLength; i++) {
		
		if(strcmp(SymbolTable[i].token, token) == 0) {
		  return SymbolTable[i].index;
		}
	}
	strcpy(SymbolTable[stLength].token, token);
	SymbolTable[stLength].index = stLength;
	stLength++;
	
	return stLength - 1;
}

void addToPIF(char* token, int stCode) {
	strcpy(ProgramInternalForm[pifLength].token, token);
	ProgramInternalForm[pifLength].symbolTableCode = stCode;
	
	pifLength++;
}

void showSymbolTable() {
    printf("~~~~~~~ Symbol table ~~~~~~~\n");
    
    for(int i = 0 ; i < stLength; i++) {
        printf(" %s  %d", SymbolTable[i].token, SymbolTable[i].index);
        printf("\n");
    }
    
    printf("~~~~~~~ End ST ~~~~~~~\n");
    printf("\n");
}

void showProgramInternalForm() {
    printf("~~~~~~~ Program internal form ~~~~~~~\n");
    
    for(int i = 0; i < pifLength; i++) {
    
        printf(" %s  %d ", ProgramInternalForm[i].token, ProgramInternalForm[i].symbolTableCode);
        printf("\n");
    }
    
    printf("~~~~~~~ End PIF ~~~~~~~\n");
    printf("\n");
}

%}


REAL_NUMBER  [+-]?(0|[1-9][0-9]*)(\.[0-9]+)?
IDENTIFIER   [a-z][a-z0-9_]*
STRING       \".*\"

/*** Rule Section ***/
%%
					/* yytext is the text in the buffer */
integer                                    	{ addToPIF(yytext, -1); }
main                                   { addToPIF(yytext, -1); }
print                                    	{ addToPIF(yytext, -1); }
string                                   { addToPIF(yytext, -1); }
function                                    { addToPIF(yytext, -1); }
boolean                                    { addToPIF(yytext, -1); }
then                                    	{ addToPIF(yytext, -1); }
False                                    { addToPIF(yytext, -1); }
True                                    { addToPIF(yytext, -1); }
return                                    { addToPIF(yytext, -1); }
getinput                                    { addToPIF(yytext, -1); }
var                                    { addToPIF(yytext, -1); }
if                                    { addToPIF(yytext, -1); }
for                                    { addToPIF(yytext, -1); }
to                                    { addToPIF(yytext, -1); }
displayoutput                                    { addToPIF(yytext, -1); }
program                                    { addToPIF(yytext, -1); }
\;                                    	{ addToPIF(yytext, -1); }
\{                                    	{ addToPIF(yytext, -1); }
\}                                    	{ addToPIF(yytext, -1); }
\(                                    	{ addToPIF(yytext, -1); }
\)                                    	{ addToPIF(yytext, -1); }
\,                                    	{ addToPIF(yytext, -1); }
\+                                    	{ addToPIF(yytext, -1); }
\-                                    	{ addToPIF(yytext, -1); }
\*                                    	{ addToPIF(yytext, -1); }
\/                                    	{ addToPIF(yytext, -1); }
\:                                    	{ addToPIF(yytext, -1); }
\%                                    	{ addToPIF(yytext, -1); }
\>                                    	{ addToPIF(yytext, -1); }
\<                                    	{ addToPIF(yytext, -1); }
\>=                                    	{ addToPIF(yytext, -1); }
\<=                                    	{ addToPIF(yytext, -1); }
\=                                    	{ addToPIF(yytext, -1); }
\==                                    	{ addToPIF(yytext, -1); }
\and                                    { addToPIF(yytext, -1); }
\or                                    	{ addToPIF(yytext, -1); }
\.                                    	{ addToPIF(yytext, -1); }
\!=                                    	{ addToPIF(yytext, -1); }
{IDENTIFIER}				{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{REAL_NUMBER}                           { int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{STRING}				{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
[\n]					{ ++lineNumber; }
[ \t\n]+             			{ ; /* eat up whitespace */ }
.                			{ errorFound = 1; printf("Illegal token %s at line %d !", yytext, lineNumber); printf("\n"); }
%%

/* yywrap() - wraps the above rule section */
int yywrap() {}

int main(int argc, char** argv) {

	FILE *fp;
	fp = fopen(argv[1], "r");
	
	/* yyin - takes the file pointer which contains the input*/
	yyin = fp;

	/* yylex() - this is the main flex function which runs the Rule Section*/ 
	yylex();
	
	if (errorFound == 0) {
    		showSymbolTable();
    		showProgramInternalForm();
	}
  
	return 0;
}
