module lang::state::Syntax

extend lang::std::Layout;
extend lang::std::Id;

start syntax Machine = machine: State+ states;

syntax State = state: "state" Id name Trans* out;

syntax Trans 
    = trans: Id event ":" Id to
    | logic: Id event ":" Switch decider
    ;


syntax Switch = "switch" "(" Expression select ")" Case+ cases;

syntax Case = "case" Expression c ":" Id to;

syntax Expression 
    = Integer i
    | Id reference
    > left Expression lhs "+" Expression rhs
    > left Expression lhs "*" Expression rhs
    ;

lexical Integer = [0-9]+ !>> [0-9];
