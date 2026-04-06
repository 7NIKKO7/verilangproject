module AST

data Module = \module(str name, ImportList importList, list[Declaration] declarations);

data ImportList = importList(list[str] modules);

data Declaration = spaceDecl(str name, list[str] parent) | operatorDecl(str name, Type \type) | varDecl(list[VarBinding] bindings) | ruleDecl(OperatorApplication lhs, OperatorApplication rhs) | expressionDecl(Expression expr)
    | attrDecl(list[Attribute] attributes) | relDecl(str name, Type \type);

data VarBinding = varBinding(str name, Type \type);

data Attribute = attr(str name, list[str] \type);

data Type = typeArrow(str from, Type to) | typeBase(str name);

data Expression = forallExpr(str var, Type domain, Expression body) | existsExpr(str var, Type domain, Expression body) | equation(Value lhs, Value rhs) | equivExpr(list[Disjunction] disjuncts) | disjunction(list[Conjunction] conjuncts)
    | conjunction(list[UnaryExpression] unaries) | negExpr(UnaryExpression inner) | opApp(OperatorApplication app) | varRef(str name) | parenExpr(Expression inner);

data Disjunction = disjunct(list[Conjunction] conjuncts);

data Conjunction = conjunct(list[UnaryExpression] unaries);

data UnaryExpression = negExpr(UnaryExpression inner) | primExpr(PrimaryExpression prim);

data PrimaryExpression = opAppPrim(OperatorApplication app) | varRefPrim(str name) | parenExprPrim(Expression inner);

data OperatorApplication = opApp(str operator, list[Value] args);

data Value = valId(str name) | valInt(int n) | valFloat(real r) | valChar(str c);
