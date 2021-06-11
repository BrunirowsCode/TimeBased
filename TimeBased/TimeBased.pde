//190 a 340 theta
final float SECONDS_SIZE = 150;
final float MINUTES_SIZE = 200;
final float HOURS_SIZE = 100;
final float MARGIN = 10;
PGraphics pg;
float second, minute, hour;

void setup()
{
  size(500, 700);
  pg = createGraphics(int(width - MARGIN * 2), int(height * 0.25));
  strokeWeight(5);
  stroke(255);
  noFill();
  frameRate(5);
}

void draw()
{
  background(0);
  noFill();
  pushMatrix();
  translate(width * 0.5, height * 0.63);
  circle(0, 0, width * 0.9);
  
  beginShape(POINTS);
  fill(255);
  stroke(255);
  for(int a = 0; a < 360; a +=6)
  {
    float angle = radians(a);
    float x = cos(angle) * width * 0.4;
    float y = sin(angle) * width * 0.4;
    vertex(x, y);
  }
  endShape();

  second = second();
  minute = minute();
  hour = hour();
  float s = map(second, 0, 60, 0, TWO_PI) - HALF_PI;
  float m = map(minute + norm(second, 0, 60), 0, 60, 0, TWO_PI) - HALF_PI;
  float h = map(hour + norm(minute, 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;

  stroke(255, 0, 0);
  line(0, 0, cos(s) * SECONDS_SIZE, sin(s) * SECONDS_SIZE);
  stroke(255);
  line(0, 0, cos(m) * MINUTES_SIZE, sin(m) * MINUTES_SIZE);
  line(0, 0, cos(h) * HOURS_SIZE, sin(h) * HOURS_SIZE);
  popMatrix();
  pg.beginDraw();
  pg.background(calculateBgColor(hour, minute));
  pg.pushMatrix();
  pg.translate(width * 0.5, 250);
  PVector pos = calculatePosition(hour, minute, second, 200);
  if (hour >= 6 && hour <= 18)
  {
    pg_sun(pg, pos.x, pos.y, 50);
  } else {
    pg_moon(pg, pos.x, pos.y, 50);
  }
  pg.popMatrix();
  pg.endDraw();
  image(pg, MARGIN, MARGIN);
}

void pg_sun(PGraphics p, float x, float y, float s)
{
  p.noStroke();
  p.fill(255, 255, 0);
  p.pushMatrix();
  p.translate(x, y);
  p.ellipse(0, 0, s, s);
  p.fill(0);
  p.ellipse(-s * 0.2, -s * 0.2, s * 0.1, s * 0.1);
  p.ellipse(+s * 0.2, -s * 0.2, s * 0.1, s * 0.1);
  p.fill(255);
  p.stroke(0);
  p.arc(0, 0, s * 0.8, s * 0.8, 0, PI, PIE);
  p.popMatrix();
}

void pg_moon(PGraphics p, float x, float y, float s)
{
  p.noStroke();
  p.fill(255, 255, 0);
  p.pushMatrix();
  p.translate(x, y);
  p.ellipse(0, 0, s, s);
  p.fill(calculateBgColor(hour, minute));
  p.ellipse(s*0.3, 0, s*0.5, s*0.5);
  p.fill(0);
  p.ellipse(-s * 0.2, -s * 0.2, s * 0.1, s * 0.1);
  p.ellipse(0, -s * 0.2, s * 0.1, s * 0.1);
  p.fill(255);
  p.stroke(0);
  p.arc(0, 0, s * 0.8, s * 0.8, HALF_PI, PI, PIE);
  p.popMatrix();
}

PVector calculatePosition(float h, float m, float s, float radius)
{
 float alpha = 0;
 if(h >= 6 && h <= 17)
 {
   alpha = norm(h + norm(m + norm(s, 0, 60), 0, 60), 6, 18);
 }else if(h >= 18 && h < 24)
 {
   alpha = norm(h + norm(m + norm(s, 0, 60), 0, 60), 18, 30);
 }else if(h < 6)
 {
   float newH = h + 24;
   alpha = norm(newH + norm(m + norm(s, 0, 60), 0, 60), 18, 30);
 }

 float theta = map(alpha, 0, 1, 190, 340);
 float x = cos(radians(theta));
 float y = sin(radians(theta));
 return new PVector(x * radius, y * radius);
}

color calculateBgColor(float h, float m)
{
  if(h == 5)
  {
    return lerpColor(color(41, 41, 101), color(102, 150, 186), norm(m, 0, 60));
  }else if(h > 5 && h <= 17)
  {
    return color(102, 150, 186);
  }else if(h == 18)
  {
    if(m < 15)
    {
      return lerpColor(color(102, 150, 186), color(226, 227, 139), norm(m, 0, 15));
    }else if(m < 30)
    {
      return lerpColor(color(226, 227, 139), color(231, 165, 83), norm(m, 15, 30));
    }else if(m < 45)
    {
      return lerpColor(color(231, 165, 83), color(126, 75, 104), norm(m, 30, 45));
    }else
    {
      return lerpColor(color(126, 75, 104), color(41, 41, 101), norm(m, 45, 60));
    }
  }
  return color(0, 0, 100);
}
