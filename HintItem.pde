class HintItem {
  public static final int WIDTH = 240;
  public static final int HEIGHT = 44;
  public static final int DOT_SIZE = 12;
  public static final int TYPE_SWITCH = 0;
  public static final int TYPE_OPERATE = 1;
  
  String name;
  boolean state = false;
  String desc;
  int type;
  
  color dotOnColor = color(0, 255, 0);
  color dotOffColor = color(80);
  color dotOperateColor = color(255, 188, 0);
  color keyNameColor = color(255, 255, 255);
  color keyDescColor = color(240, 240, 240);
  color dividerColor = color(68);
  
  HintItem(String _name, boolean _state, String _desc, int _type) {
    this.name = _name;
    this.state = _state;
    this.desc = _desc;
    this.type = _type;
  }
  
  void display(float x, float y) {
    if(type == TYPE_OPERATE) {
      fill(dotOperateColor);
    } else {
      fill(state ? dotOnColor : dotOffColor);
    }
    
    noStroke();
    ellipse(x + 24, y + HEIGHT / 2, DOT_SIZE, DOT_SIZE);
    
    stroke(dividerColor);
    strokeWeight(1);
    line(x, y + HEIGHT, x + WIDTH, y + HEIGHT);
    
    fill(keyNameColor);
    textFont(createFont("宋体", 16, true));
    textAlign(CENTER, CENTER);
    text('[' + name + ']', x + 56, y + HEIGHT / 2 - 1);
    
    fill(keyDescColor);
    text(desc, x + 120, y + HEIGHT / 2 - 1);
  }
}