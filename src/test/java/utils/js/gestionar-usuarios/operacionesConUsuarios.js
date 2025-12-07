(function(){

    const UtilEscenarios_Rutas = {
        RegistrarUsuario: "classpath:features/gestionar-usuarios/RegistrarUsuario.feature@RTU1",
        EliminarUsuario: "classpath:features/gestionar-usuarios/EliminarUsuario.feature@ELU1"
    }

    function crearUsuario(usuarioValido){

        if(!usuarioValido || !usuarioValido.nome || !usuarioValido.email || !usuarioValido.password || !usuarioValido.administrador){
          return karate.error("[utils/js/operacionesConUsuarios.js:crearUsuario] Datos Invalidos para crear usuario");
        }


        const respuesta = karate.call(UtilEscenarios_Rutas.RegistrarUsuario, {usuarioValido: usuarioValido});

        return respuesta.IdNuevoUsuario
    }

    function eliminarUsuario(idUsuario){

        if(!idUsuario){
            return karate.error("[utils/js/operacionesConUsuarios.js:eliminarUsuario] ID de usuario invalido para eliminar usuario");
        }

        karate.call(UtilEscenarios_Rutas.EliminarUsuario, {idUsuario: idUsuario});

    }

    return {
        crearUsuario,
        eliminarUsuario
    }

})()