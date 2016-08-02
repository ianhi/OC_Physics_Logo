int a = 300;
int b = 200;
float theta_start = 0;
float theta_end = 2*PI;
color col; //Cardinal Red
float theta[] ;
float centX;
float centY;
int nTheta = 10000;
float rad = 5;
PFont f;
PGraphics pg;



float textHeight;


void setup() {
  size(700, 700);
  pg = createGraphics(width, height);

  f = createFont("Arial", 100);
  textAlign(CENTER, CENTER);
  smooth();
  textFont(f);
  textHeight = textAscent()+textDescent();

  centX = width/2;
  centY = height/2;
  col = #C41E3A;
  theta = new float[nTheta];
  for (int i = 0; i<nTheta; i++) {
    theta[i] = (theta_end-theta_start)/nTheta*i;
  }
  pg.stroke(col);
  pg.fill(col);
}

float damp(float t, float tau) {
  if (t<0) return exp(t/tau);
  else return exp(-t/tau);
}
void draw() {
  float r=0;
  pg.beginDraw();
  //pg.background(0);
  pg.stroke(col);
  pg.fill(col);
  pg.pushMatrix();
  pg.translate(width/2, height/2);

  for (int i = 0; i<nTheta; i++) {
    float denom = pow(b*cos(theta[i]), 2)+pow(a*sin(theta[i]), 2);
    r = a*b/sqrt(denom)+4*sin(2*PI*(theta[i]-PI/2)/.08)*damp(theta[i]-PI/5, .05)*10;
    float x = r*cos(theta[i]);//+centX;
    float y = r*sin(theta[i]);//+centY;
    pg.ellipse(x, y, rad, rad);
  }
  //translate(0, -b/2);
  //pg.noFill();
  drawStraight("Oberlin College", true);
  drawStraight("Physics", false);

  //PVector pos = drawCurved("Oberlin College", 1);
  pg.endDraw();

  pg.popMatrix();
  image(pg, 0, 0);
  pg.save("../logos/transparentProcessing.png");
  noLoop();
}

void drawStraight(String message, Boolean up) {
  // a wimpy verisino leaving the letter poitning striaght down
  PFont theFont = createFont("Ubuntu Medium Italic", 70);
  pg.textFont(theFont);
  pg.textAlign(CENTER, CENTER);
  float angleSweep = 0;
  float endAngle = 0;
  float extraAngle =230;
  float vPadFactor=1;
  pg.fill(  #FFC40C);
  if (up) {
    angleSweep = 135;
    endAngle=180;
    extraAngle = 180;
    vPadFactor = -1;
  } else {
    extraAngle = 0;
    angleSweep = 110;
    endAngle =0;
    message = new StringBuffer(message).reverse().toString();
    vPadFactor = 1;
  }
  float angleStep = angleSweep/(message.length()-1);
  for (int t=0; t<message.length(); t++) {
    float theta = radians(t*angleStep+extraAngle+(180-angleSweep)/2);//radians(t*angleStep-(angleSweep+endAngle)/2);

    pg.pushMatrix();

    float x = 0;
    float y = 0;
    float denom = pow(b*cos(theta), 2)+pow(a*sin(theta), 2);

    float r_ = a*b/sqrt(denom);
    x = r_*cos(theta)*1.15;
    y = r_*sin(theta)+60*vPadFactor;

    pg.translate(x, y);

    pg.text(message.charAt(t), 0, 0);

    pg.popMatrix();
  }
};
PVector drawCurved(String message, int direction) {

  PVector returnVector = new PVector();

  pushMatrix();

  if (direction == 1) { // clockwise (bend to right)

    // get the length of the message
    float l = textWidth(message);
    // the radius
    float r = l / (TWO_PI/1.9); // devide by 4 cause i want a 90 degree arc (Is this math correct?)
    // r += textHeight/2; // since we want to draw from the center of the curve

    translate(r, 0);
    // We must keep track of our position along the curve
    float arclength = 0;

    // For every box
    for (int i = 0; i < message.length(); i ++ ) {

      // The character and its width
      char currentChar = message.charAt(i);
      // Instead of a constant width, we check the width of each character.
      float w = textWidth(currentChar); 
      // Each box is centered so we move half the width
      arclength += w/2;

      // Angle in radians is the arclength divided by the radius
      // Starting on the left side of the circle by adding PI

      float theta = PI + arclength / r;
      float denom = pow(b*cos(theta), 2)+pow(a*sin(theta), 2);

      float r_ = a*b/sqrt(denom);
      float x = r_*cos(theta);//+centX;
      float y = r_*sin(theta);//+centY;
      float ang = atan(y/x);
      if (x>0) ang = atan(-y/x);
      pushMatrix();

      // Polar to Cartesian conversion allows us to find the point along the curve. See Chapter 13 for a review of this concept.
      translate(x, y); 
      // Rotate the box (rotation is offset by 90 degrees)
      rotate(ang+PI+PI/2); 
      println(ang+PI+PI/2);

      // Display the character
      fill(0);
      text(currentChar, 0, 0);

      if (i==message.length()-1) {
        returnVector.x = screenX(textWidth(currentChar)/2, 0);
        returnVector.y = screenY(textWidth(currentChar)/2, 0);
        returnVector.z = theta + HALF_PI; 
        returnVector.z += HALF_PI;
      }

      popMatrix();

      // Move halfway again
      arclength += w/2;
    }
  }
  popMatrix();

  return returnVector;
}