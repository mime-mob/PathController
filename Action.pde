class Action {
  public static final float DOT_SIZE = 8;
  public static final float LINE_SIZE = 1;

  PVector anchor_1;
  PVector anchor_2;
  PVector control_1;
  PVector control_2;
  
  color controlColor = #FF4A36;
  color anchorColor = #FEFEFE;
  
  Action(PVector _a1, PVector _a2) {
    anchor_1 = _a1.copy();
    anchor_2 = _a2.copy();
    if(Util.vectorEquals(_a1, _a2)) {
      control_1 = _a1.copy();
      control_2 = _a2.copy();
    } else {
      PVector sub1 = PVector.sub(_a2, _a1);
      PVector sub2 = PVector.sub(_a1, _a2);
      control_1 = sub1.div(3).add(_a1);
      control_2 = sub2.div(3).add(_a2);
      control_1.x = (Util.format(control_1.x));
      control_1.y = (Util.format(control_1.y));
      control_2.x = (Util.format(control_2.x));
      control_2.y = (Util.format(control_2.y));
    }
  }
  
  void drawAnchors() {
    noFill();
    stroke(anchorColor);
    strokeWeight(LINE_SIZE);
    bezier(anchor_1.x, anchor_1.y, control_1.x, control_1.y, control_2.x, control_2.y, anchor_2.x, anchor_2.y);
  }
  
  void drawControl() {
    noFill();
    stroke(controlColor);
    strokeWeight(LINE_SIZE);
    line(anchor_1.x, anchor_1.y, control_1.x, control_1.y);
    line(anchor_2.x, anchor_2.y, control_2.x, control_2.y);
  }
  
  void drawDots() {
    strokeWeight(DOT_SIZE);
    fill(anchorColor);
    point(anchor_1.x, anchor_1.y);
    point(anchor_2.x, anchor_2.y);
    
    strokeWeight(DOT_SIZE);
    point(control_1.x, control_1.y);
    point(control_2.x, control_2.y);
  }
  
  public PVector findPVector(PVector vector) {
    float d = PVector.dist(anchor_1, vector);
    if(d <= DOT_SIZE / 2) {
      return anchor_1;
    }
    d = PVector.dist(anchor_2, vector);
    if(d <= DOT_SIZE / 2) {
      return anchor_2;
    }
    d = PVector.dist(control_1, vector);
    if(d <= DOT_SIZE / 2) {
      return control_1;
    }
    d = PVector.dist(control_2, vector);
    if(d <= DOT_SIZE / 2) {
      return control_2;
    }
    return null;
  }
  
  boolean isAnchor(PVector vector) {
    if(vector == null) {
      return false;
    }
    return Util.vectorEquals(vector, anchor_1) || Util.vectorEquals(vector, anchor_2);
  }
}