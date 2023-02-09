
enum State {
    Init,
    Started,
    Paused,
    Printing,
    Failed
};

enum Event {
    ButtonOn,
    ButtonPause,
    ButtonStart,
    ButtonPrint,
    PrintingDone,
    ButtonReset
};


State machine(State current, Event trigger) {
    switch (current) {
        case Init:
            switch (trigger) {
                case ButtonOn: return Started;
            }
            break;
        case Started:
            switch (trigger) {
                case ButtonPause: return Paused;
                case ButtonPrint: return Printing;
            }
            break;
        case Paused:
            switch (trigger) {
                case ButtonStart: return Started;
            }
            break;

        case Printing:
            switch (trigger) {
                case PrintingDone: return Started;
                case ButtonReset: return Paused;
            }
            break;

        case Failed:
            switch (trigger) {
                case ButtonReset: return Init;
            }
            break;
    }
    return current;
}