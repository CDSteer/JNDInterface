public class Button {
  private int xPos;
  private int yPos;
  private int btnHeight;
  private int btnWidth;
  private String lable;

  public Button(int _x, int _y, int _h, int _w, String _lable){
    this.xPos = _x;
    this.yPos = _y;
    this.btnHeight = _h;
    this.btnWidth = _w;
    this.lable = _lable;
  }

  public int getXPos(){
    return this.xPos;
  }

  public int getYPos(){
    return this.yPos;
  }

  public int getHeight(){
    return this.btnHeight;
  }

  public int getWidth(){
    return this.btnWidth;
  }

  public String getValue(){
    return this.lable;
  }

  public void drawBtn(){
    fill(255, 255, 255);
    rect(this.getXPos(), this.getYPos(), this.getHeight(), this.getWidth());
    fill(0, 102, 153);
    textSize(28);
    text(this.lable, this.getXPos()+10, this.getYPos()+30);
  }

  boolean overBtn(int x, int y)  {
    if (x >= this.xPos && x <= this.xPos+this.btnWidth &&
        y >= this.xPos && y <= this.yPos+this.btnHeight) {
      return true;
    } else {
      return false;
    }
  }
}
