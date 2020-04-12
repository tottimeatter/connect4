import controlP5.*;


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
  size(1200,600);
  frameRate(20);
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

  //Inicialització d'elements gràfics
  cp5 = new ControlP5(this);
  inici_button = cp5.addButton("Inici").setPosition(370,80).setSize(125,20).setColorBackground(color(0)).hide();
  sortir_button = cp5.addButton("Sortir").setPosition(750,80).setSize(125,20).setColorBackground(color(0)).hide();
  tauler = new int [8][8];
  
  //Inicialització dels colors
  vermell = color(255,0,0);
  verd = color(0,255,0);
  gris = color(100,100,100);
  
  torn = TORN.JUGADOR1;

}

//Loop principal
void draw(){
  background(0,0,0);
  mostraTauler();
  mostraFitxes();
  
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
    float y = 600 - textWidth(text)/2;
    text(text,y,300);
  }
}

//Moviment de la fitxa
void movimentFitxa(){
   fitxa_dir_x = mouseX - fitxa_x;
   fitxa_dir_y = mouseY - fitxa_y;

   fitxa_x = fitxa_x + fitxa_dir_x;
   fitxa_y = fitxa_y + fitxa_dir_y;
   
   stroke(255,255,255);
   if(torn == TORN.JUGADOR1){
     fill(vermell);
   } else if (torn == TORN.JUGADOR2) {
     fill(verd);
   }
   ellipse(fitxa_x,fitxa_y,50,50);
}

//Mostra l'animació inicial del títol
void mostraTitol(){
  if(titol_size < 50){
    titol_size += 1;
  } else if(!play){
    mostra_opcions = true;
  }
    textSize(titol_size);
    float x = 600 - titol_size*4;
    fill(255,255,255);
    text(titol, x,50);
}

//Mostra les opcions del menu
void mostraOpcions(){
  fill(#FFFFFF);
  textSize(25);
  sortir_button.show();
  inici_button.show();
  
}

// Construeix el tauler de joc
void mostraTauler(){
  float x = 380;
  float y = 150;
  
  for(int i=0;i<8 && i<iteracio_tauler ; i++){
    for(int c=0; c<8 && c<iteracio_tauler;c++){
      switch(tauler[i][c]){
        case 0:
          stroke(#8E8E8E);
          fill(#8E8E8E);
          rect(x,y,50,50);
          break;
        case 1:
          stroke(#8E8E8E);
          fill(#8E8E8E);
          rect(x,y,50,50);
          
          stroke(255,255,255);
          fill(255,0,0);
          ellipse(x+25,y+25,50,50);
          break;
        case 2: 
          stroke(#8E8E8E);
          fill(#8E8E8E);
          rect(x,y,50,50);
          
          stroke(255,255,255);
          fill(0,255,0);
          ellipse(x+25,y+25,50,50);
          break;
      }      
      y+=55;
    }
    y=150;
    x+=55;
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
    ellipse(100,75 + i*15,50,50);
  }
  
  fill(0,255,0);
  for(int i=0;i<32 - tirades_jugador2 && i<iteracio_fitxes;i++){
    ellipse(1100,75 + i*15,50,50);
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
}


// Gestiona l'esdeveniment "click" del ratolí
void mousePressed(){
  // Si ha començat la partida i el "click" ha estat sobre el tauler
  if(play){
    for(int i = 0; i<=8; i++){
      if(380 + i*55 < mouseX && mouseX < 435 + i*55){
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
      break;
    case 2:
      play = false;
      mostra_resultat = true;
      println("Victòria de jugador/a " + res + "!!");
      break;
    case -1:
      play = false;
      mostra_resultat = true;
      println("La partida acaba en empat!");
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
