module lang::state::Compiler

import String;
import lang::state::Syntax;

str compile((Machine)`<State+ states>`) = 
    "enum Events {
    '<for (e <- { "<t.event>" | /Trans t := states}) {>
    '   <e>, <}>
    '};
    'class State { 
    'public:
    '    virtual State* handleState(Events ev) = 0;
    '};
    <for (s <- states) {>
        '<compile(s)>
    '<}>
    ";


str compile((State)`state <Id name> <Trans* out>`) = 
    "class State_<name> : public State {
    'public:
    '   State* handleState(Events ev) override {
    '       switch (ev) {<for (t <- out) {>
    '           case <t.event>: 
    '               <compile(t)>;<}>
    '           default: return this;
    '       }
    '   }
    '};
    ";

str compile((Trans)`<Id _> : <Id to>`) = "return new State_<to>()";

str compile((Trans)`<Id _> : switch ( <Expression select> ) <Case+ cases>`) = 
    "switch (<compile(select)>) { <for ((Case)`case <Expression c> : <Id to>` <- cases) {>
    '       case <compile(c)> : return new State_<to>(); <}>
    '   default: return this;
    '}";

str compile((Expression)`<Integer i>`) = "<i>";
str compile((Expression)`<Id reference>`) = "<reference>";
str compile((Expression)`<Integer lhs> + <Integer rhs>`) = "<toInt(lhs) + toInt(rhs)>";
str compile((Expression)`<Integer lhs> * <Integer rhs>`) = "<toInt(lhs) * toInt(rhs)>";
default str compile((Expression)`<Expression lhs> + <Expression rhs>`) = "<compile(lhs)> + <compile(rhs)>";
default str compile((Expression)`<Expression lhs> * <Expression rhs>`) = "<compile(lhs)> * <compile(rhs)>";

int toInt(Integer i) = toInt("<i>");