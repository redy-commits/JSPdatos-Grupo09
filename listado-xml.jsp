<%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import = "java.sql.*,java.util.ArrayList,java.util.List" %><%!
      public class Libro {
         String ISBN;
         String titulo;
         String Editorial;
         String Fecha;
         String autor;
         public void Libro(){}
      }
    //método obtener conexión
    public Connection getConnection() throws SQLException {
        //define driver
        String driver = "sun.jdbc.odbc.JdbcOdbcDriver";
        //obtener posición de la base (debe estar en una carpeta data dentro del mismo lugar que este jsp)
        String filePath= getServletContext().getRealPath("\\") + "\\data\\datos.mdb";
        String userName="",password="";
        //concatenar cadena de conexión
        String fullConnectionString = "jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=" + filePath;
        //declaración de ocnexión
        Connection conn = null;
        try{
            //conectar
            Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            conn = DriverManager.getConnection(fullConnectionString,userName,password);
        }
        catch (Exception e) {
            System.out.println("Error: " + e);
        }
        return conn;
    };
%><%
    //proceso
    //--abre conexión
    Connection conexion = getConnection();
    //--proceso escritura
    if (!conexion.isClosed()){
        Statement sentencia = conexion.createStatement();
        //obtener listado de libros
        ResultSet conjuntoResultados = sentencia.executeQuery("SELECT * FROM libros ORDER BY Editorial ASC, autor;" );
        out.println("<Listado>");
        int numero = 1;
        List<Libro> ListaLibros =  new ArrayList<Libro>();
        Libro libroAux = new Libro();
        //Obtener result set en una coleccion
        while (conjuntoResultados.next()) {
            libroAux = new Libro();
            libroAux.ISBN = conjuntoResultados.getString("isbn");
            libroAux.titulo = conjuntoResultados.getString("titulo");
            String editorialAux = conjuntoResultados.getString("Editorial");
            if(editorialAux!=(null))
                libroAux.Editorial = editorialAux;
            else if (editorialAux.isEmpty()||editorialAux.equals("null"))
                libroAux.Editorial = "Desconocido";
            else
                libroAux.Editorial = "Desconocido";
            String anioAux = conjuntoResultados.getString("Anio");
            if(anioAux!=(null))
                libroAux.Fecha = anioAux;
            else
                libroAux.Fecha = "Desconocido";
            String autorAux = conjuntoResultados.getString("autor");
            if(autorAux!=(null))
                libroAux.autor = autorAux;
            else
                libroAux.autor = "Desconocido";
            ListaLibros.add(libroAux);
        }
        int TamanoLista = ListaLibros.size();
        //En ejemplo, si tamanio es 14
        for(int i = 0; i < TamanoLista; i++){
                numero = i + 1;
                //Si el indice es mayor a cero
                if(i > 0) {
                    //VERIFICAR SI EL REGISTRO ANTERIOR TIENE EL MISMO EDITORIAL
                    //Si la editorial actual es diferente a la anterior
                    if(!ListaLibros.get(i).Editorial.equals(ListaLibros.get(i - 1).Editorial))
                        //Imprimir el tag de apertura de Editorial
                        out.println("   <Editorial nombre=\"" + ListaLibros.get(i).Editorial + "\">");
                    
                    //VERIFICAR SI EL REGISTRO ANTERIOR TIENE EL MISMO AUTOR
                    //Si el autor actual es diferente al anterior
                    if(!ListaLibros.get(i).autor.equals(ListaLibros.get(i - 1).autor))
                        //Imprimir el tag de apertura de autor
                        out.println("       <Autor nombre=\"" + ListaLibros.get(i).autor + "\">");
                    
                    //IMPRIME LOS DATOS DEL LIBRO
                    //Imprimir libro, isbn, etc
                    out.println("           <Libro numero=\"" + numero + "\" isbn=\"" + ListaLibros.get(i).ISBN+ "\" fecha=\"" + ListaLibros.get(i).Fecha + "\">");
                    out.println("               "+ListaLibros.get(i).titulo);
                    out.println("           </Libro>");     

                    //VERIFICAR SI EL REGISTRO POSTERIOR TIENE EL MISMO AUTOR      
                    //Si el indice es menor al ultimo indice
                    if(i < (TamanoLista - 1))
                        //Si el autor actual es diferente al posterior
                        if(!ListaLibros.get(i).autor.equals(ListaLibros.get(i + 1).autor))
                            out.println("       </Autor>");
                    //Si es el ultimo indice
                    if(i == (TamanoLista - 1))
                        out.println("       </Autor>");
                    
                    //VERIFICAR SI EL REGISTRO POSTERIOR TIENE EL MISMO EDITORIAL
                    //Si el indice es menor al ultimo indice
                    if(i < (TamanoLista - 1))
                        //Si el editorial actual es diferente al posterior
                        if(!ListaLibros.get(i).Editorial.equals(ListaLibros.get(i + 1).Editorial))
                            out.println("   </Editorial>");
                    //Si es el ultimo indice
                    if(i == (TamanoLista - 1))
                        out.println("   </Editorial>");

                } else if(i==0) {
                    out.println("   <Editorial nombre=\"" + ListaLibros.get(i).Editorial + "\">");
                    out.println("       <Autor nombre=\"" + ListaLibros.get(i).autor + "\">");
                    //traer numero, isbn y titulo del libro actual
                    out.println("           <Libro numero=\"" + numero + "\" isbn=\"" + ListaLibros.get(i).ISBN + "\">");
                    out.println("               "+ListaLibros.get(i).titulo);
                    out.println("           </Libro>");
                    //Si el autor actual es diferente al posterior
                    if(!ListaLibros.get(i).autor.equals(ListaLibros.get(i + 1).autor))
                        out.println("       </Autor>");
                    //Si el editorial actual es diferente al posterior
                    if(!ListaLibros.get(i).Editorial.equals(ListaLibros.get(i + 1).Editorial))
                        out.println("   </Editorial>");

                }
        }
        out.println("</Listado>");
        response.setStatus(200);
        response.setHeader("Content-Type", "application/xml");
        response.setHeader("Content-Disposition", "attachment; filename=listado.xml");
    }
    //--cierra conexión
    conexion.close();
%>