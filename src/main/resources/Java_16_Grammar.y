
//// Tokens ////////////////////////

%token LPAREN       //  (
%token RPAREN       //  )
%token LBRACE       //  {
%token RBRACE       //  }
%token LBRACKET     //  [
%token RBRACKET     //  ]
%token COMMA        //  ,
%token DOT          //  .
%token SEMICOLON    //  ;
%token COLON        //  :
%token DBL_COLON    //  ::
%token STAR         //  *
%token SLASH        //  /
%token PERCENT      //  %
%token AMPERSAND    //  &
%token AT           //  @
%token LESS         //  <
%token GREATER      //  >
%token VERTICAL     //  |
%token PLUS         //  +
%token MINUS        //  -
%token ARROW        //  ->
%token DIAMOND      //  <>
%token QUESTION     //  ?
%token CARET        //  ^
%token EQUAL        //  =
%token TILDE        //  ~
%token EXCLAMATION  //  !

%token ELLIPSIS     //  ...

%token LESS_EQUAL          //  <=
%token GREATER_EQUAL       //  >=
%token STAR_EQUAL          //  *=
%token SLASH_EQUAL         //  /=
%token PERCENT_EQUAL       //  %=
%token PLUS_EQUAL          //  +=
%token MINUS_EQUAL         //  -=
%token LESS_LESS_EQUAL     //  <<=
%token GR_GR_EQUAL         //  >>=
%token GR_GR_GR_EQUAL      //  >>>=
%token AMP_EQUAL           //  &=
%token CARET_EQUAL         //  ^=
%token VERTICAL_EQUAL      //  |=

%token DBL_PLUS            //  ++
%token DBL_MINUS           //  --
%token DBL_VERTICAL        //  ||
%token DBL_AMPERSAND       //  &&
%token DBL_EQUAL           //  ==
%token NON_EQUAL           //  !=
%token DBL_LESS            //  <<
%token DBL_GREATER         //  >>
%token TRIPL_GREATER       //  >>>

%token IDENTIFIER
%token INTEGER_LITERAL
%token FLOATING_POINT_LITERAL
%token CHARACTER_LITERAL
%token STRING_LITERAL

%token ABSTRACT
%token ASSERT
%token BOOLEAN
%token BREAK
%token BYTE
%token CASE
%token CATCH
%token CHAR
%token CLASS
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTENDS
%token FALSE
%token FINAL
%token FINALLY
%token FLOAT
%token FOR
%token IF
%token IMPLEMENTS
%token IMPORT
%token INSTANCEOF
%token INT
%token INTERFACE
%token LONG
%token MODULE
%token NEW
%token NULL
%token OPEN
%token PACKAGE
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token RECORD
%token RETURN
%token SHORT
%token STATIC
%token STRICTFP
%token SUPER
%token SWITCH
%token SYNCHRONIZED
%token THIS
%token THROW
%token THROWS
%token TRANSIENT
%token TRANSITIVE
%token TRUE
%token TRY
%token VAR
%token VOID
%token VOLATILE
%token WHILE
%token YIELD

%start CompilationUnit


%language "Java"
%define api.parser.class {JavaParser}
%define api.parser.public
%define package {parser}

%%

//// Literals ////////////////////////////////////////////////

Literal
    : INTEGER_LITERAL
    | FLOATING_POINT_LITERAL
    | TRUE                      // BOOLEAN_LITERAL
    | FALSE                     // BOOLEAN_LITERAL
    | CHARACTER_LITERAL
    | STRING_LITERAL
//  | TextBlock   // ???
    | NULL   // NullLiteral
    ;

//// Basic Constructs ////////////////////////////////////////

CompoundName
    :                  IDENTIFIER
    | CompoundName DOT IDENTIFIER
    ;

ModifierSeqOpt
    :  // empty
    | ModifierSeq
    ;

ModifierSeq
    :               StandardModifierSeq
    | AnnotationSeq StandardModifierSeq
    ;

StandardModifierSeq
    :                     StandardModifier
    | StandardModifierSeq StandardModifier
    ;

StandardModifier
//  : Annotation
	: DEFAULT
    | FINAL
    | PUBLIC
    | PROTECTED
    | PRIVATE
    | ABSTRACT
    | STATIC
    | STRICTFP
    | SYNCHRONIZED
    | TRANSIENT
    | VOLATILE
    | OPEN  // for modules only
    ;

//// Compilation units, Packages and Modules ////////////////////

CompilationUnit
    :  // empty
    | Package
    | Module
    | ImportDeclarationSeqOpt TopLevelComponentSeq
    ;

Package
    : PACKAGE CompoundName SEMICOLON ImportDeclarationSeqOpt TopLevelComponentSeqOpt
    ;

Module
    : ModifierSeqOpt MODULE CompoundName LBRACE ModuleDirectiveSeqOpt RBRACE
    ;

ImportDeclarationSeqOpt
    :  // empty
    |                         ImportDeclaration
    | ImportDeclarationSeqOpt ImportDeclaration
    ;

ImportDeclaration
    : IMPORT StaticOpt CompoundName          SEMICOLON
    | IMPORT StaticOpt CompoundName DOT STAR SEMICOLON
    ;

StaticOpt
    : // empty
    | STATIC
    ;

TopLevelComponentSeqOpt
    :  // empty
    | TopLevelComponentSeq
    ;

TopLevelComponentSeq
    :                      ModifierSeqOpt TopLevelComponent
    | TopLevelComponentSeq ModifierSeqOpt TopLevelComponent
    ;

TopLevelComponent
    : ClassDeclaration
    | InterfaceDeclaration
    ;

ModuleDirectiveSeqOpt
    : ModuleDirectiveSeq
    ;

ModuleDirectiveSeq
    :                    ModuleDirective
    | ModuleDirectiveSeq ModuleDirective
    ;

ModuleDirective
    : "requires" RequiresModifierSeqOpt CompoundName SEMICOLON
	| "exports"  CompoundName                        SEMICOLON
	| "exports"  CompoundName "to" ModuleNameList    SEMICOLON
	| "opens"    CompoundName                        SEMICOLON
	| "opens"    CompoundName "to" ModuleNameList    SEMICOLON
    | "uses"     CompoundName                        SEMICOLON
	| "provides" CompoundName "with" ModuleNameList  SEMICOLON
    ;

ModuleNameList
    :                      CompoundName
    | ModuleNameList COMMA CompoundName
    ;

RequiresModifierSeqOpt
    :  // empty
    | TRANSITIVE
    | TRANSITIVE STATIC
	| STATIC
	| STATIC TRANSITIVE
    ;

//// Types //////////////////////////

// Type
//    : PrimitiveType
//    | ReferenceType
//    ;

Type
    :               UnannotatedType
    | AnnotationSeq UnannotatedType
    ;

UnannotatedType
    : PrimitiveType
	  // ReferenceType
    | CompoundName
    | CompoundName TypeArguments
	  // ArrayType
	| UnannotatedType Dim
    ;

//PrimitiveType
//  : AnnotationSeqOpt UnannPrimitiveType
//  ;

PrimitiveType
      // NumericType -- IntegralType
    : BYTE
    | SHORT
    | INT
    | LONG
    | CHAR
	  // NumericType -- FloatingPointType
    | FLOAT
    | DOUBLE
    | BOOLEAN
    ;

//ReferenceType
// : ClassType  // class or interface type
// | AnnotationSeqOpt IDENTIFIER // TypeVariable
// | ArrayType
// ;

//ClassType
//  :  CompoundName
//  |  CompoundName TypeArguments
//  ;

//ArrayType
//  : Type Dims
//  ;

//// Classes ////////////////////////

ClassDeclaration
    : NormalClassDeclaration
    | EnumDeclaration
    | RecordDeclaration
    ;

NormalClassDeclaration
    : /*ModifierSeqOpt*/ CLASS IDENTIFIER TypeParametersOpt ClassExtendsOpt ClassImplementsOpt ClassBody
    ;

TypeParametersOpt
    :  // empty
    | TypeParameters
    ;

TypeParameters
    : LESS TypeParameterList GREATER
    ;

TypeParameterList
    :                         TypeParameter
    | TypeParameterList COMMA TypeParameter
    ;

//TypeParameter
//    : AnnotationSeqOpt IDENTIFIER
//    | AnnotationSeqOpt IDENTIFIER EXTENDS AnnotationSeqOpt IDENTIFIER
//    | AnnotationSeqOpt IDENTIFIER EXTENDS ClassTypeList2
//    ;

TypeParameter
    : AnnotationSeq TypeParameterTail
    |               TypeParameterTail
    ;

TypeParameterTail
    : IDENTIFIER
    | IDENTIFIER EXTENDS AnnotationSeqOpt IDENTIFIER
    | IDENTIFIER EXTENDS ClassTypeList2
    ;

ClassExtendsOpt
    : // empty
    | EXTENDS Type
    ;

ClassImplementsOpt
    : // empty
    | IMPLEMENTS ClassTypeList1
    ;

ClassTypeList1
    :                      Type
    | ClassTypeList1 COMMA Type
    ;

ClassTypeList2
    :                          Type
    | ClassTypeList2 AMPERSAND Type
    ;

ClassBodyOpt
    :  // empty
    | ClassBody
    ;

ClassBody
    : LBRACE                         RBRACE
	| LBRACE ClassBodyDeclarationSeq RBRACE
    ;

ClassBodyDeclarationSeq
    :                         ClassBodyDeclaration
    | ClassBodyDeclarationSeq ClassBodyDeclaration
    ;

ClassBodyDeclaration
    : ModifierSeqOpt PureBodyDeclaration
    |         Block          // InstanceInitializer
    | STATIC Block           // StaticInitializer
    | SEMICOLON
 	;

PureBodyDeclaration
    : FieldDeclaration         // ClassMemberDeclaration
    | MethodDeclaration        // ClassMemberDeclaration
    | ClassDeclaration         // ClassMemberDeclaration
    | InterfaceDeclaration     // ClassMemberDeclaration
    | ConstructorDeclaration
    ;

//// Constructors ///////////////////////////////////////

ConstructorDeclaration
    : /*ModifierSeqOpt*/ ConstructorDeclarator ThrowsOpt ConstructorBody
    ;

ConstructorDeclarator
    : TypeParametersOpt IDENTIFIER LPAREN FormalParameterList/*FormalParameters*/ RPAREN
    ;

ConstructorBody
    : LBRACE                                                 RBRACE
    | LBRACE ExplicitConstructorInvocation                   RBRACE
    | LBRACE                               BlockStatementSeq RBRACE
    | LBRACE ExplicitConstructorInvocation BlockStatementSeq RBRACE
    ;

ExplicitConstructorInvocation
    :                  TypeArgumentsOpt THIS  Arguments SEMICOLON
    |                  TypeArgumentsOpt SUPER Arguments SEMICOLON
	| CompoundName DOT TypeArgumentsOpt SUPER Arguments SEMICOLON
    | Primary      DOT TypeArgumentsOpt SUPER Arguments SEMICOLON
    ;

//// EnumDeclaration ////////////////////////////////////

EnumDeclaration
    : /*ModifierSeqOpt*/ ENUM IDENTIFIER ClassImplementsOpt EnumBody
    ;

EnumBody
    : LBRACE EnumConstantListOpt       EnumBodyDeclarationsOpt RBRACE
    | LBRACE EnumConstantListOpt COMMA EnumBodyDeclarationsOpt RBRACE
    ;

EnumConstantListOpt
    :  // empty
    |                           EnumConstant
    | EnumConstantListOpt COMMA EnumConstant
    ;

EnumConstant
    : AnnotationSeqOpt IDENTIFIER Arguments
    | AnnotationSeqOpt IDENTIFIER Arguments ClassBody
    ;

EnumBodyDeclarationsOpt
    :  // empty
    | SEMICOLON
    | SEMICOLON ClassBodyDeclarationSeq
    ;

//// RecordDeclaration //////////////////////////////////

RecordDeclaration
    : /*ModifierSeqOpt*/ RECORD IDENTIFIER TypeParametersOpt RecordHeader ClassImplementsOpt RecordBody
    ;

RecordHeader
    : LPAREN RecordComponentListOpt RPAREN
    ;

RecordComponentListOpt
    :  // empty
    |                              RecordComponent
    | RecordComponentListOpt COMMA RecordComponent
    ;

RecordComponent
    : AnnotationSeqOpt UnannotatedType IDENTIFIER
    | AnnotationSeqOpt UnannotatedType AnnotationSeqOpt ELLIPSIS IDENTIFIER // VariableArityRecordComponent
    ;

RecordBody
    : LBRACE                          RBRACE
    | LBRACE RecordBodyDeclarationSeq RBRACE
    ;

RecordBodyDeclarationSeq
    :                          RecordBodyDeclaration
    | RecordBodyDeclarationSeq RecordBodyDeclaration
    ;

RecordBodyDeclaration
    : ClassBodyDeclaration
    | ModifierSeqOpt IDENTIFIER ConstructorBody // CompactConstructorDeclaration
    ;

//// FieldDeclaration ///////////////////////////////////

FieldDeclaration
    : /*ModifierSeqOpt*/ UnannotatedType VariableDeclaratorList SEMICOLON
    ;

VariableDeclaratorList
    :                              VariableDeclarator
    | VariableDeclaratorList COMMA VariableDeclarator
    ;

VariableDeclarator
    : IDENTIFIER
    | IDENTIFIER      EQUAL Expression
    | IDENTIFIER Dims
    | IDENTIFIER Dims EQUAL ArrayInitializer
    ;

ArrayInitializer
    : LBRACE VariableInitializerListOpt       RBRACE
    | LBRACE VariableInitializerListOpt COMMA RBRACE
    ;

VariableInitializerListOpt
    :  // empty
    | VariableInitializerList
    ;

VariableInitializerList
    :                               VariableInitializer
    | VariableInitializerList COMMA VariableInitializer
    ;

VariableInitializer
    : Expression
    | ArrayInitializer
    ;

//// MethodDeclaration ////////////////////////////////

MethodDeclaration
    : MethodHeader MethodBody
	;

//MethodHeader
//    : TypeParameters AnnotationSeq Result MethodDeclarator ThrowsOpt
//    | TypeParameters               Result MethodDeclarator ThrowsOpt
//    |                              Result MethodDeclarator ThrowsOpt
//    ;

MethodHeader
    : TypeParameters               Type            MethodDeclarator ThrowsOpt
    | TypeParameters AnnotationSeq VOID            MethodDeclarator ThrowsOpt
    | TypeParameters               UnannotatedType MethodDeclarator ThrowsOpt
    | TypeParameters               VOID            MethodDeclarator ThrowsOpt
    |                              UnannotatedType MethodDeclarator ThrowsOpt
    |                              VOID            MethodDeclarator ThrowsOpt
    ;

//Result
//    : UnannotatedType
//    | VOID
//    ;

MethodDeclarator
    : IDENTIFIER LPAREN                                          RPAREN DimsOpt
    | IDENTIFIER LPAREN FormalParameterList /*FormalParameters*/ RPAREN DimsOpt
    ;

//FormalParameters
//    : ReceiverParameter COMMA FormalParameterList
//    |                         FormalParameterList
//    ;
//
//ReceiverParameter
//    : AnnotationSeqOpt UnannotatedType                THIS
//    | AnnotationSeqOpt UnannotatedType IDENTIFIER DOT THIS
//    ;

FormalParameterList
    :                           FormalParameter
    | FormalParameterList COMMA FormalParameter
    ;

FormalParameter
    : ModifierSeq UnannotatedType FormalParameterTail
    |             UnannotatedType FormalParameterTail
    ;

FormalParameterTail
    :                           IDENTIFIER DimsOpt
    | AnnotationSeqOpt ELLIPSIS IDENTIFIER
    |                  THIS
    | IDENTIFIER DOT   THIS
    ;

//FormalParameter
//    : ModifierSeqOpt UnannotatedType                              IDENTIFIER DimsOpt
//    | ModifierSeqOpt UnannotatedType AnnotationSeqOpt ELLIPSIS IDENTIFIER // VariableArityParameter
//
//    | AnnotationSeqOpt UnannotatedType                THIS
//    | AnnotationSeqOpt UnannotatedType IDENTIFIER DOT THIS
//    ;

ThrowsOpt
    :  // empty
    | THROWS ClassTypeList1
    ;

MethodBody
    : Block
    | SEMICOLON
    ;

////             //////////////////////////////////

DimsOpt
    : // empty
    | Dims
    ;

Dims
    :      Dim
    | Dims Dim
    ;

Dim
    : AnnotationSeq LBRACKET RBRACKET
    |               LBRACKET RBRACKET
    ;

//// InterfaceDeclaration ////////////////////////

InterfaceDeclaration
    : NormalInterfaceDeclaration
    | AnnotationInterfaceDeclaration
    ;

NormalInterfaceDeclaration
    : INTERFACE IDENTIFIER TypeParametersOpt InterfaceExtendsOpt InterfaceBody
    ;

InterfaceExtendsOpt
    :  // empty
    | InterfaceExtends
    ;

InterfaceExtends
    : EXTENDS Type
    | InterfaceExtends COMMA Type
    ;

InterfaceBody
    : LBRACE                               RBRACE
    | LBRACE InterfaceMemberDeclarationSeq RBRACE
    ;

InterfaceMemberDeclarationSeq
    :                               ModifierSeqOpt InterfaceMemberDeclaration
    | InterfaceMemberDeclarationSeq ModifierSeqOpt InterfaceMemberDeclaration
    ;

InterfaceMemberDeclaration
    : ConstantDeclaration
    | InterfaceMethodDeclaration
    | ClassDeclaration
    | InterfaceDeclaration
    ;

ConstantDeclaration
    : Type VariableDeclaratorList SEMICOLON
    ;

InterfaceMethodDeclaration
    : MethodHeader MethodBody
    ;

AnnotationInterfaceDeclaration
    : AT INTERFACE IDENTIFIER AnnotationInterfaceBody
    ;

AnnotationInterfaceBody
    : LBRACE                                         RBRACE
    | LBRACE AnnotationInterfaceMemberDeclarationSeq RBRACE
    ;

AnnotationInterfaceMemberDeclarationSeq
    :                                         ModifierSeqOpt AnnotationInterfaceMemberDeclaration
    | AnnotationInterfaceMemberDeclarationSeq ModifierSeqOpt AnnotationInterfaceMemberDeclaration
    ;

AnnotationInterfaceMemberDeclaration
    : AnnotationInterfaceElementDeclaration
    | ConstantDeclaration
    | ClassDeclaration
    | InterfaceDeclaration
    ;

AnnotationInterfaceElementDeclaration
    : UnannotatedType IDENTIFIER LPAREN RPAREN DimsOpt DefaultValueOpt SEMICOLON
    ;

DefaultValueOpt
    :  // empty
    | DEFAULT ElementValue
    ;

//// Blocks & Statements /////////////////////////////////////

Block
    : LBRACE                   RBRACE
    | LBRACE BlockStatementSeq RBRACE
    ;

BlockStatementSeq
	:                   BlockStatement
    | BlockStatementSeq BlockStatement
    ;

BlockStatement
    : ModifierSeqOpt BlockDeclaration
    | Statement
    ;

BlockDeclaration
    : ClassDeclaration                   // LocalClassOrInterfaceDeclaration
    | NormalInterfaceDeclaration         // LocalClassOrInterfaceDeclaration
    | LocalVariableDeclaration SEMICOLON // LocalVariableDeclarationStatement
    ;

LocalVariableDeclaration
    : UnannotatedType VariableDeclaratorList
    | VAR             VariableDeclaratorList
    ;

Statement
    : SimpleStatement
    | LabeledStatement
    | IfThenElseStatement
    | WhileStatement
    | ForStatement
    ;

SimpleStatement
    : Block
	| SEMICOLON                                      // EmptyStatement
    | StatementExpression SEMICOLON                  // ExpressionStatement

    | ASSERT Expression                  SEMICOLON // AssertStatement
    | ASSERT Expression COLON Expression SEMICOLON // AssertStatement

    | SWITCH LPAREN Expression RPAREN SwitchBlock  // SwitchStatement
    | DO Statement WHILE LPAREN Expression RPAREN SEMICOLON // DoStatement

    | BREAK            SEMICOLON             // BreakStatement
    | BREAK IDENTIFIER SEMICOLON             // BreakStatement

    | CONTINUE             SEMICOLON         // ContinueStatement
    | CONTINUE IDENTIFIER  SEMICOLON         // ContinueStatement

    | RETURN            SEMICOLON            // ReturnStatement
    | RETURN Expression SEMICOLON            // ReturnStatement

    | SYNCHRONIZED LPAREN Expression RPAREN Block  // SynchronizedStatement

    | THROW Expression SEMICOLON      // ThrowStatement
    | YIELD Expression SEMICOLON      // YieldStatement

      // TryStatement
    | TRY Block Catches
    | TRY Block Catches Finally
    | TRY Block         Finally
    | TRY ResourceSpecification Block CatchesOpt FinallyOpt // TryWithResourcesStatement
    ;

LabeledStatement
    : IDENTIFIER COLON Statement
    ;

StatementExpression
    : Assignment
    | PreIncrementExpression
    | PreDecrementExpression
    | PostIncrementExpression
    | PostDecrementExpression
    | MethodInvocation
    | ClassInstanceCreationExpression
    ;

IfThenElseStatement
    : IF LPAREN Expression RPAREN Statement ElsePartOpt
    ;

ElsePartOpt
    :  // empty
    | ELSE Statement
    ;

SwitchBlock
    : LBRACE SwitchRuleSeq                                  RBRACE
    | LBRACE SwitchBlockStatementGroupSeqOpt                RBRACE
    | LBRACE SwitchBlockStatementGroupSeqOpt SwitchLabelSeq RBRACE
    ;

SwitchRuleSeq
    :               SwitchRule
    | SwitchRuleSeq SwitchRule
    ;

SwitchRule
    : SwitchLabel ARROW Expression SEMICOLON
    | SwitchLabel ARROW Block
    | SwitchLabel ARROW THROW Expression SEMICOLON // ThrowStatement
    ;

SwitchBlockStatementGroupSeqOpt
    :  // empty
    |                                 SwitchBlockStatementGroup
    | SwitchBlockStatementGroupSeqOpt SwitchBlockStatementGroup
    ;

SwitchBlockStatementGroup
    : SwitchLabelSeq
    | SwitchLabelSeq BlockStatementSeq
    ;

SwitchLabelSeq
    :                SwitchLabel COLON
    | SwitchLabelSeq SwitchLabel COLON
    ;

SwitchLabel
    : CASE CaseExpressionList
	| DEFAULT
    ;

CaseExpressionList
    :                          AssignmentExpression
    | CaseExpressionList COMMA AssignmentExpression
    ;

//CaseConstant
//    : Expression // ConditionalExpression

WhileStatement
    : WHILE LPAREN Expression RPAREN Statement
    ;

ForStatement
    : BasicForStatement
    | EnhancedForStatement
    ;

BasicForStatement
    : FOR LPAREN ForInitOpt SEMICOLON ExpressionOpt SEMICOLON StatementExpressionListOpt RPAREN Statement
    ;

ForInitOpt
    :  // empty
    | StatementExpressionList
    | LocalVariableDeclaration
    ;

ExpressionOpt
    :  // empty
    | Expression
    ;

// ForUpdate
//    : StatementExpressionList

StatementExpressionList
    :                               StatementExpression
    | StatementExpressionList COMMA StatementExpression
    ;

StatementExpressionListOpt
    :  // empty
    | StatementExpressionList
    ;

EnhancedForStatement
    : FOR LPAREN LocalVariableDeclaration COLON Expression RPAREN Statement
    ;

CatchesOpt
    :  // empty
    | Catches
    ;

Catches
    :         CatchClause
    | Catches CatchClause
    ;

CatchClause
    : CATCH LPAREN CatchFormalParameter RPAREN Block
    ;

CatchFormalParameter
    : ModifierSeqOpt CatchType IDENTIFIER DimsOpt
    ;

CatchType
    :                    Type
    | CatchType VERTICAL Type
    ;

FinallyOpt
    :  // empty
    | Finally
    ;

Finally
    : FINALLY Block
    ;

ResourceSpecification
    : LPAREN ResourceSeq           RPAREN
    | LPAREN ResourceSeq SEMICOLON RPAREN
    ;

ResourceSeq
    :                       Resource
    | ResourceSeq SEMICOLON Resource
    ;

Resource
    : LocalVariableDeclaration
    | FieldAccess  // VariableAccess? - doesn't exist in the grammar?
    ;

Pattern:
	LocalVariableDeclaration	// TypePattern

//// Primaries /////////////////////////////////

// Primary:
//    PrimaryNoNewArray
//    ArrayCreationExpression

Primary
    : Literal
    | Type DimsOpt DOT CLASS // ClassLiteral
    | VOID DimsOpt DOT CLASS // ClassLiteral
    | THIS
    | Type DOT THIS
    | LPAREN Expression RPAREN
    | ClassInstanceCreationExpression
    | FieldAccess
    | ArrayAccess
    | MethodInvocation
    | MethodReference
    | ArrayCreationExpression
    ;

//ClassLiteral:
//	TypeName	 { [ ] }	. class
//	NumericType { [ ] }	. class
//	boolean	 { [ ] }	. class
//	void			. class

ClassInstanceCreationExpression
    :                  UnqualifiedClassInstanceCreationExpression
    | CompoundName DOT UnqualifiedClassInstanceCreationExpression
    | Primary      DOT UnqualifiedClassInstanceCreationExpression
    ;

UnqualifiedClassInstanceCreationExpression
    : NEW TypeArgumentsOpt ClassOrInterfaceTypeToInstantiate Arguments ClassBodyOpt
    ;

ClassOrInterfaceTypeToInstantiate
    : AnnotatedCompoundName TypeArgumentsOpt
    | AnnotatedCompoundName DIAMOND
    ;

AnnotatedCompoundName
    :                           AnnotationSeqOpt /*AnnotationOpt*/ IDENTIFIER
    | AnnotatedCompoundName DOT AnnotationSeqOpt /*AnnotationOpt*/ IDENTIFIER
    ;

TypeArgumentsOpt
    :  // empty
    | TypeArguments
    ;

TypeArguments
    : LESS TypeArgumentList GREATER
    ;

TypeArgumentList
    :                        TypeArgument
    | TypeArgumentList COMMA TypeArgument
    ;

TypeArgument
    : Type
    |               QUESTION WildcardBoundsOpt
    | AnnotationSeq QUESTION WildcardBoundsOpt
    ;

WildcardBoundsOpt
    :  // empty
    | EXTENDS Type
    | SUPER   Type
    ;

FieldAccess
    : Primary                DOT IDENTIFIER
    |                  SUPER DOT IDENTIFIER
    | CompoundName DOT SUPER DOT IDENTIFIER
    ;

ArrayAccess
    : CompoundName LBRACKET Expression RBRACKET
    | Primary      LBRACKET Expression RBRACKET
    ;

MethodInvocation
    :                                             IDENTIFIER Arguments
    | CompoundName           DOT TypeArgumentsOpt IDENTIFIER Arguments
    | Primary                DOT TypeArgumentsOpt IDENTIFIER Arguments
    |                  SUPER DOT TypeArgumentsOpt IDENTIFIER Arguments
    | CompoundName DOT SUPER DOT TypeArgumentsOpt IDENTIFIER Arguments
    ;

Arguments
    : LPAREN              RPAREN
    | LPAREN ArgumentList RPAREN
    ;

//ArgumentListOpt
//    :  // empty
//    | ArgumentList
//    ;

ArgumentList
    :                    Expression
    | ArgumentList COMMA Expression
    ;

MethodReference
    : CompoundName      DBL_COLON TypeArgumentsOpt IDENTIFIER
    | Primary           DBL_COLON TypeArgumentsOpt IDENTIFIER
    | Type              DBL_COLON TypeArgumentsOpt IDENTIFIER
    |             SUPER DBL_COLON TypeArgumentsOpt IDENTIFIER
    | Type    DOT SUPER DBL_COLON TypeArgumentsOpt IDENTIFIER
    | Type              DBL_COLON TypeArgumentsOpt NEW
    ;

ArrayCreationExpression
    : NEW Type DimExprs DimsOpt
    | NEW Type Dims ArrayInitializer
    ;

DimExprs
    :          DimExpr
    | DimExprs DimExpr
    ;

DimExpr
    :               LBRACKET Expression RBRACKET
    | AnnotationSeq LBRACKET Expression RBRACKET
    ;

//// Expressions //////////////////////////////////////////////////

Expression
    : LambdaExpression
    | AssignmentExpression
    ;

LambdaExpression
    : IDENTIFIER       ARROW LambdaBody
    | LambdaParameters ARROW LambdaBody
    ;

LambdaParameters
    : LPAREN                      RPAREN
    | LPAREN LambdaParameterList1 RPAREN
    | LPAREN LambdaParameterList2 RPAREN
//  | IDENTIFIER
    ;

LambdaParameterList1
    :                            IDENTIFIER
    | LambdaParameterList1 COMMA IDENTIFIER
    ;

LambdaParameterList2
    :                            LambdaParameter
    | LambdaParameterList2 COMMA LambdaParameter
    ;

//LambdaParameter
//    :                                    IDENTIFIER
//    | ModifierSeqOpt LambdaParameterType IDENTIFIER DimsOpt
//    | ModifierSeqOpt UnannotatedType AnnotationSeqOpt ELLIPSIS IDENTIFIER  // VariableArityParameter
//    ;

LambdaParameter
//  :                                IDENTIFIER
    : ModifierSeqOpt UnannotatedType IDENTIFIER DimsOpt
    | ModifierSeqOpt VAR             IDENTIFIER DimsOpt
    | ModifierSeqOpt UnannotatedType AnnotationSeqOpt ELLIPSIS IDENTIFIER  // VariableArityParameter
    ;

//LambdaParameterType
//    : UnannotatedType
//    | VAR
    ;

LambdaBody
    : Expression
    | Block
    ;

AssignmentExpression
    : ConditionalExpression
    | Assignment
    ;

Assignment
    : LeftHandSide AssignmentOperator Expression
    ;

LeftHandSide
    : CompoundName
    | FieldAccess
    | ArrayAccess
    ;

AssignmentOperator
    : EQUAL             //  =
    | STAR_EQUAL        //  *=
    | SLASH_EQUAL       //  /=
    | PERCENT_EQUAL     //  %=
    | PLUS_EQUAL        //  +=
    | MINUS_EQUAL       //  -=
    | LESS_LESS_EQUAL   //  <<=
    | GR_GR_EQUAL       //  >>=
    | GR_GR_GR_EQUAL    //  >>>=
    | AMP_EQUAL         //  &=
    | CARET_EQUAL       //  ^=
    | VERTICAL_EQUAL    //  |=
    ;

ConditionalExpression
    : ConditionalOrExpression ConditionalOrTail
    ;

ConditionalOrTail
    :  // empty
    | QUESTION Expression COLON ConditionalExpression
    | QUESTION Expression COLON LambdaExpression
    ;

ConditionalOrExpression
    :                                      ConditionalAndExpression
    | ConditionalOrExpression DBL_VERTICAL ConditionalAndExpression
    ;

ConditionalAndExpression
    :                                        InclusiveOrExpression
    | ConditionalAndExpression DBL_AMPERSAND InclusiveOrExpression
    ;

InclusiveOrExpression
    :                                ExclusiveOrExpression
    | InclusiveOrExpression VERTICAL ExclusiveOrExpression
    ;

ExclusiveOrExpression
    :                             AndExpression
    | ExclusiveOrExpression CARET AndExpression
    ;

AndExpression
    :                         EqualityExpression
    | AndExpression AMPERSAND EqualityExpression
    ;

EqualityExpression
    :                              RelationalExpression
    | EqualityExpression DBL_EQUAL RelationalExpression
    | EqualityExpression NON_EQUAL RelationalExpression
    ;

RelationalExpression
    :                                    ShiftExpression
    | RelationalExpression LESS          ShiftExpression
    | RelationalExpression GREATER       ShiftExpression
    | RelationalExpression LESS_EQUAL    ShiftExpression
    | RelationalExpression GREATER_EQUAL ShiftExpression
    | InstanceofExpression
    ;

InstanceofExpression
    : RelationalExpression INSTANCEOF Type
    | RelationalExpression INSTANCEOF Pattern
    ;

ShiftExpression
    :                               AdditiveExpression
    | ShiftExpression DBL_LESS      AdditiveExpression
    | ShiftExpression DBL_GREATER   AdditiveExpression
    | ShiftExpression TRIPL_GREATER AdditiveExpression
    ;

AdditiveExpression
    :                          MultiplicativeExpression
    | AdditiveExpression PLUS  MultiplicativeExpression
    | AdditiveExpression MINUS MultiplicativeExpression
    ;

MultiplicativeExpression
    :                                  UnaryExpression
    | MultiplicativeExpression STAR    UnaryExpression
    | MultiplicativeExpression SLASH   UnaryExpression
    | MultiplicativeExpression PERCENT UnaryExpression
    ;

UnaryExpression
    : PreIncrementExpression
    | PreDecrementExpression
    | PLUS UnaryExpression
    | MINUS UnaryExpression
    | UnaryExpressionNotPlusMinus
    ;

PreIncrementExpression
    : DBL_PLUS UnaryExpression
    ;

PreDecrementExpression
    : DBL_MINUS UnaryExpression
    ;

UnaryExpressionNotPlusMinus
    : PostfixExpression
    | TILDE       UnaryExpression
    | EXCLAMATION UnaryExpression
    | CastExpression
    | SwitchExpression
    ;

PostfixExpression
    : Primary
    | CompoundName  // ExpressionName
    | PostIncrementExpression
    | PostDecrementExpression
    ;

PostIncrementExpression
    : PostfixExpression DBL_PLUS
    ;

PostDecrementExpression
    : PostfixExpression DBL_MINUS
    ;

CastExpression
    : TargetType UnaryExpression
    | TargetType LambdaExpression
    ;

TargetType
    : LPAREN TypeList RPAREN
    ;

TypeList
    :                    Type
    | TypeList AMPERSAND Type
    ;

SwitchExpression
    : SWITCH LPAREN Expression RPAREN SwitchBlock
    ;


//// Annotations /////////////////////////////////
/*
AnnotationOpt
    : // empty
    | Annotation
    ;
*/
AnnotationSeqOpt
    :  // empty
    | AnnotationSeq
    ;

AnnotationSeq
    :               Annotation
    | AnnotationSeq Annotation
    ;

Annotation
    : AT CompoundName AnnotationTailOpt
    ;

AnnotationTailOpt
    :  // empty
    | AT CompoundName LPAREN                   RPAREN
    | AT CompoundName LPAREN AnnoParameterList RPAREN
    | AT CompoundName LPAREN ElementValue      RPAREN
    ;

AnnoParameterList
    :                         IDENTIFIER EQUAL ElementValue
    | AnnoParameterList COMMA IDENTIFIER EQUAL ElementValue
    ;

ElementValue
    : ConditionalExpression
    | LBRACE ElementValueListOpt        RBRACE
    | LBRACE                      COMMA RBRACE
    | Annotation
    ;

ElementValueListOpt
    :  //empty
    |                           ElementValue
    | ElementValueListOpt COMMA ElementValue
    ;

%%