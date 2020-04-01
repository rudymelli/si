//Linee orizzontali
//1. crea una variabile y di valore 10
//2. disegna una linea alle coordinate x1,y1(0, y) x2,y2(100, y)
//3. incrementa y di 10
//4. ripeti dall'istruzione 2 per 10 volte
//Linee verticali
//5. crea una variabile x di valore 10
//6. disegna una linea alle coordinate x1,y1(x, 0) x2,y2(x, 100)
//7. incrementa x di 10
//8. ripeti dall'istruzione 2 per 10 volte

for (int y = 10; y <= 90; y += 10) 
  line(10, y, 90, y);
for (int x = 10; x <= 90; x += 10)
  line(x, 10, x, 90);

// Modalità sequenziale
//Linee orizzontali
//disegna una linea alle coordinate x1,y1(0, 10) x2,y2(100, 10)
//disegna una linea alle coordinate x1,y1(0, 20) x2,y2(100, 20)
//..
//Linee verticali
//disegna una linea alle coordinate x1,y1(10, 0) x2,y2(10, 100)
//..
line (0,10,100,10);
line (0,20,100,20);
line (0,30,100,30);
line (0,40,100,40);
line (0,50,100,50);
line (0,60,100,60);
line (0,70,100,70);
line (0,80,100,80);
line (0,90,100,90);

line (10,0,10,100);
line (20,0,20,100);
line (30,0,30,100);
line (40,0,40,100);
line (50,0,50,100);
line (60,0,60,100);
line (70,0,70,100);
line (80,0,80,100);
line (90,0,90,100);
