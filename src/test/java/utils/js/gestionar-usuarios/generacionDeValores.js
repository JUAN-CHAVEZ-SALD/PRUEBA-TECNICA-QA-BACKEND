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

  function generarUsuarioValido(incluirId = false) {
    return {
      nome: `${faker.name().firstName()} ${faker.name().lastName()}`,
      email: faker.internet().emailAddress(),
      password: faker.internet().password(8, 16, true, true, true),
      administrador: String(faker.bool().bool()),
      ...(incluirId && { _id: generarCaracteresAleatorios() }),
    };
  }

  function generarNumeroAleatorio(longitud = 6) {
    longitud = longitud || 6;
    var digits = "0123456789";
    var result = "";
    for (var i = 0; i < longitud; i++) {
      result += digits.charAt(Math.floor(Math.random() * digits.length));
    }
    return Number(result);
  }

  function generarCombinacionParametrosParaListarUsuarios(
    idUsuario,
    datosUsuarioValido,
    cantidadParametros
  ) {
    // validar cantidadParametros: debe ser número entre 2 y 5
    cantidadParametros = Number(cantidadParametros) || 0;
    if (cantidadParametros < 2 || cantidadParametros > 5) {
      throw "cantidadParametros debe ser un número entre 2 y 5";
    }

    if (!datosUsuarioValido || typeof datosUsuarioValido !== "object") {
      throw "datosUsuarioValido es obligatorio y debe ser un objeto con los campos de usuario";
    }

    var available = ["nome", "password", "email", "administrador", "_id"];

    // shuffle (Fisher-Yates)
    function shuffle(arr) {
      var a = arr.slice();
      for (var i = a.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var tmp = a[i];
        a[i] = a[j];
        a[j] = tmp;
      }
      return a;
    }

    var picked = shuffle(available).slice(0, cantidadParametros);
    var params = {};

    picked.forEach(function (key) {
      if (key === "nome") params.nome = datosUsuarioValido.nome;
      else if (key === "password")
        params.password = datosUsuarioValido.password;
      else if (key === "email") params.email = datosUsuarioValido.email;
      else if (key === "administrador")
        params.administrador = datosUsuarioValido.administrador;
      else if (key === "_id") params._id = idUsuario;
    });

    return { ...params };
  }

  return {
    generarUsuarioValido,
    generarCaracteresAleatorios,
    generarNumeroAleatorio,
    generarCombinacionParametrosParaListarUsuarios,
  }

})()
