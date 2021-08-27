public class Trial {
 
  private int correctAnswer;
  private int userAnswer;
  
  private int reversal;
  
  
  private Prototype refPrototype;
  private Prototype controlPrototype;
  
  
  public Trial(int startValue, boolean firstTrail){
    this.correctAnswer = 0;
    this.userAnswer = 0;
    this.controlPrototype = new Prototype(startValue+(100), true);
    this.controlPrototype = new Prototype(startValue, true);
  }
  
  
  public Trial(int lastValue){

    this.correctAnswer = 0;
    this.userAnswer = 0; 
    
    this.refPrototype = new Prototype(lastValue+(100), true);
    this.controlPrototype = new Prototype(lastValue, true);
  }
  
  public Prototype getRefPrototype(){
    return this.refPrototype;
  }
  
  public Prototype getControlPrototype(){
    return this.controlPrototype;
  }
  
  public int isReversal(){
    return this.reversal;
  }
  
  public void setReversal(int _reversal){
    this.reversal = _reversal;
  }
  
  public int getCorrectAnswer(){
    return this.correctAnswer;
  }
  public int getUserAnswer(){
    return this.userAnswer;
  }
  
  
}
