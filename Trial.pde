public class Trial {

  private int correctAnswer;
  private int userAnswer;

  private int reversal;


  private Prototype refPrototype;
  private Prototype controlPrototype;


  public Trial(int startValue){
    this.correctAnswer = 0;
    this.userAnswer = 0;
    this.refPrototype = new Prototype(startValue, 0);
    this.controlPrototype = new Prototype(startValue+(100), 1);
  }


  public Trial(int lastValue, int _correctAnswer){
    this.correctAnswer = _correctAnswer;
    this.userAnswer = 0;
    if (_correctAnswer == 0) {
      this.refPrototype = new Prototype(lastValue, 1);
    } else {
      this.refPrototype = new Prototype(lastValue, 0);
    }
    this.controlPrototype = new Prototype(lastValue, _correctAnswer);
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

  public void setUserAnswer(int answer){
    this.userAnswer = answer;
  }


}
