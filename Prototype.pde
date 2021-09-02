public class Prototype {
  private int servoValue;
  private int order;

  public Prototype(int _servoValue, int _order){
    this.servoValue = _servoValue;
    this.order = _order;
  }

  public void setServoValue(int _servoValue){
    this.servoValue = _servoValue;
  }
  public int getServoValue(){
    return this.servoValue;
  }
  public void setOrder(int _order){
    this.order = _order;
  }
  public int getOrder(){
    return this.order;
  }
}
