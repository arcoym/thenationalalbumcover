import processing.pdf.*;
import toxi.util.datatypes.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer song;
AudioInput input;

PShape trunk;
PFont font;
float numVertices = 100;
float vertexDegree = 360 / numVertices;
int r;

void setup()
{
  size(700, 700);
  smooth();
  trunk = loadShape("TreeTrunk.svg");
  font = loadFont("HelvLight32.vlw");

  minim = new Minim(this);
  input = minim.getLineIn (Minim.STEREO, 512);
  
  //choice of three The National songs - comment out 2/3 to play
  song = minim.loadFile("01 Wasp Nest.mp3");
  //song = minim.loadFile("02 All the Wine.mp3");
  //song = minim.loadFile("05 About Today.mp3");
  song.play();
  beginRecord(PDF, "ForPrint.pdf");
}

void draw()
{
  myDelay(2000);
  WeightedRandomSet<Integer> ran = new WeightedRandomSet<Integer>();
  
  //getting the volume of the music
  float dim = input.mix.level () * width;
  println(dim);
  
  //colors depending on music
  if(dim < 60)
  {
    r = 1;
  }
  if (dim < 85)
  {
   r = 2; 
  }
  if (dim < 30)
  {
   r = 3; 
  } 
  //int r = 2;
  ran.add(color(200, 103, 86), 2*r +2); //pink
  ran.add(color(206, 188, 184), r *(2+r)); //soft greyish
  ran.add(color(217, 153, 107), 4 + r); //orangey
  ran.add(color(226, 167, 127), r + (2*r-1)); //rosa
  ran.add(color(253, 239, 230), 3*r + (2*r-4)); //white
  ran.add(color(137, 75, 64), 2*r -2); //brown
  ran.add(color(219, 192, 163), 1); //hell
  ran.add(color(5, 6, 11), 3*r - r*2); //black

//set background randomly
  background(ran.getRandom());
  noStroke();

  for (int i = 0; i < 100; i++)
  {
    // spacing of triangles dependent on loudness of music at given point
    float circleRadius = random(60, 60+dim);
    float x = cos(radians(i * vertexDegree)) * (circleRadius);
    float y = sin(radians(i * vertexDegree)) * (circleRadius);
    pushMatrix();
    translate(340, 200);
    rotate(random(720));
    fill(ran.getRandom());
    triangle(x+i, y+i, (x+random(10, 50))+i, (y-random(10, 50))+i, (x+random(20, 70))+i, y+i);
    popMatrix();
  }
  
//draw treetrunk
  pushMatrix();
  translate(170, 300);
  trunk.scale(0.4);
  shape(trunk);
  popMatrix();

//draw album title
  fill(30);
  textFont(font, 26);
  text("THE NATIONAL", width-230, height-30);
  translate(width-30, height-60);
  rotate(radians(-90)); 
  text("CHERRY TREE", 0, 0);

  noLoop();
  endRecord();
}

//delay function for catching audio 2 seconds into the song
void myDelay(int ms)
{
  try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e) {
  }
}

