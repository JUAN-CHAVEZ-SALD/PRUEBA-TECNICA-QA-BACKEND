Feature: Obtener Usuario por Id en el Sistema

    Background:
        * def baseUrl = Url_Base_Api_Server_Rest
        * def ObtenerUsuarioPath = "usuarios/:idUsuario"

        * def GeneracionDeValores = read('classpath:utils/js/gestionar-usuarios/generacionDeValores.js')
        * def OperacionesConUsuarios = read('classpath:utils/js/gestionar-usuarios/operacionesConUsuarios.js')
        
        * def usuarioAleatorioGenerado = GeneracionDeValores.generarUsuarioValido()
        
        * def responseSchemas = read("classpath:res/gestionar-usuarios/obtener-usuario-por-id-schemas.json")
        
        * def SchemaUtils = Java.type('utils.SchemaUtils')

    @OTU1 @regresion @smoke-test @happypath @obtener-usuario-por-id
    Scenario: Obtener usuario por Id valido - 200 OK
        Given url baseUrl

        * def idUsuarioRecienCreado = OperacionesConUsuarios.crearUsuario(usuarioAleatorioGenerado)

        And path ObtenerUsuarioPath.replace(":idUsuario", idUsuarioRecienCreado)
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        
        # Se elimina el usuario creado para mantener el entorno limpio
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioRecienCreado)

    @OTU2 @regresion @smoke-test @unhappypath @obtener-usuario-por-id
    Scenario: Obtener usuario por Id no existente - 400 Bad Request
        Given url baseUrl
        And path ObtenerUsuarioPath.replace(":idUsuario", GeneracionDeValores.generarCaracteresAleatorios())
        When method get
        Then status 400
        And assert response.message == "Usuário não encontrado"
