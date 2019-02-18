int pippo = 10;
pippo=5;

float pluto = 6.8;
pluto=pippo;

pippo=int(pluto);
pippo=(int)pluto;

boolean minnie = false;

String paperino = "qui possiamo \"scrivere\" tutto quello che vogliamo, 1, 2, 3";
paperino = "";

int pl = paperino.length();

char car = '\'';

PImage immagine = loadImage("C:\\Users\\melli\\Pictures\\Immagine.png");
int w = immagine.width;

size(300, 200);
image(immagine, 0, 0, width/2, height/2);
image(immagine, width/3, height/3, width/4, height/4);