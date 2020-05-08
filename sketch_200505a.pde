
final float detect_rate=0.2;
final float infect_distance=16;
final float infect_rate=0.4;

//   infect_distance
//   ________          *random(0,1)
//   distance
boolean culculation_infect(float distance,float m_infect_distance){
     if(distance==0)
     {
       return true;
   
     }
       
     println(); //<>//
     if((m_infect_distance/distance)*random(0,1)<=infect_rate){
       return false;
     }
     else{
       return true;
     }
     
}



//male =0 female=1
class Person
{
  class Move_manager {
    float m_x;
    float m_y;

    boolean Is_random_move=true;
    
    Move_manager(float o_x,float o_y){
      this.m_x=o_x;
      this.m_y=o_y;
    }
    
    void random_move() {
      float offsite_x=random(-2, 2);
      float offsite_y=random(-2, 2);
      this.m_x+=offsite_x;
      this.m_y+=offsite_y;
    }

    void Back_boundary(float boundary_center_x, float boundary_center_y, float boundary_half_x, float boundary_half_y) {
      int mark=1;
      while (mark!=0) {
        mark=0;
        if (this.m_x >=boundary_center_x+boundary_half_x ) {
          this.m_x-=0.5;
          mark=1;
        }  
        if (this.m_x <=boundary_center_x-boundary_half_x) {
          this.m_x+=0.5;
          mark=1;
        }
        if (this.m_y >=boundary_center_y+boundary_half_y ) {
          this.m_y-=0.5;
          mark=2;
        }  
        if (this.m_y <=boundary_center_y-boundary_half_y) {
          this.m_y+=0.5;
          mark=2;
        }
      }
    }


    void Back_boundary(float boundary_center_x, float boundary_center_y, float boundary_radius) {
      int mark=1;
      while (mark!=0) {
        float temp_radius=((this.m_x -boundary_center_x)*(this.m_x -boundary_center_x)+(this.m_y -boundary_center_y)*(this.m_y -boundary_center_y));
        if (temp_radius>=boundary_radius*boundary_radius) {
          if (this.m_x >=boundary_center_x ) {
            this.m_x-=0.5;
            mark=1;
          }  
          if (this.m_x <=boundary_center_x) {
            this.m_x+=0.5;
            mark=1;
          }
          if (this.m_y >=boundary_center_y ) {
            this.m_y-=0.5;
            mark=2;
          }  
          if (this.m_y <=boundary_center_y) {
            this.m_y+=0.5;
            mark=2;
          }
        }
      }
    }
    
    
    boolean Check_boundary(float t_center_x, float t_center_y, float t_radius) {

        float temp_radius=sqrt(((this.m_x -t_center_x)*(this.m_x -t_center_x)+(this.m_y -t_center_y)*(this.m_y -t_center_y)));
        //println(temp_radius);
        if (temp_radius<=t_radius) {
            //posibility adjust by distance 
            //culculation_infect(temp_radius,t_radius); //<>//
            return culculation_infect(temp_radius,t_radius);
        }
        else
        {
          return false;
        }
    }
    /*  
    boolean line_move(float start_x,float start_y,float end_x,float end_y){
        
      
    }*/
    
    
  }

  Person(float o_x,float o_y){
      this.move_manager =new Move_manager(o_x,o_y);
  
  }
  Move_manager move_manager;
  int sex=0;
  int age=0;
  int healthy_point=0;
  int infected_days=0;
  boolean Need_out_work=false;
  boolean position_state=false;

  boolean Do_As_asked=false;

  boolean Is_Incubation_period=false; 
  boolean Is_infected=false;
  boolean Is_detected=false;


  boolean Is_Infected() {
    return this.Is_infected;
  }

  boolean detection(float m_detect_rate) {
    float r = random(0, 1);
    println(r);
    if ((r<=m_detect_rate)) {
      this.Is_detected=true;
      return true;
    }
    return false;
  }
}

int PERSON_NUM=200;


Person ps[]=new Person[PERSON_NUM];








float random_init_position(){
  return random(200,1080);
}

void Build_Person(){
  for(int i=0;i<PERSON_NUM;i++)
  {
    ps[i]=new Person(random_init_position(),random_init_position());
  }
  

}

void Draw_person(Person ps){
    if(ps.Is_Infected()){
      //infected
      fill(255,0,0);
      ellipse(ps.move_manager.m_x,ps.move_manager.m_y,6,6);
    }
    else{
      //not
      fill(255,255,255);
      ellipse(ps.move_manager.m_x,ps.move_manager.m_y,6,6);      
      
    }

}


void infection_check(){
   for(int i=0;i<PERSON_NUM;i++)
   {
     if(ps[i].Is_Infected()){
           for(int j=0;j<PERSON_NUM;j++)
           {
            if(i==j){
              continue;
            } 
            if(ps[j].Is_infected){
              continue;
            
            }
             if(ps[i].move_manager.Check_boundary(ps[j].move_manager.m_x,ps[j].move_manager.m_y,infect_distance)){
               ps[j].Is_infected=true;
               println(j+" is infected");
             }
           }
     }
   }

}



void setup() {
  size(1920, 1080);
  smooth();
  frameRate(50);
  Build_Person();
  
}

void draw() {
  background(204);
  ps[140].Is_infected=true;
  ps[150].Is_infected=true;
  ps[120].Is_infected=true;
  for(int i=0;i<PERSON_NUM;i++)
  {  
    Draw_person(ps[i]);
    
    ps[i].move_manager.random_move();
  }
  infection_check();
  
  
}
