

public class Session {
  private String pNum;
  private int startValue;
  private int staircaseOrder;
  private String staircaseOrderName;
  
  private int reveralCount;
  private int trialCount;
  
  private Table table;
  private String tableName;
 
  
  private Trial currentTrail;
  
  private int lastAnswerCorrect;
  
  public Session(String _pNum, int _startValue, int _staircaseOrder){
     this.pNum = _pNum;
     this.startValue = _startValue;
     this.staircaseOrder = _staircaseOrder;
     if (_staircaseOrder == 0){
       this.staircaseOrderName = "up";
     } else {
       this.staircaseOrderName = "down";
     }
    this.reveralCount = 0;
    this.trialCount = 0;
    
    this.currentTrail = new Trial(_startValue, true);
    
    table = new Table();
    tableName = String.valueOf(year())+String.valueOf(month())+String.valueOf((day()))+String.valueOf((hour()))+String.valueOf((minute()))+String.valueOf((second()))+"_"+ this.pNum + "_" + this.startValue + "_" + this.staircaseOrderName;
    System.out.println(tableName);
  }
  
  public void newAnswer(int answer){
     
     reversalCheck();
     
     
  }
  
  public void addToCSV(){
    TableRow newRow = table.addRow();
    newRow.setInt("id", table.getRowCount() - 1);
    Timestamp timestamp = new Timestamp(System.currentTimeMillis());
    
    newRow.setString("timestamp", String.valueOf(timestamp));
    newRow.setString("reference", String.valueOf(currentTrail.getRefPrototype().getServoValue()));
    newRow.setString("contol",    String.valueOf(currentTrail.getControlPrototype().getServoValue()));
    newRow.setString("reversal",  String.valueOf(currentTrail.isReversal()));
    newRow.setString("correct_answer", String.valueOf(currentTrail.getCorrectAnswer()));
    newRow.setString("user_answer",    String.valueOf(currentTrail.getCorrectAnswer()));
    
    saveTable(table, pNum+"/"+tableName+".csv");
    
    this.newTrial();
  }
  
  public void newTrial(){
    
    
    
    Random rand = new Random();
    int upperbound = 2;
    int int_random = rand.nextInt(upperbound);
    
    if (int_random == 0){
      currentTrail.getRefPrototype().setServoValue(this.startValue);
      if (this.staircaseOrder == 0) {
        if (currentTrail.getCorrectAnswer() == 1) {
          currentTrail.getControlPrototype().setServoValue(currentTrail.getControlPrototype().getServoValue()+20);
        } else {
          currentTrail.getControlPrototype().setServoValue(currentTrail.getControlPrototype().getServoValue()-20);
        }
      } else {
        if (currentTrail.getCorrectAnswer() == 1) {
          currentTrail.getControlPrototype().setServoValue(currentTrail.getControlPrototype().getServoValue()-20);
        } else {
          currentTrail.getControlPrototype().setServoValue(currentTrail.getControlPrototype().getServoValue()+20);
        }
      }
    } else {
      currentTrail.getControlPrototype().setServoValue(this.startValue);
      if (this.staircaseOrder == 0) {
        if (currentTrail.getCorrectAnswer() == 1) {
          currentTrail.getRefPrototype().setServoValue(currentTrail.getRefPrototype().getServoValue()+20);
        } else {
          currentTrail.getRefPrototype().setServoValue(currentTrail.getRefPrototype().getServoValue()-20);
        }
      } else {
        if (currentTrail.getCorrectAnswer() == 1) {
          currentTrail.getRefPrototype().setServoValue(currentTrail.getRefPrototype().getServoValue()-20);
        } else {
          currentTrail.getRefPrototype().setServoValue(currentTrail.getRefPrototype().getServoValue()+20);
        }
      }
    }
    
  }
  
  public void reversalCheck(){
    // if the last anwser was different to the past answer
    if (this.lastAnswerCorrect != currentTrail.getCorrectAnswer()){
      this.reveralCount++;
      currentTrail.setReversal(1);
    } else {
      currentTrail.setReversal(0);
    } 
  }
  
}
