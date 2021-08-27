public class Prototype {
  private int servoValue;
  private int isControl;

  public Prototype(int _servoValue, int _isControl){
    this.servoValue = _servoValue;
    this.isControl = _isControl;
  }

  public void setServoValue(int _servoValue){
    this.servoValue = _servoValue;
  }
  public int getServoValue(){
    return this.servoValue;
  }
  public void setIsControl(int _isControl){
    this.isControl = _isControl;
  }
  public int getIsControl(){
    return this.isControl;
  }
}
