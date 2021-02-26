%{
	#include "y.tab.h"
    	void yyerror(const char*);
%}
digit 		[0-9]
number		[0]|[1-9]{digit}*|[-][1-9]{digit}*
letter		[a-z]
ID		{letter}({letter}{digit}'-')*
%%
{number}	{ yylval.ival=atoi(yytext);
		  return number;}
{ID}		{ yylval.sval=strdup(yytext);
		  return ID; }
\n		{ }
[\t]		{ }
" "		{ }
"+"|"-"|"*"|"/"	{ return yytext[0]; }
"mod"		{ return modulus; }
">"|"<"|"="	{ return yytext[0]; }
"and"		{ return And; }
"or"		{ return Or; }
"not"		{ return Not; }
"define"	{ return DEFINE; }
"#t"		{ return atrue; }
"#f"		{ return afalse; }
"if"		{ return If; }
"print-num"	{ return pn; }
"print-bool"	{ return pb; }
"("		{ return yytext[0]; }
")"		{ return yytext[0]; }
<<EOF>>		{ return ENDOFINPUT; }
%%
int yywrap(void){
   return 1;
}

