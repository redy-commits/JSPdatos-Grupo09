<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*" %><%!
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
ServletContext context = request.getServletContext();
String path2 = context.getRealPath("/data");
Connection conexion = getConnection();
   if (!conexion.isClosed()){
//PrintWriter writer;
response.setStatus(200);
//writer = response.getWriter();
response.setHeader("Content-Type", "text/csv");
response.setHeader("Content-Disposition", "attachment; filename=listadoLibros.csv");

   if (!conexion.isClosed()){
      Statement st = conexion.createStatement();
      ResultSet rs = st.executeQuery("select * from libros" );
      // Ponemos los resultados en un table de html
      int i=1;
	  out.println("ISBN;titulo; Editorial; fecha de publicacion;Autor");
      while (rs.next())
      {
        out.println(rs.getString("isbn")+ ";"+rs.getString("titulo")+";"+rs.getString("Editorial") + ";"+ rs.getString("Anio") + ";"+ rs.getString("autor") );
         i++;
      }
      // cierre de la conexion
      conexion.close();
}
   }
%>
