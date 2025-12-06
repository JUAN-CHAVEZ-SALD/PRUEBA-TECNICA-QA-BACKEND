(function () {
  function generarCaracteresAleatorios(longitud = 16) {
    var chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    var result = "";
    for (var i = 0; i < longitud; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }

  var Faker = Java.type("com.github.javafaker.Faker");
  var faker = new Faker(new java.util.Locale("es", "PE"));

  function generarUsuarioValido() {
    return {
      _id: generarCaracteresAleatorios(),
      nome: `${faker.name().firstName()} ${faker.name().lastName()}`,
      email: faker.internet().emailAddress(),
      password: faker.internet().password(8, 16, true, true, true),
      administrador: String(faker.bool().bool()),
    };
  }

  return {
    generarUsuarioValido,
    generarCaracteresAleatorios,
  };
  
})()
