
/*--------------------------------------------------------------------------------------------------
 OBJETO PUNTERO - OBJETO PUNTERO - OBJETO PUNTERO - OBJETO PUNTERO - OBJETO PUNTERO - OBJETO PUNTERO -   
 --------------------------------------------------------------------------------------------------*/
int contId = 0;
int toleranciaInicio = 10;
int toleranciaFin = 10;

class Puntero {

  /*--------------------------------------------------------------------------------------------------
   ATRIBUTOS - ATRIBUTOS - ATRIBUTOS - ATRIBUTOS - ATRIBUTOS - ATRIBUTOS - ATRIBUTOS - ATRIBUTOS -  
   --------------------------------------------------------------------------------------------------*/

  float x,y;
  int id;
  int radio = 40;
  int transparencia = 50;
  boolean down,up,delete;
  color relleno;
  long idTuio;

  String estado;
  int cuentaInicio;
  int cuentaFin;

  boolean asociado;

  /*--------------------------------------------------------------------------------------------------
   CONSTRUCTOR - CONSTRUCTOR - CONSTRUCTOR - CONSTRUCTOR - CONSTRUCTOR - CONSTRUCTOR - CONSTRUCTOR - 
   --------------------------------------------------------------------------------------------------*/

  Puntero( TuioCursor unCursor ) {

    idTuio = unCursor.getSessionID();    
    id = contId;
    contId = (contId+1) % 1000;

    x = unCursor.getScreenX(width);
    y = unCursor.getScreenY(height);

    down = false;
    up = false;
    delete = false;

    relleno = color(random(0,255),random(0,255),random(0,255));
    estado = "dudoso";
    iniciarCuentaInicio();

    cuentaInicio = toleranciaInicio;

    asociado = true;
  }
  //----------------------------------------------

  void iniciarCuentaFin() {
    cuentaFin = toleranciaFin;
  }
  //----------------------------------------------

  void iniciarCuentaInicio() {
    cuentaInicio = toleranciaInicio;
  }
  //----------------------------------------------

  void limpiarAsociacion() {
    asociado = false;
  }
  //----------------------------------------------

  Puntero(int id_,float x_,float y_) {
    id = id_;
    x = x_;
    y = y_;
    down = true;
    up = false;
    delete = false;
    relleno = color(random(0,255),random(0,255),random(0,255));
  }

  /*--------------------------------------------------------------------------------------------------
   METODOS - METODOS - METODOS - METODOS - METODOS - METODOS - METODOS - METODOS - METODOS - METODOS - 
   --------------------------------------------------------------------------------------------------*/

  void imprimir() {
    println("                       id["+id+"]=("+x+" | "+y+") Down="+down+
      " Up="+up + " Estado->"+estado+" TUIO_id->"+idTuio+" asociado->"+asociado );
  }

  //----------------------------------------------

  void marcar() {
    up = true;
  }

  //----------------------------------------------
  boolean esVisible() {
    return !estado.equals("dudoso") && !estado.equals("muerto"); 
  }

  //----------------------------------------------

  void marcarAsociado() {
    asociado = true;
  }
  //----------------------------------------------

  void actualizar(TuioCursor esteCursor) {

    idTuio = esteCursor.getSessionID();    
    x = esteCursor.getScreenX(width);
    y = esteCursor.getScreenY(height);
    //numeroID = str(esteCursor.getCursorID());
    //down = false;
    //up = false;
  }

  //----------------------------------------------

  void dibujo() {
    pushMatrix();
    stroke(0,transparencia);
    fill(relleno,transparencia);
    translate(x,y);
    ellipse(0,0,radio,radio);
    fill(0);
    popMatrix();
  }

  //----------------------------------------------

  boolean estaMuerto() {
    return estado.equals("muerto");
  }  
  //----------------------------------------------

  void actualizarEstado() {

    if( estado.equals("dudoso") ) {
      cuentaInicio--;
      if( !asociado ) {
        estado = "muerto";
      }
      else if( cuentaInicio<=0 ) {
        estado = "activo";        
        down = true;
        up = false;
      }
    }
    else if( estado.equals("activo") ) {
      down = false;
      up = false;
      if( !asociado ) {
        estado = "moribundo";
        iniciarCuentaFin();
      }
    }
    else if( estado.equals("moribundo") ) {
      cuentaFin--;
      if( asociado ) {
        estado = "activo";
      }
      else if( cuentaFin<=0 ) {
        estado = "sin_retorno";
        up = true;
      }
    }
    else if( estado.equals("sin_retorno") ) {
      estado = "muerto";
    }
    else if( estado.equals("muerto") ) {
    }
    else {
      println("error !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ");
    }
  }
}

