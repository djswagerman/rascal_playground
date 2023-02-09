enum Events {

   buttonPause, 
   buttonStart, 
   buttonOn, 
   buttonReset, 
   buttonPrint2, 
   printingDone, 
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
           case buttonPause: 
               return new State_Paused();
           case buttonPrint2: 
               return new State_Printing();
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
    

class State_Printing : public State {
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
    

    