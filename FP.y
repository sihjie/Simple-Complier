%{
	#include <stdio.h>
    	int yylex(void);
   	void yyerror(const char*);
    	int temp;
	int i=0;
%}

%code provides {
	struct defval{
		char* name;
		int value;
	};
	struct defval s[100];
}

%union{
    	int ival;
	char* sval;
}

%token <ival> number
%token <sval> ID
%token pn
%token pb
%token modulus
%token And
%token Or
%token Not
%token atrue
%token afalse
%token If
%token DEFINE
%token ENDOFINPUT
%type <ival> Plus
%type <ival> PPlus
%type <ival> Minus
%type <ival> Multiply
%type <ival> MMultiply
%type <ival> Divide
%type <ival> Modulus
%type <ival> Greater
%type <ival> Smaller
%type <ival> Equal
%type <ival> EEqual
%type <ival> EXP
%type <ival> AND_OP
%type <ival> AAND_OP
%type <ival> OR_OP
%type <ival> OOR_OP
%type <ival> NOT_OP
%type <ival> bool_val
%type <ival> If_EXP
%type <ival> Logical_Op
%type <ival> Num_Op
%type <ival> Variable
%%
program : STMTs ENDOFINPUT 	{ return 0; }
STMTs  	: STMTs STMT | STMT 
STMT  	: EXP | Print_STMT | Define_STMT
Print_STMT 	: '(' pn EXP ')' { printf("%d\n",$3); }
  		| '(' pb EXP ')' { if($3==1) printf("#t\n");
       				   else  printf("#f\n");
     				 }
EXP  	: number | Variable | bool_val | Num_Op | Logical_Op | If_EXP
Num_Op  : Plus | Minus | Multiply | Divide | Modulus | Greater | Smaller | Equal
Plus  	: PPlus ')'  		{ $$=$1; }
PPlus  	: '(' '+' EXP EXP  	{ $$=$3+$4; }
  	| PPlus EXP  		{ $$=$1+$2; }
   
Minus  	: '(' '-' EXP EXP ')' 	{ $$=$3-$4; } 

Multiply: '(' MMultiply ')'  	{ $$=$2; }
MMultiply : '*' EXP EXP  	{ $$=$2*$3; }
  	  | MMultiply EXP  	{ $$=$1*$2; }

Divide  : '(' '/' EXP EXP ')' 	{ $$=$3/$4; }

Modulus : '(' modulus EXP EXP ')'{ $$=$3%$4; }

Greater : '(' '>' EXP EXP ')' 	{ if($3>$4)	$$=1; 
       				  else	$$=0;        }
          
Smaller : '(' '<' EXP EXP ')'  	{ if($3<$4)	$$=1;     
			     	  else  $$=0;
     				}		

Equal  	: EEqual ')'  		{ $$=$1; }
EEqual  : '(' '=' EXP EXP 	{ if($3==$4){
      					$$=1;
      					temp=$3;
       				  }
       				  else $$=0;
     				}
  	| EEqual EXP  		{ if($1==0) $$=0;
        			  else{
      					if($2==temp){
       						$$=1;
      					}
      					else{
       						$$=0;
      					}
       				  }
     				}

Logical_Op : AND_OP | OR_OP | NOT_OP

AND_OP  : AAND_OP ')'  		{ $$=$1; }
AAND_OP	: '(' And EXP EXP 	{ if($3==1 && $4==1) $$=1; 
       				  else   $$=0; 
     				}
  	| AAND_OP EXP  		{ if($1==1 && $2==1) $$=1;
       				  else   $$=0;
     				}	
   
OR_OP  	: OOR_OP ')'  		{ $$=$1; }
OOR_OP  : '(' Or EXP EXP 	{ if($3==0 && $4==0) $$=0;
       				  else   $$=1;
     				}
  	| OOR_OP EXP  		{ if($1==0 && $2==0) $$=0;
       				  else   $$=1;
     				}
   
NOT_OP  : '(' Not EXP ')' 	{ if($3==1)  $$=0;
       				  else   $$=1;  
     				}

If_EXP  : '(' If EXP EXP EXP ')' { if($3==1) $$=$4;  
          			   else   $$=$5;
       				 }

bool_val : atrue  		{ $$=1; } 
  	| afalse 		{ $$=0; }    

Define_STMT	: '(' DEFINE ID EXP ')'	{ s[i].name=$3;
					  s[i].value=$4;
					  i++;
					}
Variable	: ID			{ int j=0;
					  int k=0;
					  for(j=0;j<=i;j++){
						if(strcmp($1,s[j].name)==0){	// if identical,return 0
							$$=s[j].value;
							k=1;
							break;
						}
					  }
					  if(k==0)	printf("The value is not defined.\n");
					}
%%
void yyerror(const char *message) {
   printf("syntax error\n");
}
int main(void) {
    yyparse();
    return 0;
}


