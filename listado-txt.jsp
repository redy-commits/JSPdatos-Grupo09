<%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import = "java.sql.*" %><%!
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
        ResultSet conjuntoResultados = sentencia.executeQuery("SELECT * FROM libros;" );
        int numero = 1;
        //mientras exista un siguiente...
        while (conjuntoResultados.next()) {
            //traer isbn y titulo del libro actual
            out.println(numero + ". " + " ISBN: " + conjuntoResultados.getString("isbn") + " Título: " + conjuntoResultados.getString("titulo") + " Editorial: " + conjuntoResultados.getString("Editorial") + " Fecha de publicación: " + conjuntoResultados.getString("Anio")+ " Autor: " + conjuntoResultados.getString("autor"));
            numero++;
        }
        response.setStatus(200);
        response.setHeader("Content-Type", "text/plain");
        response.setHeader("Content-Disposition", "attachment; filename=listado.txt");
    }
    //--cierra conexión
    conexion.close();
%>