ArrayList<Action> actions;
ArrayList<PVector> selectedPVectors = new ArrayList<PVector>();
AnchorsHolder holder = new AnchorsHolder();
Hinter hinter = new Hinter();
GridLine gridLine = new GridLine();
Toast toast = new Toast();

PImage bgImage;

boolean addMode = true;
boolean editMode = false;
boolean showGridLine = false;
boolean showPreview = false;
boolean showBackground = true;
boolean invertBg = false;

float renderRegionWidth = 0;
float renderRegionHeight = 0;

void setup() {
  size(1200, 960);
  //fullScreen();
  renderRegionWidth = width - HintItem.WIDTH;
  renderRegionHeight = height;
  noLoop();
  actions = new ArrayList<Action>();
  
  try {
    bgImage = loadImage("image.png");
  } catch(Exception e) {
    showBackground = false;
    hinter.updateValue("B", false);
  }
  if(bgImage != null) {
    float scale = min(renderRegionWidth / bgImage.width, renderRegionHeight / bgImage.height);
    int resizeW = (int)(scale * bgImage.width);
    int resizeH = (int)(scale * bgImage.height);
    bgImage.resize(resizeW, resizeH);
    bgImage.filter(GRAY);
  }
}

void draw() {
  background(38);
  noFill();
  
  if(showBackground) {
    try {
      image(bgImage, (renderRegionWidth - bgImage.width) / 2, (renderRegionHeight - bgImage.height) / 2);
    } catch(Exception e) {
      println(e.getMessage());
    }
  }
  
  if(showGridLine) {
    gridLine.drawGrid(renderRegionWidth, renderRegionHeight);
  }
  
  holder.drawStart();
  for(Action a : actions) {
    a.drawAnchors();
    if(!showPreview) {
      a.drawControl();
      a.drawDots();
    }
  }
  
  hinter.drawItems();
  toast.display(renderRegionWidth, renderRegionHeight);
}

void mousePressed() {
  float currX = Float.valueOf(Util.format(mouseX));
  float currY = Float.valueOf(Util.format(mouseY));
  
  if(!addMode) {
    ArrayList<PVector> vectors = findPVectors(currX, currY);
    if(!vectors.isEmpty()) {
      selectedPVectors.clear();
      selectedPVectors.addAll(vectors);
      return;
    }
  }
  
  if(!addMode || currX < 0 || currX > renderRegionWidth || currY < 0 || currY > renderRegionHeight) {
    return;
  }
  
  Action action = holder.makeAction(currX, currY);
  if(action != null) {
    actions.add(action);
  }
  
  redraw();
}

void mouseDragged() {
  float x = Util.format(mouseX);
  float y = Util.format(mouseY);
  float preX = Util.format(pmouseX);
  float preY = Util.format(pmouseY);
  
  PVector preV = new PVector(preX, preY);
  PVector currV = new PVector(x, y);
  PVector move = PVector.sub(currV, preV);
  if(selectedPVectors != null 
      && !selectedPVectors.isEmpty() 
      && Util.vectorAlmostEquals(preV, selectedPVectors.get(0), Action.DOT_SIZE / 2)) {
    for(PVector v : selectedPVectors) {
      v.add(move);;
    }
    redraw();
  }
}

ArrayList<PVector> findPVectors(float x, float y) {
  PVector mouse = new PVector(x, y);
  ArrayList<PVector> result = new ArrayList<PVector>();
  for(Action a : actions) {
    PVector temp = a.findPVector(mouse);
    if(temp != null) {
      result.add(temp);
      if(!a.isAnchor(temp)) {
        break;
      }
    }
  }
  return result;
} 

void keyPressed() {
  if (key == CODED) {
    PVector vector = new PVector(0, 0);
    switch(keyCode) {
      case LEFT:
        vector.add(-1, 0);
        break;
      case UP:
        vector.add(0, -1);
        break;
      case RIGHT:
        vector.add(1, 0);
        break;
      case DOWN:
        vector.add(0, 1);
        break;
      case ESC:
        esc();
        break;
    }
    if(selectedPVectors != null && !selectedPVectors.isEmpty()) {
      for(PVector v : selectedPVectors) {
        v.add(vector);;
      }
      redraw();
    }
  } else {
    switch(key) {
      case 'a':
        addMode();
        break;
      case 'e':
        editMode();
        break;
      case 'l':
        gridLine();
        break;
      case 'v':
        preview();
        break;
      case 'b':
        showBackground();
        break;
      case 'i':
        invertBg();
        break;
      case 'z':
        closeAction();
        break;
      case 's':
        showResult();
        break;
      case 'c':
        clearActions();
        break;
      case 'd':
        deleteEnd();
        break;
    }
  }
  redraw();
}

void addMode() {
  addOrEditMode(true, false);
}

void editMode() {
  addOrEditMode(false, true);
}

void addOrEditMode(boolean _add, boolean _edit) {
  addMode = _add;
  editMode = _edit;
  hinter.updateValue("A", addMode);
  hinter.updateValue("E", editMode);
}

void gridLine() {
  showGridLine = !showGridLine;
  hinter.updateValue("L", showGridLine);
}

void preview() {
  showPreview = !showPreview;
  hinter.updateValue("V", showPreview);
  showBackground = !showPreview;
  hinter.updateValue("B", showBackground);
}

void showBackground() {
  if(bgImage != null) {
    showBackground = !showBackground;
    hinter.updateValue("B", showBackground);
  }
}

void invertBg() {
  invertBg = !invertBg;
  hinter.updateValue("I", invertBg);
  
  try {
    bgImage.filter(INVERT);
  } catch(Exception e) {
    println(e.getMessage());
  }
}

void clearActions() {
  actions.clear();
  holder.clearAnchors();
}

void deleteEnd() {
  holder.deleteEnd();
  if(actions.size() > 0) {
    actions.remove(actions.size() - 1);
  }
}

void closeAction() {
  Action closeAction = holder.closeAction();
  if(closeAction != null) {
    actions.add(closeAction);
  }
}

void esc() {
  exit();
}

void showResult() {
  JSONObject json = new JSONObject();
  json.setFloat("viewPortWidth", renderRegionWidth);
  json.setFloat("viewPortHeight", renderRegionHeight);
  json.setString("path", buildPathString());
  
  saveJSONObject(json, "path.json");
  println(json.toString());
  toast.show("路径导出成功！");
}

private String buildPathString() {
  StringBuilder sb = new StringBuilder();
  for(int i = 0; i < actions.size(); i++) {
    Action a = actions.get(i);
    if(i == 0) {
      sb.append('M')
        .append(a.anchor_1.x)
        .append(',')
        .append(a.anchor_1.y)
        .append(' ');
    }
    sb.append('C')
      .append(a.control_1.x)
      .append(',')
      .append(a.control_1.y)
      .append(',')
      .append(a.control_2.x)
      .append(',')
      .append(a.control_2.y)
      .append(',')
      .append(a.anchor_2.x)
      .append(',')
      .append(a.anchor_2.y);
      
    if(i < actions.size() - 1) {
      sb.append(' ');
    }
  }
  return sb.toString();
}