function fn() {
  var env = karate.env || "dev";

  var Url_Base_Api_Server_Rest;

  karate.log("Se realiza la ejecución en ambiente: ", env);

  // Debido a que no hay mas entornos, todo se ejecutara en entorno 'dev'
  if (env == "dev") {

    Url_Base_Api_Server_Rest = "https://serverest.dev";

  
  } else {
    throw new Error("El entorno " + env + " no es soportado");
  }


  return {
    Url_Base_Api_Server_Rest
  };
}