public class Trial {
  private int correctAnswer;
  private int userAnswer;
  private int reversal;

  private Prototype refPrototype;
  private Prototype controlPrototype;

  public Trial(int startValue, int _staircaseOrder, boolean isFirst){
    this.correctAnswer = 0;
    this.userAnswer = 0;
    this.refPrototype = new Prototype(startValue, 0);
    if (_staircaseOrder == 0){
      this.controlPrototype = new Prototype(startValue-(100), 1);
    } else {
      this.controlPrototype = new Prototype(startValue+(100), 1);
    }
  }

  public Trial(int lastValue, int _order){
    this.userAnswer = 0;
    if (_order == 0) {
      this.refPrototype = new Prototype(lastValue, 1);
    } else {
      this.refPrototype = new Prototype(lastValue, 0);
    }
    this.controlPrototype = new Prototype(lastValue, _order);
  }

  private void setCorrectAnswer(int staircaseOrder){
    if (staircaseOrder == 0){
      if (this.controlPrototype.getServoValue() < this.refPrototype.getServoValue()){
        this.correctAnswer = this.controlPrototype.getOrder();
      } else {
        this.correctAnswer = this.refPrototype.getOrder();
      }
    } else {
      if (this.controlPrototype.getServoValue() > this.refPrototype.getServoValue()){
        this.correctAnswer = this.controlPrototype.getOrder();
      } else {
        this.correctAnswer = this.refPrototype.getOrder();
      }
    }
    System.out.println("Correct Answer: "+this.correctAnswer);
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
  public int getReversal(){
    return this.reversal;
  }
  public int getCorrectAnswer(){
    return this.correctAnswer;
  }
  public int getUserAnswer(){
    return this.userAnswer;
  }
  public void setUserAnswer(int answer){
    this.userAnswer = answer;
  }
}
