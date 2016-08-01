int a = 300;
int b = 200;
float theta_start = 0;
float theta_end = 2*PI;
color col; //Cardinal Red
float theta[] ;
float centX;
float centY;
int nTheta = 10000;

PFont f;


float textHeight;


void setup() {
  size(1200, 900);
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
  stroke(col);
}

float damp(float t, float tau) {
  if (t<0) return exp(t/tau);
  else return exp(-t/tau);
}
void draw() {
  float r=0;
  stroke(col);
  translate(width/2, height/2);

  for (int i = 0; i<nTheta; i++) {
    float denom = pow(b*cos(theta[i]), 2)+pow(a*sin(theta[i]), 2);
    r = a*b/sqrt(denom)+4*sin(2*PI*(theta[i]-PI/2)/.08)*damp(theta[i]-PI/5, .05)*10;
    float x = r*cos(theta[i]);//+centX;
    float y = r*sin(theta[i]);//+centY;
    //point(x, y);
    ellipse(x, y, 2.5, 2.5);
  }
  translate(-a,-b/2);
  noFill();
  PVector pos = drawCurved("Oberlin College", 1);
  // green dot to show end of previous one
  fill(0, 255, 0);
  ellipse(-a,0,200,200);
  ellipse(pos.x, pos.y, 500, 500);
  //popMatrix();
  noLoop();
}
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
      float phi = atan(pow(a/b,2)*tan(theta));
      pushMatrix();

      // Polar to Cartesian conversion allows us to find the point along the curve. See Chapter 13 for a review of this concept.
      translate(a*cos(theta), b*sin(theta)); 
      // Rotate the box (rotation is offset by 90 degrees)
      rotate(phi+PI/2); 
      println(phi);

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