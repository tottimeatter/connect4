import controlP5.*;
import ddf.minim.*;

// Control del so
Minim minim;
AudioPlayer player;
AudioSample so_fitxa;
AudioSample so_empat;
AudioSample so_final;
AudioSample so_error;

//Imatges
PImage background;
PImage fitxa_grana;
PImage fitxa_lila;

//Variables gràfiques
ControlP5 cp5;
controlP5.Button inici_button;
controlP5.Button sortir_button;

//Colors
color vermell;
color verd;
color gris;

//Fitxa
float fitxa_x;
float fitxa_y;
float fitxa_dir_x;
float fitxa_dir_y;

//Tauler
int[][] tauler;

int resultat;
boolean mostra_resultat;
int tirades_jugador1;
int tirades_jugador2;

//Variables globals
String titol; //Conté el títol del joc
boolean mostra_titol;
int titol_size;
boolean mostra_opcions;

int iteracio_tauler; //Contador per controlar el número de caselles
int iteracio_fitxes; //Contador per controlar el número de fitxes

int num_tirades_jug1; //Número de tirades del jugador 1
int num_tirades_jug2; //Número de tirades del jugador 2

public enum TORN {
  JUGADOR1,
  JUGADOR2 
}

TORN torn; //Guarda el jugador que està tirant

boolean play; //True si s'està executant la partida, altrament fals

//Inicialització de l'aplicació
void setup(){ 
  size(1200,700);
  frameRate(20);
  background = loadImage("img/background.jpg");
  fitxa_grana = loadImage("img/Fitxa_grana.png");
  fitxa_lila = loadImage("img/Fitxa_lila.png");
  
  titol = "Quatre en ratlla";
  mostra_titol = false;
  mostra_opcions=false;
  titol_size=0;
  iteracio_tauler=0;
  iteracio_fitxes=0;
  resultat = 0;
  mostra_resultat = false;
  tirades_jugador1 = 0;
  tirades_jugador2 = 0;

  play = false;
  
  //Inicialització del so
  minim = new Minim(this);
  player = minim.loadFile("Blue Boi.mp3");
  so_fitxa = minim.loadSample("fitxa.mp3");
  so_empat = minim.loadSample("end.wav");
  so_final = minim.loadSample("victory.mp3");
  so_error = minim.loadSample("SD.wav");

  //Inicialització d'elements gràfics
  cp5 = new ControlP5(this);
  inici_button = cp5.addButton("Inici").setPosition(425,315).setSize(125,20).setColorBackground(color(0)).hide();
  sortir_button = cp5.addButton("Sortir").setPosition(650,315).setSize(125,20).setColorBackground(color(0)).hide();
  tauler = new int [8][8];
  
  //Inicialització dels colors
  vermell = color(255,0,0);
  verd = color(0,255,0);
  gris = color(100,100,100);
  
  torn = TORN.JUGADOR1;

}

//Loop principal
void draw(){
  background(background);
  mostraTauler();
  mostraFitxes();
  
  //Reprodueix la música de fons
  if(!player.isPlaying()){
    player.loop();
  }
  
  //Lògica del joc
  if(mostra_titol){
    mostraTitol();
  }
  
  if(mostra_opcions){
    mostraOpcions();
    mostra_opcions = false;
  } else {
    inici_button.hide();
    sortir_button.hide();
  }
  if(play){
    mostra_opcions = false;
    movimentFitxa();
  }
  if(mostra_resultat){
    fill(255,255,255,175);
    stroke(255,255,255);
    rect(400,200,400,200);
    fill(0,0,0);
    String text;
    
    if(resultat != -1){
      text = "Victòria de jugador " + resultat + "!!";
    } else {
      text = "Empat!!";
    }
    textSize(25);
    float x = 600 - textWidth(text)/2;
    text(text,x,270);
  }
}

//Moviment de la fitxa
void movimentFitxa(){
   fitxa_dir_x = mouseX - fitxa_x;
   fitxa_dir_y = mouseY - fitxa_y;

   fitxa_x = fitxa_x + fitxa_dir_x - 35;
   fitxa_y = fitxa_y + fitxa_dir_y - 35;
   
   stroke(255,255,255);
   if(torn == TORN.JUGADOR1){
     image(fitxa_grana, fitxa_x,fitxa_y,70,70);
   } else if (torn == TORN.JUGADOR2) {
     image(fitxa_lila, fitxa_x,fitxa_y,70,70);
   }
}

//Mostra l'animació inicial del títol
void mostraTitol(){
  if(titol_size < 50){
    titol_size += 1;
  } else if(!play){
    mostra_opcions = true;
  }
    
    textSize(titol_size);
    float x = 610 - titol_size*4;
    fill(0,0,0);
    text(titol, x,50);
}

//Mostra les opcions del menu
void mostraOpcions(){
  fill(255,255,255,175);
  stroke(255,255,255,255);
  rect(400,200,400,200);
  if(!mostra_resultat){
    fill(0,0,0);
    textSize(25);
    String text = "Menú";
    float x = 600 - textWidth(text)/2;
    text(text,x,270);  
  }

  sortir_button.show();
  inici_button.show();
  
}

// Construeix el tauler de joc
void mostraTauler(){
  float x = 300;
  float y = 75;
  
  for(int i=0;i<8 && i<iteracio_tauler ; i++){
    for(int c=0; c<8 && c<iteracio_tauler;c++){
      switch(tauler[i][c]){
        case 0:
          stroke(#8E8E8E);
          fill(#8E8E8E);
          rect(x,y,70,70);
          break;
        case 1:
          stroke(#8E8E8E);
          fill(#8E8E8E);
          rect(x,y,70,70);
          
          stroke(255,255,255);
          fill(255,0,0);
          image(fitxa_grana,x,y,75,75);
          break;
        case 2: 
          stroke(#8E8E8E);
          fill(#8E8E8E);
          rect(x,y,70,70);
          
          stroke(255,255,255);
          fill(0,255,0);
          image(fitxa_lila,x,y,75,75);
          break;
      }      
      y+=75;
    }
    y=75;
    x+=75;
  }
  if(iteracio_tauler < 8){
    iteracio_tauler++;
  }
}

//Mostra les fitxes de cada jugador
void mostraFitxes() {
  stroke(255,255,255);
  fill(255,0,0);
  
  for(int i=0;i<32 - tirades_jugador1 && i<iteracio_fitxes;i++){
    image(fitxa_grana,75,50 + i*15,75,75);
  }
  
  fill(0,255,0);
  for(int i=0;i<32 - tirades_jugador2 && i<iteracio_fitxes;i++){
    image(fitxa_lila, 1050,50 + i*15,75,75);
  }  
  if(iteracio_fitxes >= 32){
    mostra_titol = true;
  }
  iteracio_fitxes++;
}

// Gestiona el "click" sobre el botó "sortir"
public void Sortir(int theValue) {
  exit();
}

// Gestiona el "click" sobre el botó "inici"
public void Inici(int value){
  tauler = new int[8][8];
  play = true;
  mostra_resultat = false;
  tirades_jugador1=0;
  tirades_jugador2=0;
  torn = TORN.JUGADOR1;
  if(player.isMuted()){
    player.unmute();
  }
}


// Gestiona l'esdeveniment "click" del ratolí
void mousePressed(){
  // Si ha començat la partida i el "click" ha estat sobre el tauler
  if(play){
    for(int i = 0; i<=8; i++){
      if(300 + i*75 < mouseX && mouseX < 375 + i*75){
        tiraFitxa(i);
      }
    }  
  }
}

// Modifica el tauler, si s'escau, amb la nova tirada
void tiraFitxa(int columna){
  boolean colocada = false;
  
  // Es mira si hi ha alguna fitxa per poder col·locar la següent 
  for(int j = 0; j < tauler[columna].length; j++){
    if(j == 7){
      if(tauler[columna][j] == 0 && torn == TORN.JUGADOR1){
        tauler[columna][j] = 1;
        tirades_jugador1++;
        colocada = true;
      } else if(tauler[columna][j] == 0 && torn == TORN.JUGADOR2){
        tauler[columna][j] = 2;
        tirades_jugador2++;
        colocada = true;
      }
    } else{
      if(tauler[columna][j + 1] != 0 && tauler[columna][j] == 0){
        if(torn == TORN.JUGADOR1){
          tauler[columna][j] = 1;
          tirades_jugador1++;
          colocada = true;
          break;
        } else if(torn == TORN.JUGADOR2){
          tauler[columna][j] = 2;
          colocada = true;
          tirades_jugador2++;
          break;
        }
      }
    }
  }
  if(colocada){so_fitxa.trigger();} else {so_error.trigger();}
  nextAccio(colocada);
}

// Avalua quin ha de ser el següent pas
void nextAccio(boolean colocada){
  int res = avaluaPartida();
  switch(res){
    case 0:
      if(torn == TORN.JUGADOR1 && colocada){
        torn = TORN.JUGADOR2;
      } else if(torn == TORN.JUGADOR2 && colocada){
        torn = TORN.JUGADOR1;
      }      
      break;
    case 1:
      play = false;
      mostra_resultat = true;
      println("Victòria de jugador/a " + res + "!!");
      player.mute();
      so_final.trigger();
      break;
    case 2:
      play = false;
      mostra_resultat = true;
      println("Victòria de jugador/a " + res + "!!");
      player.mute();
      so_final.trigger();
      break;
    case -1:
      play = false;
      mostra_resultat = true;
      println("La partida acaba en empat!");
      player.mute();
      so_empat.trigger();
      break;
  }    
}


// Mostra per consola l'estat del tauler
void printTirada(){
  println("******************************************");
  for(int i = 0; i < tauler[0].length; i++){
          println(tauler[i]);
  }
}

int avaluaPartida() {
  int valor_fitxa = 0;
  resultat = 0;
  int seguir_buscant = 0;
  int i = 0;
  int j=0;
  int fil;
  int col;
  
  // Comproba quatre en ratlla vertical o diagonal
  for(col=0; col < 8 && resultat==seguir_buscant; col++){
    for(fil = 0; fil<5 && resultat == seguir_buscant; fil++){
      valor_fitxa = tauler[col][fil];
      if(valor_fitxa != 0){
        resultat = valor_fitxa;
        for(i = 0; i <4; i++){
          resultat = (tauler[col][fil+i] == valor_fitxa) ? resultat : seguir_buscant;
        }
      }
      
      if(valor_fitxa != 0 && resultat == seguir_buscant && col<5){
        resultat = valor_fitxa;
        for(i=1;i<4;i++){
          resultat = (tauler[col+i][fil+i] == valor_fitxa) ? resultat : seguir_buscant;
        }
      }
      
      if(valor_fitxa!=0 && resultat==seguir_buscant && col>2){
        resultat=valor_fitxa;
        for(i=1;i<4;i++){
          resultat = (tauler[col-i][fil+i] == valor_fitxa) ? resultat : seguir_buscant;
        }
      }
    }
    
  }
  
  // Comproba 4 en ratlla horitzontal
  for(fil = 0; (fil<8 && resultat==seguir_buscant); fil++){
    for(col=0;(col<5 && resultat==seguir_buscant);col++){
      valor_fitxa = tauler[col][fil];
      
      if(valor_fitxa != 0){
        resultat = valor_fitxa;
        for(j=col+1; j<col+4;j++){
          resultat = (tauler[j][fil]==valor_fitxa) ? resultat : seguir_buscant;
        }
      }
    }
  }
  
  // Comproba si hi ha espai al tauler per fer més tirades
  if(resultat == 0){
    boolean endGame = true;
    for(fil = 0; fil<8;fil++){
      for(col = 0; col<8;col++){
        if(tauler[fil][col] == 0){
          endGame = false;
          break;
        }
      }
    }
    if(endGame){
      resultat = -1;
    }
  }
  return resultat;
}
