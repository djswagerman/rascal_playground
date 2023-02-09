module lang::state::IDE

import IO;
import Message;
import util::Reflective;
import ParseTree;
import util::LanguageServer;
import lang::state::Syntax;
import lang::state::Compiler;

set[LanguageService] stateContrib() = {
    parser(parser(#start[Machine])),
    outliner(stateOutline),
    summarizer(stateSummary)
};

list[DocumentSymbol] stateOutline(start[Machine] input) 
    = [ symbol("<s.name>", class(), s@\loc) | s <- input.top.states];

Summary stateSummary(loc l, start[Machine] input) {
    defs = {<"<s.name>", s.name@\loc> | s <- input.top.states };
    uses = {<"<to>", to@\loc> | /(Trans)`<Id _> : <Id to>` := input.top}
        + {<"<to>", to@\loc> | /(Case)`case <Expression _> : <Id to>` := input.top}
    ;
    missing = {<u, error("<s> not defined", u)> | s <- (uses<0> - defs<0>), u <- uses[s]};
    if (missing == {}) {
        writeFile(input.top@\loc.top[extension="cpp"], compile(input.top));
    }

    return summary(l,
        definitions = (uses<1,0> o defs),
        references = (defs<1,0> o uses),
        messages = missing
    );
}

int main() {
    //unregisterLanguage("StateMachine", "state");
    registerLanguage(
        language(
            pathConfig(srcs=[|project://demo/src/main/rascal|]),
            "StateMachine", // name of the language
            "state", // extension
            "lang::state::IDE", // module to import
            "stateContrib"
        )
    );
    return 0;
}