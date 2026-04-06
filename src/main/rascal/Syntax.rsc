module Syntax

// esta parte la saque de el tutorial de rascal

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r];

lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "//" ![\n]* $;

lexical Id          = [a-z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-] \ Reserved;
lexical IntLiteral  = [0-9]+ !>> [0-9];
lexical FloatLiteral= [0-9]+ "." [0-9]+ !>> [0-9];
lexical CharLiteral = [\'] [a-zA-Z0-9\-] [\'];
lexical Arrow = [\-] [\>];

// Reserved keywords
keyword Reserved= "defmodule" | "using"  | "defspace" | "defrule" | "end" | "defoperator" | "defexpression" | "forall" | "exists" | "defvar" | "in" | "defer"
    | "and" | "or" | "neg";

// inicio
start syntax Module= \module: "defmodule" Id ImportList Declaration* "end";

syntax ImportList = importList: UsingClause*;
syntax UsingClause = usingClause: "using" Id;

// declaraciones
syntax Declaration= SpaceDecl | OperatorDecl | VarDecl | RuleDecl | ExpressionDecl | AttrDecl | RelDecl;

syntax SpaceDecl = spaceDecl: "defspace" Id ("\<" Id)? "end";

// El original tenía AttributeList, el monitor lo marcó mal poruqe los operadores no deberiante tener atributos:
//syntax OperatorDecl = operatorDecl: "defoperator" Id ":" Type AttributeList? "end";
//el corregido queda:
syntax OperatorDecl = operatorDecl: "defoperator" Id ":" Type "end";

syntax VarDecl= varDecl: "defvar" Id ":" Type ("," Id ":" Type)* "end";

syntax RuleDecl= ruleDecl: "defrule" OperatorApplication Arrow OperatorApplication "end";

syntax ExpressionDecl = expressionDecl: "defexpression" Expression "end";

syntax AttrDecl = attrDecl: "[" {Attribute ","}+ "]";

syntax RelDecl = relDecl: "defer" Id ":" Type "end";

// Atributos
syntax Attribute = attr: Id (":" Id)?;

syntax Type = typeArrow: Id Arrow Type | typeBase:  Id;

// expresion
// Añadimos ecuación
syntax Expression = QuantifiedExpression | LogicalExpression | Equation;

syntax QuantifiedExpression = forallExpr: "forall" Id "in" Type "." Expression | existsExpr: "exists" Id "in" Type "." Expression;

syntax Equation = equation: Value "=" Value;

syntax LogicalExpression = logicExpr: Disjunction ("==" Disjunction)*;

syntax Disjunction = disjunct: Conjunction ("or" Conjunction)*;

syntax Conjunction = conjunct: UnaryExpression ("and" UnaryExpression)*;

syntax UnaryExpression = negExpr: "neg" UnaryExpression | primExpr: PrimaryExpression;

syntax PrimaryExpression = opApp:     OperatorApplication | varRef:    Id | parenExpr: "(" Expression ")";

// Criterio 3: OperatorApplication takes Value+, not Expression+
syntax OperatorApplication = opApp: "(" Id Value+ ")"
    ;

// Value: variables o literales como tal solas
syntax Value =valId: Id | valInt: IntLiteral | valFloat: FloatLiteral | valChar:  CharLiteral;
