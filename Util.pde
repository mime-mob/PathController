import java.text.DecimalFormat;

static class Util {

  private static DecimalFormat formater = new DecimalFormat("#.##");
  
  public static float format(float num) {
    return Float.valueOf(formater.format(num));
  }
  
  public static boolean vectorEquals(PVector v1, PVector v2) {
    if(v1 == null || v2 == null) {
      return false;
    }
    return v1.x == v2.x && v1.y == v2.y;
  }
  
  public static boolean vectorAlmostEquals(PVector v1, PVector v2, float dist) {
    if(v1 == null || v2 == null) {
      return false;
    }
    return PVector.dist(v1, v2) <= dist;
  }
}