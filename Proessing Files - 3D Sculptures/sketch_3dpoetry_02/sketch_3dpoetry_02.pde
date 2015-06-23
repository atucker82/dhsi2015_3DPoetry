import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

// float[][] points = {{23,5,1}, {12,20,8}, {25,32,3}, {9,7,1}, {18,5,20}, {20,5,19}, {4,9,19}, {1,16,16}, {15,9,14}, {20,9,14}, {7,32,9}, {20,32,9}, {19,20,8}, {5,32,20}, {9,13,5}, {32,20,8}, {5,18,5}, {32,1,18}, {5,3,15}, {5,19,32}, {16,1,9}, {14,6,21}, {12,32,3}, {1,20,20}, {12,5,32}};

// float[][] points;

int numpoints;
HE_Mesh container;
HE_Mesh[] cells;
int numcells;

HE_Mesh mesh;

WB_Render render;

void setup() {
  size(1200,1200,OPENGL);
  smooth(8);
  //HEC_FromVoronoiCells can be used to recombine meshes generated
  //bij HEMC_VoronoiCells into a single mesh.
  
  //create a container mesh
  container=new HE_Mesh(new HEC_Geodesic().setRadius(400)); 
HE_FaceIterator fitr=new HE_FaceIterator(container);
  while(fitr.hasNext()) fitr.next().setColor(color(0,200,50));
  //generate points
  numpoints=25;
  
// points = new float[25][3];

float [][] points ={{23,5,1}, {12,20,8}, {25,32,3}, {9,7,1}, {18,5,20}, {20,5,19}, {4,9,19}, {1,16,16}, {15,9,14}, {20,9,14}, {7,32,9}, {20,32,9}, {19,20,8}, {5,32,20}, {9,13,5}, {32,20,8}, {5,18,5}, {32,1,18}, {5,3,15}, {5,19,32}, {16,1,9}, {14,6,21}, {12,32,3}, {1,20,20}, {12,5,32}};
  /* points=new float[numpoints][3];
  for(int i=0;i<numpoints;i++) {
    points[i][0]=random(-250,250);
    points[i][1]=random(-250,250);
    points[i][2]=random(-250,250);
  } */
  
  // generate voronoi cells
  HEMC_VoronoiCells multiCreator=new HEMC_VoronoiCells().setPoints(points).setN(numpoints).setContainer(container).setOffset(0);
  cells=multiCreator.create();
  int counter=0;
  for(HE_Mesh c:cells){
   c.setFaceColorWithOtherInternalLabel(color(255-2*counter,220,2.5*counter),-1);
   counter++;
 
  }
  
  
  
  
  
  numcells=cells.length;
  
  boolean[] isCellOn=new boolean[numcells];
  
  for(int i=0;i<numcells;i++){
   isCellOn[i]=(random(100)<50); 
  }
  
  //buwild new mesh from active cells
 
 HEC_FromVoronoiCells creator=new HEC_FromVoronoiCells();
 creator.setCells(cells);// output of HEMC_VoronoiCells, 
 creator.setActive(isCellOn);// boolean array
 
 mesh=new HE_Mesh(creator); 
 mesh.fuseCoplanarFaces();
 mesh.smooth();
 render=new WB_Render(this);
 
 HET_Export.saveToOBJ(mesh,sketchPath(""),"3dpoem");
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(600, 600, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
   noStroke();
  render.drawFacesFC(mesh);
 stroke(0);
  render.drawEdges(mesh);
}



