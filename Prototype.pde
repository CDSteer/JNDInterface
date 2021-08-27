

public class Prototype {
  private int servoValue;
  private boolean isControl;
  
  public Prototype(int _servoValue, boolean _isControl){
    this.servoValue = _servoValue;
    this.isControl = _isControl;
  }
  
  
  public void setServoValue(int _servoValue){
    this.servoValue = _servoValue;
  }
  
  public int getServoValue(){
    return this.servoValue;
  }
  
  
}
