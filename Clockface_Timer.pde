//Global Variables
int cx, cy;               //coordinates for center of timer face
float secondsRadius;      //distance from center to outer face 
float clockDiameter;      
float angle;              //holds angle from radian conversion
float radius = 0;          

int firstSec = 0;         //for second timing logic
float counter = 360;      //starting value for second timer
float tempCounter = 0;    //for holding time during pause

boolean startTimer = false;
boolean pause = false;

//colors for text
color startColor = color(255);
color resetColor = color(255);
color pauseColor = color(255);
color resumeColor = color(255);
color plusColor = color(255);
color minusColor = color(255);

//colors for status indicators
color goColor = color(255);
color holdColor = color(255);

//logic for timer progression
boolean started = false;
boolean holdCounter = false;

int heightAdjust = 30; //offset centering (y)
int widthAdjust = 12;  //offset centering (x)

int shiftNumsX = -43;  //shift clockface numbers horizontally
int shiftNumsY = 22;   //shift clockface number vertially
float numMult = 0.68;  //distance from center multiplier -> based on clock face radius
int fontSize = 60;     //clockface number font size

int dialStrokeWeight = 4;


/***************************************************************
** Setup: Function sets window/clock dimension 
** parameters and framerate 
***************************************************************/
void setup() {
  size(displayWidth, displayHeight);
  stroke(255);
  
  //determine clock's radius based on the shorter (w vs h)
  int radius = min(width, height) / 2;
  
  secondsRadius = radius;  
  clockDiameter = radius * 1.8;
  
  //determine center x,y coordinates with offsets 
  cx = (width / 2) - widthAdjust;
  cy = (height / 2) - heightAdjust;
  
  frameRate(30);
}


/******************************************************
** Draw:  Main Loop function for clock timer
*******************************************************/
void draw() {
  background(255);
      
  HandleTextColors();
  HandleControls();

  strokeCap(SQUARE);
  DrawMinuteMarks();
  DrawBoldMinuteMarks();
  DrawNumbers();
  DrawDial();
  
  //start and handle timer
  if (startTimer)
  {
    DrawCountdown();
    DrawMinuteMarks();
    DrawBoldMinuteMarks();
    DrawNumbers();
    DrawDial();
  }
  
  noFill();
  stroke(255);
  strokeWeight(70);
  ellipse(cx, cy, radius*1.9, radius*1.9);    //create outer boundary for face (white border)
  
  fill(0);
  strokeWeight(10);
  DrawButtons();
}


/*******************************************************
* Function handles countdown animation for timer
*******************************************************/
void DrawCountdown()
{
  noFill();
  stroke(255,255,255,180);
  strokeWeight(32);
  strokeCap(SQUARE);
  
  //handles second counting
  if (firstSec != second())
  {
    //Either hold last second or progress through timer
    if (holdCounter) 
    {
      counter = tempCounter; 
    } else {
    counter = counter-0.1; //for proper animation of second passing within a single timing cycle
    }
  }
  firstSec = second();    //hold internal clocks second timer for timing logic
  
  //create full red circle
  arc(cx, cy, radius * 1.685, radius * 1.685, 0 - HALF_PI, (radians(360)) - HALF_PI);
  
  strokeWeight(40);
  stroke(255,0,0);
  
  //create partially completed circle based on passed seconds
  arc(cx, cy, radius * 1.685, radius * 1.685, 0 - HALF_PI, (radians(360-counter)) - HALF_PI);
}


/*******************************************************
* Function draws minute tick marks on timer face
*******************************************************/
void DrawMinuteMarks()
{
  //smallest of width and height
  radius = min(width, height) / 2;
  
  stroke(0);
  strokeWeight(5);

  //draw minute Marks
  for (int a = 0; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    
    line(x, y, cx, cy);
  }
}


/*******************************************************
* Function draws bold 5 minute increment tick marks
*******************************************************/
void DrawBoldMinuteMarks()
{
  stroke(0);
  strokeWeight(16);
  
  //bold minute marks
  for (int a = 0; a < 360; a+=30) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    
    line(x, y, cx, cy);
  }
  
  fill(255);
  noStroke();
  
  //create white inner circle for clock face
  ellipse(cx, cy, radius*1.6, radius*1.6);
}

/*******************************************************
* Function draws numbers for timer face
*******************************************************/
void DrawNumbers()
{
  noStroke();
  ellipse(cx, cy, radius*1.35, radius*1.35);
  
  textSize(fontSize);
  fill(0);
  /*text("60", displayWidth*0.45, displayHeight*0.304); 
  text("30", displayWidth*0.451, displayHeight*0.695);
  text("15", displayWidth*0.786, displayHeight*0.501);
  text("45", displayWidth*0.11, displayHeight*0.501);*/
  
  text("60", cx + shiftNumsX, cy - (radius * numMult) + shiftNumsY); 
  text("30", cx + shiftNumsX, cy + (radius * numMult) + shiftNumsY);
  text("15", cx - (radius * numMult) + shiftNumsX, cy + shiftNumsY);
  text("45", cx + (radius * numMult) + shiftNumsX, cy + shiftNumsY);
}

/*******************************************************
* Function draws buttons
*******************************************************/
void DrawButtons()
{
  fill(0);
  stroke(0);
  rect(20,20,100,40);
  rect(20,80,100,40);
  rect(20,160,100,40);
  rect(20,220,100,40);
  
  rect(20,300,100,40);
  rect(20,360,100,40);
  
  textSize(30);
  fill(startColor);
  text("start", 39, 50);
  fill(resetColor);
  text("reset", 37, 109); 
  fill(pauseColor);
  text("pause", 31, 189); 
  
  textSize(27);
  fill(resumeColor);
  text("resume", 27, 248); 
  
  fill(plusColor);
  text("+ Sec", 27, 328);
  fill(minusColor);
  text("- Sec", 27, 387);
  
  strokeWeight(10);
  fill(goColor);
  ellipse(160, 40, 40, 40);
  fill(holdColor);
  ellipse(160, 180, 40, 40);
}

/******************************************************************
* Function handles the change of text color during mouse rollover
*******************************************************************/
void HandleTextColors()
{
   //changes text color of start button
  if (mouseX > 20 && mouseX < 120 && mouseY > 20 && mouseY < 60){
    startColor = color(128);
  } else {
    startColor = color(255);
  }
  
  //changes text color of reset button
  if (mouseX > 20 && mouseX < 120 && mouseY > 80 && mouseY < 120)
  {
    resetColor = color(128);
  } else {
    resetColor = color(255); 
  }
  
  //changes text color of pause button
  if (mouseX > 20 && mouseX < 120 && mouseY > 160 && mouseY < 200)
  {
    pauseColor = color(128);
  } else {
    pauseColor = color(255); 
  }
  
  //changes text color of resume
  if (mouseX > 20 && mouseX < 120 && mouseY > 220 && mouseY < 260)
  {
    resumeColor = color(128);
  } else {
    resumeColor = color(255); 
  } 
  
  //changes text color of +Sec
  if (mouseX > 20 && mouseX < 120 && mouseY > 300 && mouseY < 340)
  {
    plusColor = color(128);
  } else {
    plusColor = color(255); 
  }
  
  //changes text color of -Sec
  if (mouseX > 20 && mouseX < 120 && mouseY > 360 && mouseY < 400)
  {
    minusColor = color(128);
  } else {
    minusColor = color(255); 
  } 
}

/*********************************************************
* Function handles timer controls and visual indicators
*********************************************************/
void HandleControls()
{
   //triggers time start, changes start text color, start circle color (green) 
  if (mousePressed == true && mouseX > 20 && mouseX < 120 && mouseY > 20 && mouseY < 60) {
    startTimer = true;              //enter timer sequence
    startColor = color(0, 255, 0);
    
    //trigger green light if yellow (hold) light is not active
    if (holdColor != color(255,255,0)){
      goColor = color(0, 255, 0);
    }
    started = true;  //flag (logic) for indicating the triggering of timer 
  }  
  
  // resets timer, changes reset text color, start circle color (white), start resume color (white)
  if (mousePressed == true && mouseX > 20 && mouseX < 120 && mouseY > 80 && mouseY < 120) {
    holdCounter = false;          //flag for inactive pause 
    counter = 360;                //reset to 60 minutes
    startTimer = false;           //flag for inactive timer 
    goColor = color(255);         
    holdColor = color(255);       
    resetColor = color(255,0,0);  
    
    started = false;              //flag for inactive timer
  }  
  
  //changes pause text color, pause circle color (yellow), start circle color (white), and pauses timer
  if (mousePressed == true && mouseX > 20 && mouseX < 120 && mouseY > 160 && mouseY < 200)
  {
    pauseColor = color(255, 255, 0);
    
    if (goColor == color(0, 255, 0)) {
      holdColor = color(255, 255, 0);
      tempCounter = counter;            //grab current time to maintain value during pause
      holdCounter = true;               //flag logic to maintain last grabbed time
    }
    
    goColor = color(255); 
} 
  
  //changes resume text color, pause circle color (white), and resumes timer
  if (mousePressed == true && mouseX > 20 && mouseX < 120 && mouseY > 220 && mouseY < 260)
  {
    resumeColor = color(0, 255, 0);
    holdColor = color(255);
    
    if (started) {
      goColor = color(0, 255, 0);
      holdCounter = false;              //flag for resuming counter
    }
  }  
  
  //changes +Sec text color and handles timer increment 
  if (mousePressed == true && mouseX > 20 && mouseX < 120 && mouseY > 300 && mouseY < 340)
  {
    if (startTimer)
    {
      counter -= 0.1;
      tempCounter -= 0.1;
    
      if (counter < 0)
      {
        counter = 0;
      }
      
      if (tempCounter < 0)
      {
        tempCounter = 0; 
      }
    }
  }    
  
  //changes -Sec text color and handles timer decrement 
  if (mousePressed == true && mouseX > 20 && mouseX < 120 && mouseY > 360 && mouseY < 400)
  {
    if (startTimer)
    {
      counter += 0.1;
      tempCounter += 0.1;

      if (counter > 360)
      {
        counter = 360; 
      }
      
      if (tempCounter > 360)
      {
        tempCounter = 360; 
      }
    }
  }   
}

void DrawDial()
{
  ellipse(cx,cy, 20, 20);
  stroke(0);
  strokeWeight(dialStrokeWeight);
  fill(0);

  if (counter <= 360 && counter > 0)
  {
    strokeWeight(dialStrokeWeight);
    
    //seconds
    pushMatrix();
    translate(cx,cy);
    rotate(radians(360-((counter * 60))));
    line(0, 0, 0, (-radius * numMult) - 8);
    triangle(-5, (-radius * numMult - 8), 0, (-radius * numMult) - 28, 5, (-radius * numMult - 8));
    popMatrix();
    
    //seconds
    pushMatrix();
    translate(cx,cy);
    rotate(radians(360-(counter)));
    line(0, 0, 0, (-radius * numMult * 0.75));
    triangle(-5, (-radius * numMult * 0.75), 0, (-radius * numMult * 0.75) - 20, 5, (-radius * numMult * 0.75));
    popMatrix();
  }
  else
  {
    pushMatrix();
    translate(cx,cy);
    line(0, 0, 0, (-radius * numMult) - 8);
    triangle(-5, (-radius * numMult - 8), 0, (-radius * numMult) - 28, 5, (-radius * numMult - 8));
    popMatrix();
    
    pushMatrix();
    translate(cx,cy);
    line(0, 0, 0, (-radius * numMult * 0.75));
    triangle(-5, (-radius * numMult * 0.75), 0, (-radius * numMult * 0.75) - 20, 5, (-radius * numMult * 0.75));
    popMatrix();
  }
  
  println(counter);
}
