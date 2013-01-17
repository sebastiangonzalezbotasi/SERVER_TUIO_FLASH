float toleranciaDistancia = 50;

class NuevoMediador {

  ArrayList listaViejos;
  TuioProcessing mensajero;

  Vector listaCursor;
  int cantPuntNuevos;
  String estadoNuevos[];
  int cantPunteros;

  //-------------------------------------------------
  NuevoMediador( TuioProcessing mensajero_ ) {
    mensajero  = mensajero_;
    listaViejos = new ArrayList();
  }

  //-------------------------------------------------
  void actualizarPunteros() {

    //inicializa la lista de nuevos y los pone a todos en pendiente
    inicializarEstadosParaNuevos();
    //inicializo la lista de asociaciones de los viejos
    inicializarViejos();

    //busco en los viejos a que ID estan asociado y veo si aun existen
    asociarPorIdentidades();

    //busco que los que quedaron desasociados de los viejos y los comparo con los
    //pendientes de los nuevos con una tolerancia
    asociarPorPosiciones();

    //agrega aquellos que quedaron pendientes de los nuevos
    agregarSueltos();

    actualizarEstadosDeViejos();

    borrarLibresViejos();
  }

  //-------------------------------------------------

  void actualizarEstadosDeViejos() {

    for( int i=0 ; i<listaViejos.size() ; i++ ) {
      Puntero este = (Puntero) listaViejos.get( i );
      este.actualizarEstado();
    }
  }
  //-------------------------------------------------

  void inicializarViejos() {
    for( int i=0 ; i<listaViejos.size() ; i++ ) {
      Puntero este = (Puntero) listaViejos.get( i );      
      este.limpiarAsociacion();
    }
  }
  //-------------------------------------------------

  void agregarSueltos() {

    for( int i=0 ; i<cantPuntNuevos ; i++ ) {
      if( estadoNuevos[ i ].equals( "pendiente" ) ) {

        TuioCursor unCursor = (TuioCursor) listaCursor.elementAt(i);
        Puntero este = new Puntero( unCursor );
        listaViejos.add( este );
        estadoNuevos[ i ] = "nuevo";
      }
    }
  }
  //-------------------------------------------------

  void borrarLibresViejos() {
    cantPunteros = 0;
    for( int i=0 ; i<listaViejos.size() ; i++ ) {
      Puntero este = (Puntero) listaViejos.get( i );
      if(este.esVisible()) {
        cantPunteros++;
      }
      else if( este.estaMuerto() ) {
        listaViejos.remove(i);
      }
    }
  }
  //-------------------------------------------------

  void asociarPorPosiciones() {

    for( int j=0 ; j<listaViejos.size() ; j++ ) {
      Puntero este = (Puntero) listaViejos.get( j );
      if( !este.asociado ) {

        for (int i=0 ; i<cantPuntNuevos ; i++) {        
          if( estadoNuevos[i].equals( "pendiente" ) ) {
            TuioCursor unCursor = (TuioCursor) listaCursor.elementAt(i);

            if( estanCerca( este, unCursor ) ) {

              este.actualizar( unCursor );
              este.marcarAsociado();
              estadoNuevos[i] = "ocupado";
              break;
            }
          }
        }
      }
    }
  }
  //-------------------------------------------------

  boolean estanCerca( Puntero este, TuioCursor unCursor ) {
    return dist( este.x, este.y, 
    unCursor.getScreenX(width), unCursor.getScreenY(height) ) < toleranciaDistancia;
  }
  //-------------------------------------------------

  void asociarPorIdentidades() {

    for( int j=0 ; j<listaViejos.size() ; j++ ) {
      Puntero este = (Puntero) listaViejos.get( j );
      if( !este.asociado ) {

        for (int i=0 ; i<cantPuntNuevos ; i++) {        
          if( estadoNuevos[i].equals( "pendiente" ) ) {

            TuioCursor unCursor = (TuioCursor) listaCursor.elementAt(i);
            if( unCursor.getSessionID() == este.idTuio ) {

              este.actualizar( unCursor );
              este.marcarAsociado();
              estadoNuevos[i] = "ocupado";
              break;
            }
          }
        }
      }
    }
  }
  //-------------------------------------------------

  void inicializarEstadosParaNuevos() {

    listaCursor = mensajero.getTuioCursors();
    cantPuntNuevos = listaCursor.size();

    estadoNuevos = new String[ cantPuntNuevos ];
    for( int i=0 ; i<cantPuntNuevos ; i++ ) {
      estadoNuevos[i] = "pendiente";
    }
  }
  //-------------------------------------------------

  void monitorViejos() {
    println( "-- Lista de ACTUALES ---------------------------------------------" );
    for( int i=0 ; i<listaViejos.size() ; i++ ) {
      Puntero este = (Puntero) listaViejos.get( i );
      este.imprimir();
    }
  }
  //-------------------------------------------------

  void monitorNuevos() {
    println( "-- Planilla de NUEVOS ---------------------------------------------" );
    for (int i=0 ; i<cantPuntNuevos ; i++) {        
      TuioCursor unCursor = (TuioCursor) listaCursor.elementAt(i);
      println( "["+unCursor.getSessionID()+"]->"+ estadoNuevos[i] );
    }
  }

  //-------------------------------------------------


  Puntero devolverPunteroNum(int orden) {
    Puntero resultado = null;
    int cont = 0;
    for( int i=0 ; i<listaViejos.size() ; i++ ) {
      Puntero este = (Puntero) listaViejos.get( i );
      if(este.esVisible()) {
        if(cont == orden) {
          resultado = este;
          break;
        }
        cont++;
      }
    }
    return resultado;
  }
  
  
}

