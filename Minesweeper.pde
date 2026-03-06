import de.bezier.guido.*;

private int NUM_ROWS = 10;
private int NUM_COLS = 10;
private int NUM_MINES = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup (){
  size(400, 400);
  textAlign(CENTER,CENTER);
  
  // make the manager
  Interactive.make(this);
  
  mines = new ArrayList<MSButton>(); 
  
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int j = 0; j < buttons.length; j++){
    for (int i = 0; i < buttons[0].length; i++){
      buttons[j][i] = new MSButton(i, j);
    }
  }
  
  
  setMines();
}

public void setMines(){
  MSButton randMine;
  int randRow, randCol;
  int[][] usedCoordinates = new int[NUM_MINES][2];
  for (int i = 0; i < NUM_MINES; i++){
    randRow = (int)(Math.random()*NUM_ROWS);
    randCol = (int)(Math.random()*NUM_COLS);
    
    while (containsCoord(usedCoordinates, randCol, randRow)){
      randCol = (int)(Math.random()*NUM_COLS);
      randRow = (int)(Math.random()*NUM_ROWS);
    }
      
    usedCoordinates[i][0] = randCol;
    usedCoordinates[i][1] = randRow;
    randMine = new MSButton(randRow, randCol);
      
    mines.add(randMine);
  }
}

public void draw(){
  background( 0 );
  if(isWon() == true){
    displayWinningMessage();
  }
}

public boolean isWon(){
  return false;
}

public void displayLosingMessage(){
  System.out.println("YOU LOST!");
}

public void displayWinningMessage(){
  System.out.println("YOU WON!");
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
    int neighboringMinesCount = countMines(myCol, myRow);
    
    clicked = true;
    
    if (mouseButton == RIGHT){
      flagged = !flagged;
      
      if (!flagged){
        clicked = false;
      }
    } else if (mines.contains(this)){
      displayLosingMessage();
    } else if (neighboringMinesCount > 0){
      setLabel(neighboringMinesCount);
    } else {
      for (int j = myRow - 1; j < myRow + 2; j++){
        for (int i = myCol - 1; i < myCol + 2; i++){
          if (isValid(i, j) && (i != myCol && j != myRow)){
            buttons[j][i].mousePressed();
          }
        }
      }
    }
  }
  
  public void draw(){    
    if (flagged)
        fill(0);
    else if (mines.contains(this)) //else if (clicked && mines.contains(this))
         fill(255,0,0);
    else if (clicked)
        fill(200);
    else 
        fill(100);

    rect(x, y, width, height);
    fill(0);
    text(myLabel,x+width/2,y+height/2);
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
  
  public int getMyCol(){
    return myCol;
  }
  
  public int getMyRow(){
    return myRow;
  }
  
  public String toString(){
    return "(" + x + ", " + y + ")";
  }
}
