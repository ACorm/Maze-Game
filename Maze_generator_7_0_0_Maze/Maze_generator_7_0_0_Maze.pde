PImage Wall; //<>//



int SizeX=2;
int SizeY=2;

//**************************************************************************************************************

//Variables for 3d animation

//x position of camera
float x=100;
//z position of camera
float z=100;
//showing map or not
boolean map = true;
//rotation of camera
float rotation=0;
//Movement speed
int speed=20;
//Rotation speed
float rotationSpeed=0.5;

int [] [] connections = new int [SizeX+1] [2*SizeY+1];

int [] [] explore = new int [SizeX] [SizeY];

int [] [] path = new int [0] [0];

//Variables and arrays for maze Seeding

//Specifies the fraction out of 1 of the points picked as a seed. ex 0.05 means for every 100 5 are picked
float seed = 1;

void setup() {
  size(1366, 768, P3D);
  //1366 , 768
  connections = GrowMaze();
  path = SolveMaze(); 
  Wall = loadImage("Wall.jpg"); 
  textureWrap(REPEAT);
  rect(0, 0, 1, 1);
}

int t = 0;

void draw () { 
  //line(x, z, 400*path [t/1] [1]+200, 400*path [t/1] [0]+200);
  x = 400*path [t/1] [1]+200;
  z = 400*path [t/1] [0]+200;
  t++;


  rect(0, 0, 1, 1);
  int extraLR=(width-min(height, width))/2;
  int extraUD=(height-min(height, width))/2;
  background(0);
  if (map==true) {
    pushMatrix();
    translate(extraLR, extraUD, 0);
    stroke(255);
    for (int xPos = 0; xPos<SizeX+1; xPos++) {
      for (int yPos = 0; yPos<2*SizeY+1; yPos++) {
        if (connections [xPos] [yPos] != 0) {
          int x1=xPos;
          int y1=floor(yPos/2);
          int x2=xPos+((yPos+1)%2);
          int y2=ceil(yPos/2.0);
          if (yPos%2==1) {                                               
            if (explore [xPos] [ceil(yPos/2.0)-1] == 1 || explore [xPos-1] [ceil(yPos/2.0)-1] == 1 ) { 
            line((x1+1)*min(height, width)/(SizeX+2), height-(y1+1)*min(height, width)/(SizeY+2), (x2+1)*min(height, width)/(SizeX+2), height-(y2+1)*min(height, width)/(SizeY+2));
            }
          } else {
            if (explore [xPos] [ceil(yPos/2.0)-1] == 1 || explore [xPos] [ceil(yPos/2.0)] == 1 ) {              
            line((x1+1)*min(height, width)/(SizeX+2), height-(y1+1)*min(height, width)/(SizeY+2), (x2+1)*min(height, width)/(SizeX+2), height-(y2+1)*min(height, width)/(SizeY+2));
            }
          }
        }
      }
    }
    fill(256, 00, 00);
    ellipse(-(-z/400-1)*min(height, width)/(SizeX+2), height+(-x/400-1)*min(height, width)/(SizeY+2), min(height, width)/(SizeX+2), min(height, width)/(SizeY+2));
    noFill();
    line(min(height, width)/(SizeX+2), min(height, width)/(SizeY+2), (SizeX)*min(height, width)/(SizeX+2), min(height, width)/(SizeY+2));    
    line(min(height, width)/(SizeX+2), min(height, width)/(SizeY+2), min(height, width)/(SizeX+2), (SizeY)*min(height, width)/(SizeY+2));
    line((SizeX+1)*min(height, width)/(SizeX+2), min(height, width)/(SizeY+2), (SizeX+1)*min(height, width)/(SizeX+2), (SizeY+1)*min(height, width)/(SizeY+2));
    line((SizeX+1)*min(height, width)/(SizeX+2), (SizeY+1)*min(height, width)/(SizeY+2), min(height, width)/(SizeX+2), (SizeY+1)*min(height, width)/(SizeY+2));
    popMatrix();
  } else {
    background(0);
    noStroke();
    pushMatrix();
    rotateY(rotation/10);
    translate(x, 0, z);
    for (int xpos=0; xpos<SizeX+1; xpos++) {
      for (int ypos=0; ypos<2*SizeY+1; ypos++) {
        if (connections [xpos] [ypos] !=0 || ( (( xpos==0 && ypos%2==1 ) || (ypos==0) || (ypos==2*SizeY) || (xpos==SizeX && ypos%2==1) ) && !(( xpos==0 && ypos == 1) || ( xpos==SizeX-1 && ypos==2*SizeY )) )) {
          pushMatrix();
          translate(-400*ypos/2, height/2, -400*(xpos+((ypos+1)%2)/2.0));
          if (ypos%2==0) {
            rotateY(PI/2);
          }
          createShape();
          texture(Wall);
          vertex(-200, 200, 0, 0, 0);
          vertex(200, 200, 0, 910, 0);
          vertex(200, -200, 0, 910, 607);
          vertex(-200, -200, 0, 0, 607);          
          endShape();
          popMatrix();
        }
      }
    }              
    popMatrix();
  }
  if (map==true) {    
    camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  } else {
    camera(0, height/2, 0, 0, height/2, -0.1, 0, 1, 0);
  }
  if (keyPressed&&map==false) {
    switch(keyCode) {
      case(UP):
      z+=speed*cos(-rotation/10);
      x+=speed*sin(-rotation/10);      
      break;
      case(DOWN):
      z-=speed*cos(-rotation/10);
      x-=speed*sin(-rotation/10);
      break;
      case(LEFT):
      rotation-=rotationSpeed;
      break;
      case(RIGHT):
      rotation+=rotationSpeed;    
      break;   
    default:           
      break;
    }
    if (z<100) {
      z=100;
    } else {
      if (z>SizeX*400-100) {
        z=SizeX*400-100;
      }
    }
    if (x<100) {
      x=100;
    } else {
      if (x>SizeY*400-100) {
        x=SizeY*400-100;
      }
    }

    //***************************************

    //collision

    // ypos/3D xpos   -400*ypos/2    xpos/3D zpos  -400*(xpos+((ypos+1)%2)/2.0)
    int ySquare = floor(x/400);
    int aboutYSquare = round(x) % 400;
    int xSquare = floor(z/400);
    int aboutXSquare = round(z) % 400;

    //UP
    if (connections [xSquare] [2*ySquare+2] != 0 && aboutYSquare>300) {
      x=400*ySquare+300;
    }  
    //Left
    if (connections [xSquare] [2*ySquare+1] != 0&&aboutXSquare<100) {
      z=400*xSquare+100;
    }
    //Down
    if (connections [xSquare] [2*ySquare] != 0&&aboutYSquare<100) {
      x=400*ySquare+100;
    }
    //right
    if (connections [xSquare+1] [2*ySquare+1] != 0&&aboutXSquare>300) {
      z=400*xSquare+300;
    }
  }
  explore [floor(z/400)] [floor(x/400)] = 1;
  if (floor(z/400)==SizeX-1 && floor(x/400)==SizeY-1) {
    background(0);     
    SizeX++;
    SizeY++;
    //SizeY=SizeX*(1);
    int [] [] blankArray = new int [SizeX] [SizeY];
    explore = blankArray;                                  
    connections = GrowMaze();
    path = SolveMaze();
    x=100;
    z=100;
    t=0;
    return;
  }
}

void keyTyped() {
  if (key=='m'&&map==false) {
    map=true;
  } else {
    if (key=='s'&&map==false) {
      t++;
    } else {
      map=false;
    }
  }
}
