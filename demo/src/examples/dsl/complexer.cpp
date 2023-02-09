enum Events {

   buttonStart, 
   buttonOn, 
   printingDone, 
   buttonPrint, 
   buttonReset, 
   buttonPauze, 
};
class State { 
public:
    virtual State* handleState(Events ev) = 0;
};
    
class State_Init : public State {
public:
   State* handleState(Events ev) override {
       switch (ev) {
           case buttonOn: 
               return new State_Started();
           default: return this;
       }
   }
};
    

class State_Started : public State {
public:
   State* handleState(Events ev) override {
       switch (ev) {
           case buttonPauze: 
               return new State_Paused();
           case buttonPrint: 
               switch (dpi) { 
                      case 100 : return new State_FastPrinting(); 
                      case 270 : return new State_NormalPrinting(); 
                      case 300 * basic : return new State_SlowPrinting(); 
                  default: return this;
               };
           default: return this;
       }
   }
};
    

class State_Paused : public State {
public:
   State* handleState(Events ev) override {
       switch (ev) {
           case buttonStart: 
               return new State_Started();
           default: return this;
       }
   }
};
    

class State_FastPrinting : public State {
public:
   State* handleState(Events ev) override {
       switch (ev) {
           case printingDone: 
               return new State_Started();
           default: return this;
       }
   }
};
    

class State_NormalPrinting : public State {
public:
   State* handleState(Events ev) override {
       switch (ev) {
           case printingDone: 
               return new State_Started();
           default: return this;
       }
   }
};
    

class State_SlowPrinting : public State {
public:
   State* handleState(Events ev) override {
       switch (ev) {
           case printingDone: 
               return new State_Started();
           default: return this;
       }
   }
};
    

class State_Failed : public State {
public:
   State* handleState(Events ev) override {
       switch (ev) {
           case buttonReset: 
               return new State_Init();
           default: return this;
       }
   }
};
    

    