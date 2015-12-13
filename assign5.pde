/* 
the latest version  
edited in 2015/12/13 10:07PM
fix HP bar display bug
*/ 

  final int GAME_START = 0;
  final int GAME_RUN = 1;
  final int GAME_LOSE = 2;
  int gameState;
  
  final int PART1 = 0;
  final int PART2 = 1;
  final int PART3 = 2;
  int enemyPart;
  
  //position setting
  float x=0, y=0;
  float treasureX, treasureY;
  float enemyY = floor(random(40,219));
  float percentage, hpWeightX, hpWeightY; 
  float spacingX = 80, spacingY = 50;
  float indexOne, indexTwo;
  float treasureDist;
  float [][] enemyP1 = new float [5][2];
  float [][] enemyP2 = new float [5][2];
  float [][] enemyP3 = new float [8][2];
  
  //text setting
  int newScore = 0;
  
  //flame
  int flamesNum = 0;
  int currentFrame = 0;
  PImage [] flames = new PImage [5];
  float flamePos [][] = new float [8][2]; 
  
  // key press moving for jet flying
  float speed = 5;
  float jetX = 580; 
  float jetY = 240;
  float jetH = 51;
  float jetW = 51;
  
  //shooting
  int bulletCount = 0;
  float [][] bulletPos = new float [8][2];
  boolean [] isShoot = new boolean[5];
  
  boolean enemySwitch = false;
  boolean upPressed = false;
  boolean downPressed = false;
  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean enterPressed = false;
  
  //loading image
  PImage enemy, jet, hpBar, treasure, bgOne, bgTwo, end, endHover, start, startHover, bullet; 
  
  
void setup () {
  size(640,480) ;  
  background(255);
  
  //loading images
  bgOne      = loadImage("img/bg1.png");
  bgTwo      = loadImage("img/bg2.png");
  jet        = loadImage("img/fighter.png");
  hpBar      = loadImage("img/hp.png");
  treasure   = loadImage("img/treasure.png");
  enemy      = loadImage("img/enemy.png");
  end        = loadImage("img/end2.png");
  endHover   = loadImage("img/end1.png");
  start      = loadImage("img/start2.png");
  startHover = loadImage("img/start1.png");
  bullet     = loadImage("img/shoot.png");

  //loading flame images
  for(int f=0; f<flames.length; f++){
    String imageName = "img/flame" + (f+1) + ".png";
    flames[f] = loadImage(imageName);
  }
  
  //set flames position away out of window
  for(int r = 0; r < flamePos.length; r++ ){
    flamePos[r][0] = 9999;
    flamePos[r][1] = 9999;
  }
  
  //set bullet state to false
  for(int r=0; r < isShoot.length; r++){
    isShoot[r] = false;
  }
  
  //X, Y setting for background
  indexOne = width;
  indexTwo = 0;
  
  //treasure
  treasureX = floor(random(200,550));
  treasureY = floor(random(40,430));
  
  //set HP Bar percentage
  percentage = 2;
  hpWeightX = percentage * 20;
  hpWeightY = 30;
  
  //set initial gameState in start;
  gameState = GAME_START;
  
  //set enemy part 1 position
  enemyPart = PART1;
  enemyY = floor(random(40, 219));    
  for (int i = 0; i < 5; i++){
   enemyP1 [i][0] = -51 + (-spacingX)*i;
   enemyP1 [i][1] = enemyY; 
  }
  
}

void draw() {
  background(255);
  
  switch (gameState){
    
    case GAME_START:
      //reset HP bar
      hpWeightX = percentage * 20;
      image(start, x, y);
      
      //reset jet x y position
      jetX = 580; 
      jetY = 240;
      
      //reset treasure position in random X asix and Y asix
      treasureX = floor(random(200,550));
      treasureY = floor(random(40,430));
      
      //mouse action and hover on start background 
      if (mouseY > 370 && mouseY < 420){
        if(mouseX > 200 && mouseX < 470){
          //start button hovered
          image(startHover, x, y);
            if (mousePressed){
            //click to start
            gameState = GAME_RUN;        
            }
          }
        }
      break;
      
    case GAME_RUN:
      //infinite looping background
      image(bgOne, indexOne - width, 0);
      image(bgTwo, indexTwo - width, 0);
      indexOne++;
      indexTwo++;
      indexOne %= width*2;
      indexTwo %= width*2;

      //text
      textSize(28);
      fill(200);
      text("Score: " + newScore, 15, 460);  

      //jet moving
       if (upPressed) 
         jetY -= speed;
       if (downPressed) 
         jetY += speed;
       if (leftPressed) 
         jetX -= speed;
       if (rightPressed) 
         jetX += speed;
       
      //boundary detection
      if( jetX > width - jetW){jetX  = width - jetW;}
      if( jetX < 0 ){jetX = 0;}
      if( jetY > height - jetH){jetY = height - jetH;}
      if( jetY < 0){jetY = 0;}
      
      //enemy
      switch(enemyPart){
     
      case PART1:  
      
      enemySwitch = false;
      
      //part 1: a line of 5 enemys 
      for(int i=0; i<5; i++){
        image(enemy, enemyP1[i][0], enemyP1[i][1]);
        enemyP1[i][0] += speed;
        
        //enemy touched jet
        if(isHit(enemyP1[i][0], enemyP1[i][1], 61, 61, jetX, jetY, 51, 51) == true){
          for(int q=0; q<5; q++){
            flamePos[q][0] = enemyP1[i][0];
            flamePos[q][1] = enemyP1[i][1];
          }
          hpWeightX = hpWeightX - percentage*20;
          enemyP1[i][0] = -9999;
          enemyP1[i][1] = floor(random(40,219));
          flamesNum = 0;
        }
        
        //bullet shooting enemy
        if(isHit(bulletPos[i][0], bulletPos[i][1], 31, 27, enemyP1[i][0], enemyP1[i][1], 61, 61) == true){
          {
            for(int q=0; q<5; q++){
              flamePos[q][0] = enemyP1[i][0];
              flamePos[q][1] = enemyP1[i][1];
            }
            newScore = scoreChange(20);
            enemyP1[i][0] = -9999;
            enemyP1[i][1] = enemyY = floor(random(40,219));
            isShoot[i] = false;
            flamesNum = 0;
          }
        }
        
        if(enemyP1[i][0] > width+550){
          enemyY = random(40, 219);
          for(int k=0; k<5; k++){
            int lineCount = 4-k;
            enemyP2[k][0] = -500 + spacingX * k;
            enemyP2[k][1] = enemyY + spacingY*lineCount;
          }
          enemyPart = PART2;
        } 
    
        if(enemyP1[0][0]<=-1000 && enemyP1[1][0]<=-1000 && enemyP1[2][0]<=-1000 && enemyP1[3][0]<=-1000 && enemyP1[4][0]<=-1000){
          enemyY = random(40, 219);
          for(int k=0; k<5; k++){
            int lineCount = 4-k;
            enemyP2[k][0] = -500 + spacingX * k;
            enemyP2[k][1] = enemyY + spacingY*lineCount;
          }
          enemyPart = PART2;
        }
      }
        
      break;
      
      //part 2: lineslash enemys
      
      case PART2:
      
      for(int i=0; i<5; i++){
        image(enemy, enemyP2[i][0], enemyP2[i][1]);
        enemyP2[i][0] += speed;
        
        //enemy touched jet
        if(isHit(enemyP2[i][0], enemyP2[i][1], 61, 61, jetX, jetY, 51, 51) == true){
          for(int q = 0; q < 5; q++){
            flamePos[q][0] = enemyP2[i][0];
            flamePos[q][1] = enemyP2[i][1];
          }
          hpWeightX = hpWeightX - percentage*20;
          enemyP2[i][0] = -9999;
        }
        
        //bullet shooting enemy
        if(isHit(bulletPos[i][0], bulletPos[i][1], 31, 27, enemyP2[i][0], enemyP2[i][1], 61, 61) == true){
          if(isShoot[i] == true){
            for(int q=0; q<5; q++){
              flamePos[q][0] = enemyP2[i][0];
              flamePos[q][1] = enemyP2[i][1];
            }
              newScore = scoreChange(20);
              enemyP2[i][0] = -9999;
              enemyP2[i][1] = enemyY = floor(random(40,219));
              isShoot[i] = false;
              flamesNum = 0;
          }
        }
          
       if(enemyP2[i][0] > width+550){
         enemyY = random(40, 219);
         for(int k=0; k<8; k++){
           int count = abs(2-k); 
           if(k<5){
             enemyP3[k][0] = -500 + spacingX*k;
             enemyP3[k][1] = enemyY+spacingY*count;
           }
          
           if(k >= 5 && k < 8){
             enemyP3[k][0] = -500 + spacingX*(k-4);
             enemyP3[5][1] = enemyY+spacingY*3;
             enemyP3[6][1] = enemyY+spacingY*4;
             enemyP3[7][1] = enemyY+spacingY*3;
           } 
         }
         enemyPart = PART3;
         
       } 
    
       if(enemyP2[1][0]<=-1000 && enemyP2[1][0]<=-1000 && enemyP2[2][0]<=-1000 && enemyP2[3][0]<=-1000 && enemyP2[4][0]<=-1000){
         enemyY = random(40, 219);
         for(int k=0; k<8; k++){
           int count = abs(2-k); 
           if(k < 5){
             enemyP3[k][0] = -500 + spacingX*k;
             enemyP3[k][1] = enemyY+spacingY*count;
           }
          
           if(k >= 5 && k < 8){
             enemyP3[k][0] = -500 + spacingX*(k-4);
             enemyP3[5][1] = enemyY+spacingY*3;
             enemyP3[6][1] = enemyY+spacingY*4;
             enemyP3[7][1] = enemyY+spacingY*3;
           } 
          }
         enemyPart = PART3;
       }  
      }
      break;
      
      //part 3: a square enemys
      
      case PART3:
      
      for(int i = 0; i < 8 ; i++){
        image(enemy, enemyP3[i][0], enemyP3[i][1]);
        enemyP3[i][0] += speed;
    
      //enemy touched jet
      if(isHit(enemyP3[i][0], enemyP3[i][1], 61, 61, jetX, jetY, 51, 51) == true){
        for(int q = 0 ; q < 8 ; q++){
          flamePos[q][0] = enemyP3[i][0];
          flamePos[q][1] = enemyP3[i][1];
        }
          enemyP3[i][0] = -9999;
          hpWeightX = hpWeightX - percentage*20;
      }
      
       //bullet shooting enemy
        if(isHit(bulletPos[i][0], bulletPos[i][1], 31, 27, enemyP3[i][0], enemyP3[i][1], 61, 61) == true){
          if(isShoot[i] == true){
            for(int q = 0; q < 8; q ++){
              flamePos[q][0] = enemyP3[i][0];
              flamePos[q][1] = enemyP3[i][1];
            }
            newScore = scoreChange(20);
            enemyP3[i][0] = -9999;
            enemyP3[i][1] = enemyY = floor(random(40,219));
            isShoot[i] = false;
            flamesNum = 0;
          }
        }
      
       if(enemyP3[i][0] > width+550){
         enemyY = random(40, 219); 
         for (int j = 0; j < 5; j++){
           enemyP1 [j][0] = -500 + spacingX*j;
           enemyP1 [j][1] = enemyY; 
         }
           enemyPart = PART1;
       } 
    
       if(enemyP3[1][0]<=-1000 && enemyP3[1][0]<=-1000 && enemyP3[2][0]<=-1000 && enemyP3[3][0]<=-1000 && enemyP3[4][0]<=-1000
          && enemyP3[5][0]<=-1000 && enemyP3[6][0]<=-1000 && enemyP3[7][0]<=-1000){
       
          enemyY = random(40, 219); 
          for (int j = 0; j < 5; j++){
            enemyP1 [i][0] = -51 + (-spacingX)*j;
            enemyP1 [j][1] = enemyY; 
          }
          enemyPart = PART1;
       }
      }
       
      break;
    }
      
      //shooting bullet
      for(int i = 0; i < isShoot.length; i++){
       if(isShoot[i] == true){
         image(bullet, bulletPos[i][0], bulletPos[i][1]);
         bulletPos[i][0] -= 4;
       }
       if(bulletPos[i][0] < -27){
         isShoot[i] = false;
         bulletPos[i][0] = 9999;
       }
     }
      
      //flames
      image(flames[currentFrame],flamePos[currentFrame][0],flamePos[currentFrame][1]);
      flamesNum ++ ;
      if( flamesNum % 6 == 0){
         currentFrame ++ ;
      }
      if(currentFrame > 4){
        currentFrame = 0;
      }
      if(flamesNum > 31){
        for(int i =0; i <5; i++){
          flamePos[i][0] = 9999;
          flamePos[i][1] = 9999;
          flamesNum = 0;
        }
      }
      
      //treasure detection
      //treasureDist = dist(jetX, jetY, treasureX, treasureY);
      if (isHit(treasureX, treasureY, 41, 41, jetX, jetY, 51, 51) == true){
        hpWeightX += (percentage*10); //hp bar up 10 point
        
        //set HP bar maximus 
        if(hpWeightX >= 200){hpWeightX = 200;}
        if(hpWeightX < 0){hpWeightX = 0;}
        
        //reset treasure random X, Y-axis
        treasureX = floor(random(200,550));
        treasureY = floor(random(40,430));
      }
      
      //treasure
      image(treasure, treasureX, treasureY);
      
      //jet
      image(jet, jetX, jetY);
      
      //HP bar
      fill(#FF0000);
      noStroke();
      rect(6, y, hpWeightX, hpWeightY);
      image(hpBar, x, y);
      
      //game lose
      if (hpWeightX <= 0){
        gameState = GAME_LOSE;
      }
      break;
    
    case GAME_LOSE:
      
      //reset enemy part 1 position
      enemyPart = PART1;
      enemyY = floor(random(40, 219));  
      
      for (int i = 0; i < 5; i++){
        enemyP1 [i][0] = -500 + spacingX*i;
        enemyP1 [i][1] = enemyY; 
        bulletPos[i][0] = 9999;
        bulletPos[i][1] = 9999;
        isShoot[i] = false;
      }
      
      newScore = 0;
      hpWeightX = percentage * 20;
      jetX = 580;
      jetY = 240;
      
      for(int r = 0; r < flamePos.length; r++ ){
          flamePos[r][0] = 9999;
          flamePos[r][1] = 9999;
      }
      
      image(end, x, y);

      //mouse action and hover on start bg
      
      if (mouseY > 300 && mouseY < 350){
        image(endHover, x, y);
        if (mousePressed){
          //click to start
          gameState = GAME_RUN; 
          enemyPart = PART1;
        }
      }
     
     break;
     
  }//switch(gameState)
}//draw()

//setting keypress boolean action

void keyPressed(){
  if (key == CODED && gameState == GAME_RUN) { 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
      case ENTER:
        enterPressed = true;
        break;
    }
  }
}

void keyReleased(){
    if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      case ENTER:
        enterPressed = false;
        break;
    }
  }
  
  //shooting bullet when press sapce bar
  if (keyCode == ' '){
    if(gameState == GAME_RUN){
       if(isShoot[bulletCount] == false){
         isShoot[bulletCount] = true;
         bulletPos[bulletCount][0] = jetX - 10;
         bulletPos[bulletCount][1] = jetY + 12;
         bulletCount ++ ;
       }
     if(bulletCount > 4){
       bulletCount = 0;
     }  
    } 
  }
}

int scoreChange (int value){
  return(newScore + value);
}

boolean isHit (float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh){
  if(bx+bw >= ax && ax + aw >= bx && by + bh >= ay && ay + ah >= by){
    return true;  
  }
  return false; 
}
