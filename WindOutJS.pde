ArrayList<Particle> particles = new ArrayList<Particle>();
boolean drawing = false;
PGraphics canvas;
Palettes palettes;
color[] colors;
String mode;
PShape myShape;

void setup() {
  size(960, 480);
  background(255);
  myShape = loadShape("vector/shapes.svg");
  canvas = createGraphics(960, 480);
  palettes = new Palettes();
  colors = palettes.colors.get(0);
}

void keyPressed() {
  if (key == ' ') {
    startOver();
  }
  if (key == 'c' || key == 'C') {
    changeColors();
  }
}

void changeColors() {
  palettes.nextColor();
  colors = palettes.colors.get(palettes.currentPalette);
}

void startOver() {
  particles.clear();
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
}

void draw() {
  background(255);
  if (drawing == true && particles.size() < 100) {
    Particle p = new Particle(new PVector(mouseX, mouseY), (int) random(80, 400));
    p.shape = myShape;
    p.shape.disableStyle();
    //p.shape = shapes.get((int) random(shapes.size()));
    //p.pixel = sourceImage.get((int) random(sourceImage.width), (int) random(sourceImage.height));
    p.pixel = colors[(int) random(colors.length)];
    particles.add(p);
  }
  canvas.beginDraw();
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = (Particle) particles.get(i);
    p.update();
    for (float turn = 0; turn < TWO_PI; turn += TWO_PI / 6) {
      canvas.pushMatrix();
      canvas.translate(width / 2, height / 2);
      canvas.rotate(turn);
      p.draw();
      canvas.popMatrix();
    }
    if (p.isDead) particles.remove(i);
  }
  canvas.endDraw();
  image(canvas, 0, 0);

  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);
    strokeWeight(0.1);
    rect(i * 20, 0, 20, 20);
  }
}

void mousePressed() {
  drawing = true;
}

void mouseReleased() {
  drawing = false;
}

class Palettes {

  ArrayList<color[]> colors = new ArrayList<color[]>();
  int currentPalette = 0;

  public Palettes() {
    // http://design-seeds.com/
    colors.add(colorsFromList(#3A3D40, #1D1D1D, #D14A31, #C7C6C1, #C9D04F, #718E15));
    colors.add(colorsFromList(#E0E0D7, #E1CB72, #9A7652, #424032, #3D7F3C, #8DC876));
    colors.add(colorsFromList(#CEAC7C, #B34245, #7A0024, #312927, #304614, #8B766F));
    colors.add(colorsFromList(#F2B774, #FB6084, #FB0029, #391E21, #56528E, #A197C2));
    colors.add(colorsFromList(#597A74, #6D0D00, #A5BB3C, #3E514C, #DF212F, #1A3419));
    colors.add(colorsFromList(#D7E1F0, #263165, #56B3A9, #4674C1, #2F565C, #CCC5BA));
    colors.add(colorsFromList(#EFF0D8, #EFF0D8, #EFF0D8, #EFF0D8, #0A0831, #A7A6C3));
    colors.add(colorsFromList(#313031, #313031, #D2FFDA, #47464C, #7195A8, #A09CAB));
    colors.add(colorsFromList(#EBCDE7, #BA3424, #2FA5A2, #EC7B00, #4E402E, #B2D68C));
    colors.add(colorsFromList(#AFF470, #4B4747, #FC6F44, #45B57E, #F10A36, #F2D863));
    colors.add(colorsFromList(#EDEEBE, #EC7A0B, #776573, #EECC63, #D45800, #D2CAD1));
    colors.add(colorsFromList(#2C575C, #202751, #A952B8, #16262E, #5A1984, #E6DDC0));
    colors.add(colorsFromList(#474447, #605A5F, #CCC8C9, #1C171B, #878282, #E0E0E0));
    colors.add(colorsFromList(#A8E3E3, #315D60, #6C5064, #4DB3AC, #1B1F1F, #C98F6C));
  }

  public void nextColor() {
    currentPalette = (currentPalette < colors.size()-1) ? currentPalette + 1 : 0;
  }

  public color[] colorsFromList(color c1, color c2, color c3, color c4, color c5, color c6) {
    color[] colorList = {
      c1, c2, c3, c4, c5, c6
    };
    return colorList;
  }
  
}

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
    maxScale = random(0.5);
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


