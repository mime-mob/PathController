class Hinter {
  boolean showGrid = false;;
  boolean showPic = false;
  
  ArrayList<HintItem> switchItems = new ArrayList<HintItem>();
  ArrayList<HintItem> operateItems = new ArrayList<HintItem>();
  
  color lineColor = color(68);

  Hinter() {
    switchItems.add(new HintItem("A", true, "添加模式", HintItem.TYPE_SWITCH));
    switchItems.add(new HintItem("E", false, "编辑模式", HintItem.TYPE_SWITCH));
    switchItems.add(new HintItem("L", false, "辅助网格", HintItem.TYPE_SWITCH));
    switchItems.add(new HintItem("V", false, "预览成形", HintItem.TYPE_SWITCH));
    switchItems.add(new HintItem("B", true, "显示背景", HintItem.TYPE_SWITCH));
    switchItems.add(new HintItem("I", false, "背景反向", HintItem.TYPE_SWITCH));
    
    operateItems.add(new HintItem("D", true, "删除末尾", HintItem.TYPE_OPERATE));
    operateItems.add(new HintItem("C", true, "删除所有", HintItem.TYPE_OPERATE));
    operateItems.add(new HintItem("Z", true, "闭合曲线", HintItem.TYPE_OPERATE));
    operateItems.add(new HintItem("S", true, "导出路径", HintItem.TYPE_OPERATE));
  }

  void drawItems() {
    int startX = width - HintItem.WIDTH;

    //draw dash line
    stroke(lineColor);
    strokeWeight(1);
    drawDashLine(0, height, startX);
    
    //draw item
    for (int i = 0; i < switchItems.size(); i++) {
      HintItem item = switchItems.get(i);
      item.display(startX, i * HintItem.HEIGHT);
    }
    for (int i = 0; i < operateItems.size(); i++) {
      HintItem item = operateItems.get(i);
      item.display(startX, (i + switchItems.size()) * HintItem.HEIGHT);
    }
  }
  
  void drawDashLine(float y1, float y2, float x) {
    int dash = 8;
    int spacing = 8;
    while(y1 < y2) {
      line(x, y1, x, y1 + dash);
      y1 = y1 + dash + spacing;
    }
  }
  
  void updateValue(String name, boolean value) {
    for(HintItem item : switchItems) {
      if(item.name.equalsIgnoreCase(name)) {
        item.state = value;
        break;
      }
    }
  }
}