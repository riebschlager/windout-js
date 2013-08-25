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
  if (drawing == true && particles.size() < 20) {
    Particle p = new Particle(new PVector(mouseX, mouseY), (int) random(80, 100));
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

