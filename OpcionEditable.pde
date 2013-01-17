class OpcionEditable {
  int x, y;
  boolean estado = false;
  String nombre;
  int tam = 13;
  int tolerancia = tam/2;
  OpcionEditable(String _nombre, int _x, int _y) {
    nombre = _nombre;
    x = _x;
    y = _y;
  }

  void draw() {
    if ( estado ) {
      stroke( 255, 0, 0 );
      fill( 255, 0, 0 );
    }
    else {
      stroke( 255, 0, 0 );
      fill( 255, 0, 0, 60 );
    }
    rectMode(CENTER);
    rect( x, y-5, tam, tam );
    fill(255);
    textAlign(CORNER);
    text( nombre, x+20, y );
  }

  void setEstado() {
    estado = !estado;
  }

  boolean getEstado() {
    return estado;
  }

  boolean isColition( int _x, int _y) {
    boolean exito = false;
    if ( dist( x, y, _x, _y ) < tolerancia ) {
      exito = true;
    }
    return exito;
  }
}

