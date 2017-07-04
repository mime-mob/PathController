class Toast {
  public static final float SHOW_WIDTH =260;
  public static final float SHOW_HEIGHT =64;
  public static final float TIME = 1600;
  String desc = "";
  float startTime;
  boolean isDisplay = false;
  
  void show(String _desc) {
    this.desc = _desc;
    isDisplay = true;
    startTime = millis();
    loop();
  }
  
  void display(float regionWidth, float regionHeight) {
    if(isDisplay && millis() - startTime < TIME) {
      stroke(250, 250, 250, 40);
      strokeWeight(2);
      //noStroke();
      fill(250, 250, 250, 40);
      rect((regionWidth - SHOW_WIDTH) / 2, (regionHeight - SHOW_HEIGHT) / 2, SHOW_WIDTH, SHOW_HEIGHT);
      textAlign(CENTER, CENTER);
      textSize(18);
      fill(250, 250, 250, 220);
      text(desc, regionWidth / 2, regionHeight / 2);
    } else {
      isDisplay = false;
      noLoop();
    }
  }
}