class AnchorsHolder {
  ArrayList<PVector> anchors = new ArrayList<PVector>();
  boolean isClose = false;
  
  Action makeAction(float x, float y) {
    if(isClose) {
      return null;
    }
    PVector anchor = new PVector(x, y);
    if(anchors.size() > 1 && Util.vectorAlmostEquals(anchor, anchors.get(0), Action.DOT_SIZE / 2)) {
      return closeAction();
    } else {
      anchors.add(anchor);
      if(anchors.size() > 1) {
        PVector preAnchor = anchors.get(anchors.size() - 2);
        return new Action(preAnchor, anchor);
      }
      return null;
    }
  }
  
  Action closeAction() {
    if(isClose) {
      return null;
    }
    if(anchors.isEmpty() || anchors.size() < 2) {
      return null;
    }
    PVector anchor1 = anchors.get(anchors.size() - 1);
    PVector anchor2 = anchors.get(0);
    isClose = true;
    return new Action(anchor1, anchor2);
  }
  
  void deleteEnd() {
    if(!isClose) {
      anchors.remove(anchors.size() - 1);
    }
    isClose = false;
  }
  
  void clearAnchors() {
    anchors.clear();
    isClose = false;
  }
  
  void drawStart() {
    if(anchors.size() == 1) {
      stroke(255);
      strokeWeight(Action.DOT_SIZE);
      point(anchors.get(0).x, anchors.get(0).y);
    }
  }
}