import de.bezier.guido.*;

final public String InteractiveMethodNames = getInteractiveMethodNames();

private int NUM_ROWS, NUM_COLS, NUM_MINES;
private boolean firstClick;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void settings(){
  size(400, 400);
  NUM_ROWS = 20;
  NUM_COLS = 20;
  NUM_MINES = 80;
}

void setup (){
  background(0);
  stroke(0);
  fill(0);
  textAlign(CENTER,CENTER);
  
  // make the manager
  //Interactive.activate(); //Reenable the GUIDO interface (if needed)
  Interactive.make(this);
  
  mines = new ArrayList<MSButton>();
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  firstClick = true;
  
  for (int j = 0; j < buttons.length; j++){
    for (int i = 0; i < buttons[0].length; i++){
      buttons[j][i] = new MSButton(i, j);
    }
  }
}

public void setMines(int startingCol, int startingRow){
  firstClick = false;
  
  MSButton randMine;
  int randRow, randCol;
  int[][] usedCoordinates = new int[NUM_MINES + 9][2];
  
  int iteration = 0;
  for (int j = 0; j < 3; j++){
    for (int i = 0; i < 3; i++){
      usedCoordinates[iteration][0] = startingCol - 1 + i;
      usedCoordinates[iteration][1] = startingRow - 1 + j;
      iteration++;
    }
  }
  
  for (int i = 0; i < NUM_MINES; i++){
    randCol = (int)(Math.random()*NUM_COLS);
    randRow = (int)(Math.random()*NUM_ROWS);
    
    while (containsCoord(usedCoordinates, randCol, randRow)){
      randCol = (int)(Math.random()*NUM_COLS);
      randRow = (int)(Math.random()*NUM_ROWS);
    }
    
    usedCoordinates[9 + i][0] = randCol;
    usedCoordinates[9 + i][1] = randRow;
    randMine = new MSButton(randCol, randRow);
    
    mines.add(randMine);
  }
}

public void draw(){
  background(0);
  if(isWon() == true){
    displayWinningMessage();
  }
}

public boolean isWon(){
  for (int j = 0; j < buttons.length; j++){
    for (int i = 0; i < buttons[0].length; i++){
      if (!buttons[j][i].isClicked()){
        return false;
      }
    }
  }
  return true;
}

public void keyPressed(){
  if (key == 'r'){
    loop();
    setup();
  }
}

public void displayLosingMessage(){
  //Interactive.deactivate(); //Disable the GUIDO interface to allow drawing on top of the GUIDO interface
  background(0);
  stroke(255);
  fill(255);
  text("YOU LOST!", width/2, height/2);
  //System.out.println("YOU LOST!"); 
  noLoop();
}

public void displayWinningMessage(){
  //Interactive.deactivate(); //Disable the GUIDO interface to allow drawing on top of the GUIDO interface
  background(0);
  stroke(255);
  fill(255);
  text("YOU WON!", width/2, height/2);
  //System.out.println("YOU WON!");
  noLoop();
}

public boolean isValid(int c, int r){
  return (r >= 0 && r < NUM_ROWS) && (c >= 0 && c < NUM_COLS);
}

public int countMines(int col, int row){
  int count = 0;
  float mineCol, mineRow;
  for (int i = 0; i < mines.size(); i++){
    mineCol = mines.get(i).getMyCol();
    mineRow = mines.get(i).getMyRow();
    
    if ((mineCol >= col - 1 && mineCol <= col + 1) && (mineRow >= row - 1 && mineRow <= row + 1)){
      count++;
    }
  }
  
  return count;
}

public boolean containsCoord(int[][] coordList, int col, int row){
  for (int i = 0; i < coordList.length; i++){
    if (coordList[i][0] == col && coordList[i][1] == row){
      return true;
    }
  }
  
  return false;
}

public class MSButton{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  
  public MSButton(int col, int row){
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add(this); // register it with the manager
  }

  // called by manager
  public void mousePressed(){
    clicked = true;
    int neighboringMinesCount = countMines(myCol, myRow);
    
    if (mouseButton == RIGHT){
      flagged = !flagged;
      
      if (!flagged){
          clicked = false;
      }
      return;
    }
    
    if (flagged){
      return;
    }
    
    if (firstClick){
      setMines(myCol, myRow);
    }
    
    if (mines.contains(this)){
      displayLosingMessage();
      return;
    }
    
    if (neighboringMinesCount > 0){
      setLabel(neighboringMinesCount);
      return;
    }
    
    MSButton buttonObject;
    for (int j = myRow - 1; j < myRow + 2; j++){
      for (int i = myCol - 1; i < myCol + 2; i++){
        if (!isValid(i, j)){
          continue;
        }
        buttonObject = buttons[j][i];
        if (!buttonObject.isClicked() && !buttonObject.isFlagged()){
          buttonObject.mousePressed();
        }
      }
    }
  }
  
  public void draw(){    
    if (flagged){
        fill(0);
        rect(x, y, width, height);
        text(myLabel, x + width, y + height);
    } else if (clicked){
        fill(200);
        rect(x, y, width, height);
        fill(0);
        text(myLabel, x + width/2, y + height/2);
    } else {
        fill(100);
        rect(x, y, width, height);
        fill(0);
        text(myLabel, x + width/2, y + height/2);
    }
  }
  
  public void setLabel(String newLabel){
    myLabel = newLabel;
  }
  
  public void setLabel(int newLabel){
    myLabel = "" + newLabel;
  }
  
  public boolean isFlagged(){
    return flagged;
  }
  
  public boolean isClicked(){
    return clicked;
  }
  
  public int getMyCol(){
    return myCol;
  }
  
  public int getMyRow(){
    return myRow;
  }
  
  public float getX(){
    return x;
  }
  
  public float getY(){
    return y;
  }
  
  public float getMyWidth(){
    return width;
  }
  
  public float getMyHeight(){
    return height;
  }
  
  public String toString(){
    return "(" + myCol + ", " + myRow + ")";
  }
}

//For debugging
public String getInteractiveMethodNames(){
  java.lang.reflect.Method[] methodList = Interactive.class.getMethods(); //Get references to the public methods in the Interactive class
  
  //Shove all the names into one string
  String names = new String();
  for (int i = 0; i < methodList.length; i++){
    if (i == methodList.length - 1){
      names += methodList[i].toString();
    } else { 
      names += methodList[i].toString() + "\n";
    }
  }
  
  return names;
}
