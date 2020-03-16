int [] [] SolveMaze() {

  
  int [] [] connect = new int [SizeX+1] [2*SizeY+1] ;
  for(int x=0;x<SizeX+1;x++){
    for(int y=0;y<2*SizeY+1;y++){
      connect [x] [y] = connections [x] [y];
    }        
  }
  
  
  
  //println();
  //println("Solving new" , SizeX , "X" , SizeY);
  
  for(int x=0;x<SizeX;x++){
    connect [x] [0]=1;
    connect [x] [2*SizeY]=1;
  }
  
  for(int y=0;y<SizeY;y++){
    connect [0] [2*y+1]=1;
    connect [SizeX] [2*y+1]=1;
  }

  IntList travelDirection = new IntList (1);
  boolean atEnd = false;
  int currentX=0;
  int currentY=0;
  int directionFrom=0;

  while (atEnd==false) {
    
    //println(currentX , currentY);
    //println(travelDirection);
        //sees what options there are to move
    //1
    boolean Up = connect [currentX] [2*currentY]==0 && directionFrom != 3;
    //3
    boolean Down = connect [currentX] [2*currentY+2]==0 && directionFrom != 1;
    //4
    boolean Left = connect [currentX] [2*currentY+1]==0 && directionFrom != 2;
    //2
    boolean Right = connect [currentX+1] [2*currentY+1]==0  && directionFrom != 4;
    
      //println("Going ");
    if (Up) {
      travelDirection.reverse();
      travelDirection.append(1);
      travelDirection.reverse();
      directionFrom = 1;
      currentY--;
      //println("Up");
    } else if (Down) {
      travelDirection.reverse();
      travelDirection.append(3);
      travelDirection.reverse();
      directionFrom = 3;
      currentY++;
     // println("Down");
    } else if (Left) {
      travelDirection.reverse();
      travelDirection.append(4);
      travelDirection.reverse();
      directionFrom = 4;
      currentX--;
      //println("Left");
    } else if (Right) {
      travelDirection.reverse();
      travelDirection.append(2);
      travelDirection.reverse();
      directionFrom = 2;
      currentX++;
      //println("Right");
    } else {
      //println("Turn Around");
      //Turn Around there is a wall
      switch(travelDirection.get(0)) {
        case(1):        
        //println("Turn around Down");
        currentY++;
        connect [currentX] [2*currentY]=1;
        break;
        case(2):      
        //println("Turn around Right");
        currentX--;
        connect [currentX+1] [2*currentY+1]=1;        
        break;
        case(3):
        //println("Turn around Up");
        currentY--;
        connect [currentX] [2*currentY+2]=1;        
        break;
        case(4):  
        //println("Turn around Left");
        currentX++;
        connect [currentX] [2*currentY+1]=1;        
        break;
      }
      if(currentX==0 && currentY ==0){
      directionFrom=0;      
      //println("Back At The Start");
      }else{
      directionFrom=travelDirection.get(1);
      }
      travelDirection.remove(0);
    }   
    if(currentX==SizeX-1 && currentY==SizeY-1){
      println("Solved");
      atEnd=true;
    }     
  }
  
  
  
  
  IntList PathX = new IntList(0);
  IntList PathY = new IntList(0); 
  atEnd=false;
  travelDirection.reverse();
  //println();
  //println("Up:3 Down:1 Left:4 Right:2");
  //println();
  //travelDirection.print();
  //println();
  currentX=0;
  currentY=0;
  for(int t =0;t<travelDirection.size();t++){
  switch(travelDirection.get(t)){
    case(1):
    currentY--;
    break;
    case(2):
    currentX++;
    break;
    case(3):
    currentY++;
    break;
    case(4):
    currentX--;
    break;        
  }
  PathX.append(currentX);
  PathY.append(currentY);
  }

  //println("The Path X Is");
  //PathX.print();
  //println("The Path Y Is");
  //PathY.print();

int [] [] Path = new int [PathX.size()] [2];

for(int x=0;x<PathX.size();x++){
    Path [x] [0] = PathX.get(x);
}
for(int y=0;y<PathY.size();y++){
    Path [y] [1] = PathY.get(y); 
}


  return(Path);
}
