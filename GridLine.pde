class GridLine {
  float dash = 5;
  float spacing = 5;
  float lineGap = 25;
  color lineColor = color(68);
  color lineColorLight = color(100);
  
  void drawGrid(float regionW, float regionH) {
    stroke(lineColor);
    strokeWeight(1);
    drawHorizontalGrid(regionW, regionH);
    drawVerticalGrid(regionW, regionH);
  }
  
  void drawHorizontalGrid(float regionW, float regionH) {
    float rows = regionH / lineGap + 1;
    float cols = regionW / (dash + spacing);
    for(int i = 0; i < rows; i++) {
       stroke(i % 4 == 0 ? lineColorLight : lineColor);
      for(int j = 0; j < cols; j++) {
        line(j * (dash + spacing), i * lineGap, j * (dash + spacing) + dash, i * lineGap);
      }
    }
  }
  
  void drawVerticalGrid(float regionW, float regionH) {
    float cols = regionW / lineGap;
    float rows = regionH / (dash + spacing) + 1;
    for(int i = 0; i < cols; i++) {
      stroke(i % 4 == 0 ? lineColorLight : lineColor);
      for(int j = 0; j < rows; j++) {
        line(i * lineGap, j * (dash + spacing), i * lineGap, j * (dash + spacing) + dash);
      }
    }
  }
}