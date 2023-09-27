import peasy.*;

PeasyCam cam;

void settings(){
  size(1000,1000,P3D);
}

void setup(){
  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(1000);
}

void draw(){
background(0);
PVector A = new PVector (0,0,0);
PVector B = new PVector (0,100,0);
PVector C = new PVector (100,0,0);
PVector D = new PVector (100,100,0);
PVector AB = PVector.sub(B,A);
PVector AC = PVector.sub(C,A);
kochQuadra(A,B,C,D,1);
//printsinpa(A, PVector.add(A,PVector.mult(AB,3)), PVector.add(A,PVector.mult(AB,3)).add(PVector.mult(AC,3)), PVector.add(A,PVector.mult(AC,3)));
//PVector a = PVector.add(A,PVector.mult(B,2));
//printsinpa1(PVector.add(A,PVector.mult(B,2)).add(B));
}

void printsinpa1(PVector a){
 print(a); 
}
void printsinpa(PVector a,PVector b, PVector c, PVector d){
  print(a);
  print(b);
  print(c);
  print(d);
}
void kochQuadra(PVector polyA, PVector polyB, PVector polyC, PVector polyD, int nbIter){
  PVector polyAB = polyB.sub(polyA);
  PVector polyAC = polyC.sub(polyA);
  PVector polyN = produitVectoriel(polyAB,polyAC); //Vecteur F'F sur le schema du rapport
  polyN.normalize().mult(polyAB.mag()).div(3);
  if(nbIter > 0){
    kochQuadra(polyA, 
    PVector.add(polyA,PVector.div(polyAB,3)),
    PVector.add(polyA,PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,3)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,1.5)), 
    polyB,
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,3)), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)), 
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,1.5)), nbIter-1);

    kochQuadra(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(polyAC),
    polyD, nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(polyAC),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(polyAC), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)),
    polyC,
    PVector.add(polyA,PVector.div(polyAB,3)).add(polyAC), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAC,3)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)), nbIter-1);
    
    //dessin du cube
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)).add(polyN), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)).add(polyN), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)).add(polyN), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)).add(polyN), nbIter-1);
    
    kochQuadra(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)).add(polyN), nbIter-1);
  }else{
    dessinerCarre(polyA, 
    PVector.add(polyA,PVector.div(polyAB,3)),
    PVector.add(polyA,PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,3)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,1.5)), 
    polyB,
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,3)));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)), 
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,1.5)));

    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,polyAB).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(polyAC),
    polyD);
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(polyAC),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(polyAC));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)),
    polyC,
    PVector.add(polyA,PVector.div(polyAB,3)).add(polyAC));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAC,3)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)));
    
    //dessin du cube
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)).add(polyN));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)).add(polyN));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)).add(polyN));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)), 
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)).add(polyN));
    
    dessinerCarre(PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,3)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,3)).add(PVector.div(polyAC,1.5)).add(polyN),
    PVector.add(polyA,PVector.div(polyAB,1.5)).add(PVector.div(polyAC,1.5)).add(polyN));
  }
}

void dessinerCarre(PVector polyA, PVector polyB, PVector polyC, PVector polyD){
beginShape();
vertex(polyA.x,polyA.y,polyA.z);
vertex(polyB.x,polyB.y,polyB.z);
vertex(polyD.x,polyD.y,polyD.z);
vertex(polyC.x,polyC.y,polyC.z);
endShape(CLOSE);
}

PVector produitVectoriel(PVector U, PVector V){
  PVector res = new PVector(U.y*V.z-U.z*V.y,U.z*V.x - U.x*V.z,U.x*V.y-U.y*V.x);
  return res;
}
