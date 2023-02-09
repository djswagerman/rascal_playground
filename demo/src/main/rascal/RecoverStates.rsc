module RecoverStates

import IO;
import lang::cpp::AST;
import vis::Graphs;
import Content;


alias Edges = rel[str from, str trigger, str to];

Edges extractStateGraph(translationUnit(decls)) {
    Edges result = {};
    for (functionDefinition(_,_, _, body) <- decls, \switch(_, compoundStatement(switchStm)) <- body.statements) {
        // found mainSwitch, now iterating through the cases
        currentFrom = "";
        for (stm <- switchStm) {
            switch (stm) {
                case \case(idExpression(name(from))):
                    currentFrom = from;
                case \break():
                    currentFrom = "";
                case \switch(_, toBody):
                    result += extractToEdges(currentFrom, toBody);
            }
        }
    }
    return result;
}

Edges extractToEdges(str from, compoundStatement(cases)) {
    Edges result = {};
    currentTrigger = "";
    for (stm <- cases) {
        switch (stm) {
            case \case(idExpression(name(trigger))):
                currentTrigger = trigger;
            case \break():
                currentTrigger = "";
            case \return(idExpression(name(to))):
                result += <from, currentTrigger, to>;
        }
    }
    return result;
}


Edges getDemoGraph() {
    unitAST = parseCpp(|project://demo/src/examples/recover/example.cpp|);
    return extractStateGraph(unitAST);
}

Content renderGraph(Edges e) = graph(e);