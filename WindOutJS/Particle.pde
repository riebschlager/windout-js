class Particle {

  PVector pos, vel, noiseVec;
  float noiseFloat;
  int lifetime, age;
  boolean isDead;
  PShape shape;
  int pixel;
  float initialRotation, finalRotation, maxScale, percent;

  public Particle(PVector _pos, int _lifetime) {
    pos = _pos;
    vel = new PVector(0, 0);
    lifetime = _lifetime;
    age = 1;
    isDead = false;
    noiseVec = new PVector();
    initialRotation = random(-HALF_PI, HALF_PI);
    finalRotation = random(-HALF_PI, HALF_PI);
    maxScale = random(1);
  }

  void update() {
    percent = (float) age / (float) lifetime;
    noiseFloat = noise(pos.x, pos.y);
    noiseVec.x = cos(noiseFloat);
    noiseVec.y = sin(noiseFloat);
    vel.add(noiseVec);
    vel.div(100);
    pos.add(vel);
    age++;
    if (percent == 1f) {
      isDead = true;
    }
  }

  void draw() {
    canvas.fill(pixel, map(percent, 0, 1, 150, 0));
    canvas.noStroke();
    shape.resetMatrix();
    shape.scale(maxScale * percent);
    shape.rotate(map(percent, 0, 1, initialRotation, finalRotation));
    canvas.shape(shape, pos.x - width / 2, pos.y - height / 2);
  }
}

