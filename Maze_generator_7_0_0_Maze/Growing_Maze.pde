int[][] GrowMaze () {

  //Variables and arrays for maze Seeding

  //The array of the Seed values.
  // [x pos] [y pos] Value-is it atttached to edge or not 2 or one
  int [] [] seedPoints = new int [SizeX+1] [SizeY+1];


  //Variables and arrays for maze Growing

  //# of points grown
  int points = 0;
  //how many points on edge
  int edgePoints = 0;
  //Array for points that can grow
  // [xpos] [ypos] Value-what seed 
  int [] [] growPoints = new int [SizeX+1] [SizeY+1];
  //The array of all the conections between points. 2*SizeY because it is inbetween and not inbetween thus *2
  // [x pos] [y pos] Value what seed is it attached to
  int [] [] Connections = new int [SizeX+1] [2*SizeY+1];

  //Seeding

  for (int Loop=0; Loop<seed*(SizeX)*(SizeY); Loop++) {
    int xSeedPoint = round(random(-0.5, SizeX+0.5));
    int ySeedPoint = round(random(-0.5, SizeY+0.5));
    if (seedPoints [xSeedPoint] [ySeedPoint] == 0) {
      if ((0 < xSeedPoint && xSeedPoint < SizeX) && (0 < ySeedPoint && ySeedPoint < SizeY)) {
        seedPoints [xSeedPoint] [ySeedPoint] = 2*(Loop+1);
        growPoints [xSeedPoint] [ySeedPoint] = 2*(Loop+1);
        points++;
        //println("added point # " + xSeedPoint + "," + ySeedPoint + " to seed Points");
      } else {
        if ((xSeedPoint==0||xSeedPoint==SizeX)&&(ySeedPoint==0||ySeedPoint==SizeY)) {
          Loop--;
        } else {
          seedPoints [xSeedPoint] [ySeedPoint] = 2*(Loop+1)+1;
          growPoints [xSeedPoint] [ySeedPoint] = 2*(Loop+1)+1;
          edgePoints++;
          // println("added point # " + xSeedPoint + "," + ySeedPoint + " to seed Points");
        }
      }
    } else {
      Loop--;
    }
  }
  //************************************************************************************************************

  //Growing

  while (points<(SizeX-1)*(SizeY-1) || edgePoints<ceil(seed*(SizeX)*(SizeY))) {  
    int i = int(random(0, SizeX+1));
    int I = int(random(0, SizeY+1));
    if (growPoints [i] [I]!=0) {
      //println("");                      
      //1 is up. 2 is right. 3 is down. 4 is left.
      int direction = round(random(0.5, 4.5));
      //i is x pos. I is y pos.
      //println("Hello this is point " + i + "," + I + " and I am trying to grow a point in the direction " + direction);
      int growFrom = growPoints [i] [I];          
      int changeEdge = 0;
      int whatChanged = 0;
      int growTo=0;
      boolean touchingEdge = false;
      boolean exists = false;
      boolean growBranch = false;
      boolean growEnd = false;

      //*******************

      //adding and changing arrays

      switch(direction) {
        //Y-1
      case 1:
        //Does the Point exist            
        if (I>0) {
          exists=true;
          //what is the value of it
          growTo = growPoints [i] [I-1];
          //are you growing into the edge?              
          touchingEdge = I-1==0||i==0||i==SizeX;
        }
        break;
        //x+1
      case 2:
        //Does the Point exist
        if (i<SizeX) {
          exists=true;
          //what is the value of it
          growTo = growPoints [i+1] [I];
          //are you growing into the edge?
          touchingEdge = i+1==SizeX||I==0||I==SizeY;
        }
        break;
        //y+1
      case 3:
        //Does the Point exist
        if (I<SizeY) {
          exists=true;
          //what is the value of it
          growTo = growPoints [i] [I+1];
          //are you growing into the edge?
          touchingEdge = I+1==SizeY||i==0||i==SizeX;
        }
        break;
        //x-1
      case 4:
        //Does the Point exist            
        if (i>0) {
          exists=true;
          //what is the value of it
          growTo = growPoints [i-1] [I];
          //are you growing into the edge?
          touchingEdge = i-1==0||I==0||I==SizeY;
        }
        break;
      }

      if (exists==true) {   
        // println("It exists");
        //Is there not a point where you are trying to go?
        if (growTo == 0) {
          //   println("there is not a point where I am growing to");
          //is it the edge?
          if (touchingEdge==true) {
            // println("I am growing into the edge");
            //is your tree not connected to the edge?
            if (growFrom%2==0) {
              //  println("I am not already connected to the edge");
              //Grow a branch and a end and set tree to touching edge
              growBranch=true;
              //Not needed for Grow End since the point will be stuck in a wall anyway
              growEnd=true;
              changeEdge=growFrom+1;
              whatChanged=growFrom;
              edgePoints++;
            }
            // println("Sadly I am already connected to the edge");
          } else {
            growBranch=true;
            growEnd=true;
            points++;
          }
        } else {
          // println("there is a point where I am growing to");
          //is the point not on the same tree?
          if (growTo != growFrom) {
            // println("The point I am growing to is not on the same tree");
            //is the other tree not connected to the edge?
            if (growTo%2==0) {
              // println("The tree I am growing to is not connected to the edge");
              //Tell the other tree that it is connected to the edge.
              changeEdge=growFrom;
              whatChanged=growTo;
              edgePoints++;
              //Grow a connection but not a new point.
              growBranch=true;
            } else {
              // println("The tree I am growing to is connected to the edge");
              //Are you not connected to the Edge?
              if (growFrom%2==0) {
                // println("I am not connected to the edge");
                //Tell the tree that it is now connected to the edge.
                changeEdge=growTo;
                whatChanged=growFrom;
                edgePoints++;
                //Grow a connection but not a new point.
                growBranch=true;
              }
            }
          }
          // println("Sadly the point is on the same tree");
        }
      }


      //1 is up. 2 is right. 3 is down. 4 is left.
      if (growBranch||growEnd) {
        switch(direction) {
        case 1:                               
          if (growBranch) {
            Connections [i] [2*I-1] = 1;
            // println("made a connection between " + i + "," + I + " and " + i + "," + (I-1));
          }
          if (growEnd) {
            growPoints [i] [I-1] = growFrom;
            //println("made a point at " + i + "," + (I-1));
          }
          break;
        case 2:
          if (growBranch) {
            Connections [i] [2*I] = 1;
            // println("made a connection between " + i + "," + I + " and " + (i+1) + "," + I);
          }
          if (growEnd) {
            growPoints [i+1] [I] = growFrom;
            //println("made a point at " + (i+1) + "," + I);
          }
          break;
        case 3:
          if (growBranch) {
            Connections [i] [2*I+1] = 1;
            // println("made a connection between " + i + "," + I + " and " + i + "," + (I+1));
          }
          if (growEnd) {
            growPoints [i] [I+1] = growFrom;
            //println("made a point at " + i + "," + (I+1));
          }
          break;
        case 4:
          if (growBranch) {
            Connections [i-1] [2*I] = 1;
            // println("made a connection between " + i + "," + I + " and " + (i-1) + "," + I);
          }
          if (growEnd) {
            growPoints [i-1] [I] = growFrom;
            // println("made a point at " + (i-1) + "," + I);
          }
          break;
        }
        //println(edgePoints);
      }
      //**************************
      if (changeEdge != 0) {            
        for (int ix=0; ix<=SizeX; ix++) {
          for (int iy=0; iy<=SizeY; iy++) {
            if (growPoints [ix] [iy] == whatChanged) {
              growPoints [ix] [iy]=changeEdge;
              //if (seedPoints [ix] [ix]==whatChanged) {
              //seedPoints [ix] [iy]=changeEdge;
              //}
            }
          }
        }
        //println("changed tree " + whatChanged + " to " + changeEdge);
      }
    }
  }
  return (Connections);
}
