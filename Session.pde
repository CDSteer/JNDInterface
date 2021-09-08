import java.sql.Timestamp;
import java.util.Random;

public class Session {
  public static final int MAX_REVERSALS = 10;
  public static final int MAX_TRAILS = 40;
  private static final int NUM_PROTOTYPES = 2;
  private static final int STIMULI_INCRIMENT = 10;

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
  private Trial lastTrail;


  private boolean updatePrototypes;

  // private int lastAnswerCorrect;
  private int lastValue;

  private int curentDirection;
  private int lastDirection;

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
    this.currentTrail = new Trial(_startValue, _staircaseOrder, true);
    this.currentTrail.setCorrectAnswer(_staircaseOrder);


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

    this.updatePrototypes = true;
  }

  public void newAnswer(int answer){
    System.out.println("User Answer:" + answer);
    
    this.updatePrototypes = true;
    this.currentTrail.setUserAnswer(answer);
    this.lastValue = this.currentTrail.getControlPrototype().getServoValue();
    this.lastTrail = this.currentTrail;
    this.reversalCheck();
    this.addToCSV();
    if (this.trialCount >= MAX_TRAILS || this.reveralCount == MAX_REVERSALS){
      exit();
    } else {
      this.trialCount++;
      this.setNewPrototypeOrder();
      this.updatePrototypeValues();
      this.currentTrail.setCorrectAnswer(this.staircaseOrder);
    }
  }

  private void reversalCheck(){
    // if the last anwser was different to the past answer
    // System.out.println("reversal check: " + this. + ":" + this.currentTrail.getCorrectAnswer());
    System.out.println(this.lastDirection +":"+ this.curentDirection);
    if (this.curentDirection != this.lastDirection){
      this.reveralCount++;
      this.lastTrail.setReversal(1);
    } else {
      this.lastTrail.setReversal(0);
    }
    System.out.println("reversal: "+this.currentTrail.getReversal());
  }

  private void setNewPrototypeOrder(){
    int int_random = rand.nextInt(NUM_PROTOTYPES);
    this.currentTrail = new Trial(this.startValue, int_random);
    if (int_random == 0){
      currentTrail.getRefPrototype().setOrder(0);
      currentTrail.getControlPrototype().setOrder(1);
    } else {
      currentTrail.getRefPrototype().setOrder(1);
      currentTrail.getControlPrototype().setOrder(0);
    }
  }

  private void updatePrototypeValues(){
    currentTrail.getRefPrototype().setServoValue(this.startValue);

    // incrase if the last answer was correct
    // decrase if the last answer was incorrect
    this.lastDirection = this.curentDirection;

    if (this.lastTrail.getUserCorrect() == 1) {
      if (lastTrail.getControlPrototype().getServoValue() > lastTrail.getRefPrototype().getServoValue()){
        currentTrail.getControlPrototype().setServoValue(this.lastValue-STIMULI_INCRIMENT);
        System.out.println("Correct: control--");
        this.curentDirection = 0;
      } else {
        currentTrail.getControlPrototype().setServoValue(this.lastValue+STIMULI_INCRIMENT);
        System.out.println("Correct: control++");
        this.curentDirection = 1;
      }
    } else {
      if (lastTrail.getControlPrototype().getServoValue() > lastTrail.getRefPrototype().getServoValue()){
        currentTrail.getControlPrototype().setServoValue(this.lastValue+STIMULI_INCRIMENT);
        System.out.println("Wrong: control++");
        this.curentDirection = 1;
      } else {
        currentTrail.getControlPrototype().setServoValue(this.lastValue-STIMULI_INCRIMENT);
        System.out.println("Wrong: control--");
        this.curentDirection = 0;
      }
    }

    // if (this.staircaseOrder == 0) {
    //   if (this.lastTrail.getReversal() == 0) {
    //     currentTrail.getControlPrototype().setServoValue(this.lastValue+STIMULI_INCRIMENT);
    //     System.out.println("control++");
    //   } else {
    //     currentTrail.getControlPrototype().setServoValue(this.lastValue-STIMULI_INCRIMENT);
    //     System.out.println("control--");
    //   }
    // } else {
    //   if (this.lastTrail.getReversal() == 0){
    //     currentTrail.getControlPrototype().setServoValue(this.lastValue-STIMULI_INCRIMENT);
    //     System.out.println("control--");
    //   } else {
    //     currentTrail.getControlPrototype().setServoValue(this.lastValue+STIMULI_INCRIMENT);
    //     System.out.println("control++");
    //   }
    // }

    // TODO: sepertate the method
    if (this.currentTrail.prototypesEqual()) {
      System.out.println("equal");
      if (this.lastValue > this.currentTrail.getControlPrototype().getServoValue()) {
        currentTrail.getControlPrototype().setServoValue(this.currentTrail.getControlPrototype().getServoValue()-STIMULI_INCRIMENT);
      } else {
        currentTrail.getControlPrototype().setServoValue(this.currentTrail.getControlPrototype().getServoValue()+STIMULI_INCRIMENT);
      }
    }

  }

  private void addToCSV(){
    TableRow newRow = table.addRow();
    newRow.setInt("id", table.getRowCount() - 1);
    Timestamp timestamp = new Timestamp(System.currentTimeMillis());
    newRow.setString("timestamp", String.valueOf(timestamp));
    newRow.setString("reference_order", String.valueOf(currentTrail.getRefPrototype().getOrder()));
    newRow.setString("reference_value", String.valueOf(currentTrail.getRefPrototype().getServoValue()));
    newRow.setString("contol_order", String.valueOf(currentTrail.getControlPrototype().getOrder()));
    newRow.setString("contol_value",    String.valueOf(currentTrail.getControlPrototype().getServoValue()));
    newRow.setString("reversal",  String.valueOf(currentTrail.isReversal()));
    newRow.setString("correct_answer", String.valueOf(currentTrail.getCorrectAnswer()));
    newRow.setString("user_answer",    String.valueOf(currentTrail.getUserAnswer()));
    saveTable(table, "data/"+pNum+"/"+tableName+".csv");
    System.out.println("Data Saved");
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

  public int getTrailCount(){
    return this.trialCount;
  }

  public int getReversalCount(){
    return this.reveralCount;
  }

  public String getStairCaseName(){
    return this.staircaseOrderName;
  }
}
