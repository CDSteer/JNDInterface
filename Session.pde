import java.sql.Timestamp;
import java.util.Random;

public class Session {
  private static final int MAX_REVERSALS = 10;
  private static final int MAX_TRAILS = 40;
  private static final int NUM_PROTOTYPES = 2;
  private static final int STIMULI_INCRIMENT = 20;

  private Random rand = new Random();

  private String pNum;
  private int startValue;
  private int staircaseOrder;
  private String staircaseOrderName;

  private Table table;
  private String tableName;

  private int reveralCount;
  private int trialCount;

  private Trial currentTrail;

  private boolean updatePrototypes;

  private int lastAnswerCorrect;
  private int lastValue;

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
    this.currentTrail = new Trial(_startValue);
    this.updatePrototypes = true;

    table = new Table();
    tableName = String.valueOf(year())+String.valueOf(month())+String.valueOf((day()))+String.valueOf((hour()))+String.valueOf((minute()))+String.valueOf((second()))+"_"+ this.pNum + "_" + this.startValue + "_" + this.staircaseOrderName;
    System.out.println(tableName);
    table.addColumn("id");
    table.addColumn("timestamp");
    table.addColumn("reference_order");
    table.addColumn("reference_value");
    table.addColumn("contol_order");
    table.addColumn("contol_value");
    table.addColumn("reversal");
    table.addColumn("correct_answer");
    table.addColumn("user_answer");
  }

  public void newAnswer(int answer){
    this.updatePrototypes = true;
    this.currentTrail.setUserAnswer(answer);
    this.reversalCheck();
    this.addToCSV();
  }

  public void addToCSV(){
    TableRow newRow = table.addRow();
    newRow.setInt("id", table.getRowCount() - 1);
    Timestamp timestamp = new Timestamp(System.currentTimeMillis());

    newRow.setString("timestamp", String.valueOf(timestamp));
    newRow.setString("reference_order", String.valueOf(currentTrail.getRefPrototype().getIsControl()));
    newRow.setString("reference_value", String.valueOf(currentTrail.getRefPrototype().getServoValue()));
    newRow.setString("contol_order", String.valueOf(currentTrail.getControlPrototype().getIsControl()));
    newRow.setString("contol_value",    String.valueOf(currentTrail.getControlPrototype().getServoValue()));
    newRow.setString("reversal",  String.valueOf(currentTrail.isReversal()));
    newRow.setString("correct_answer", String.valueOf(currentTrail.getCorrectAnswer()));
    newRow.setString("user_answer",    String.valueOf(currentTrail.getUserAnswer()));
    saveTable(table, "data/"+pNum+"/"+tableName+".csv");

    if (this.trialCount >= MAX_TRAILS || this.reveralCount == MAX_REVERSALS){
      exit();
    } else {
      this.newTrial();
    }
  }

  public void newTrial(){
    //save infomation from last trail
    this.lastValue = currentTrail.getControlPrototype().getServoValue();
    this.lastAnswerCorrect = this.currentTrail.getUserAnswer();

    // set the order - TODO: seperate method?
    int int_random = rand.nextInt(NUM_PROTOTYPES);
    this.currentTrail = new Trial(this.startValue, int_random);

    if (int_random == 0){
      currentTrail.getRefPrototype().setIsControl(0);
      currentTrail.getControlPrototype().setIsControl(1);
    } else {
      currentTrail.getRefPrototype().setIsControl(1);
      currentTrail.getControlPrototype().setIsControl(0);
    }

    // set the values - TODO: seperate method?
    currentTrail.getRefPrototype().setServoValue(this.startValue);
    if (this.staircaseOrder == 0) {
      if (currentTrail.getCorrectAnswer() == 1) {
        currentTrail.getControlPrototype().setServoValue(this.lastValue+STIMULI_INCRIMENT);
      } else {
        currentTrail.getControlPrototype().setServoValue(this.lastValue-STIMULI_INCRIMENT);
      }
    } else {
      if (currentTrail.getCorrectAnswer() == 1) {
        currentTrail.getControlPrototype().setServoValue(this.lastValue-STIMULI_INCRIMENT);
      } else {
        currentTrail.getControlPrototype().setServoValue(this.lastValue+STIMULI_INCRIMENT);
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

  public void setUpdatePrototypes(boolean _update){
    this.updatePrototypes = _update;
  }
  public boolean getUpdatePrototypes(){
    return this.updatePrototypes;
  }

  public Trial getCurrentTrail(){
    return this.currentTrail;
  }

}
