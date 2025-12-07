Feature: Actualizar los datos de un Usuario en el Sistema

    Background:
        * def baseUrl = Url_Base_Api_Server_Rest
        * def ActualizarUsuarioPath = "usuarios/:idUsuario"

        * def GeneracionDeValores = read('classpath:utils/js/gestionar-usuarios/generacionDeValores.js')
        * def OperacionesConUsuarios = read('classpath:utils/js/gestionar-usuarios/operacionesConUsuarios.js')
        
        * def usuarioAleatorioGenerado =  GeneracionDeValores.generarUsuarioValido()
    
        * def idUsuarioExistente = OperacionesConUsuarios.crearUsuario(usuarioAleatorioGenerado)
        
        * def requestBody = read('classpath:req/gestionar-usuarios/body-actualizar-usuario.json')
        * set requestBody.nome = usuarioAleatorioGenerado.nome
        * set requestBody.email = usuarioAleatorioGenerado.email
        * set requestBody.password = usuarioAleatorioGenerado.password
        * set requestBody.administrador = usuarioAleatorioGenerado.administrador
        
        * def responseSchemas = read("classpath:res/gestionar-usuarios/actualizar-usuario-schemas.json")

        * def SchemaUtils = Java.type('utils.SchemaUtils')

    @ATU1 @regresion @smoke-test @happypath @actualizar-usuario @util

    Scenario Outline: Actualizar algun campo usuario existente con datos validos - 200 OK
        Given url baseUrl
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        * eval requestBody[<CampoBody>] = <valor>
        And request requestBody
        When method put
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.message == "Registro alterado com sucesso"
        
        # Eliminar el usuario creado para mantener el entorno limpio
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)

        Examples:
            | CampoBody       | valor                                                    |
            | "nome"          | GeneracionDeValores.generarUsuarioValido().nome          |
            | "email"         | GeneracionDeValores.generarUsuarioValido().email         |
            | "password"      | GeneracionDeValores.generarUsuarioValido().password      |
            | "administrador" | GeneracionDeValores.generarUsuarioValido().administrador |


    @ATU2 @regresion @smoke-test @happypath @actualizar-usuario @util
    Scenario: Actualizacion para un usuario no existente con datos validos - 201 Created
        Given url baseUrl

        * def idUsuarioNoExistente = GeneracionDeValores.generarCaracteresAleatorios()
        * def otroUsuarioValido = GeneracionDeValores.generarUsuarioValido()
        * set requestBody.nome = otroUsuarioValido.nome
        * set requestBody.email = otroUsuarioValido.email
        * set requestBody.password = otroUsuarioValido.password
        * set requestBody.administrador = otroUsuarioValido.administrador

        * print idUsuarioNoExistente
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioNoExistente)
        And request requestBody
        When method put
        Then status 201
        And assert SchemaUtils.isValid(response, responseSchemas["201"])
        And assert response.message == "Cadastro realizado com sucesso"
        
        # Eliminar el usuario creado para mantener el entorno limpio
        * eval OperacionesConUsuarios.eliminarUsuario(response._id)

    @ATU3 @regresion @smoke-test @happypath @actualizar-usuario @util
    Scenario: Intentar actualizar para un usuario existente su email por uno ya registrado - 400 Bad Request
        Given url baseUrl

        * def otroUsuarioValido = GeneracionDeValores.generarUsuarioValido()
        * def idOtroUsuarioExistente = OperacionesConUsuarios.crearUsuario(otroUsuarioValido)

        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        And eval requestBody.email = otroUsuarioValido.email
        And request requestBody
        When method put
        Then status 400
        And assert response.message == "Este email já está sendo usado"
        
        # Eliminar los usuarios creados para mantener el entorno limpio
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)
        * eval OperacionesConUsuarios.eliminarUsuario(idOtroUsuarioExistente)

    @ATU4 @regresion @smoke-test @unhappypath @actualizar-usuario
    Scenario Outline: Actualizar usuario con algun campo vacio - 400 Bad Request
        Given url baseUrl
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        * eval requestBody[<CampoBody>] = <valor>
        And request requestBody
        When method put
        Then status 400
        And assert response[<CampoBody>] == `${<CampoBody>} não pode ficar em branco` || response[<CampoBody>] == "administrador deve ser 'true' ou 'false'"
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)

        Examples:
            | CampoBody       | valor |
            | "nome"          | ""    |
            | "email"         | ""    |
            | "password"      | ""    |
            | "administrador" | ""    |

    @ATU5 @regresion @smoke-test @unhappypath @actualizar-usuario
    Scenario Outline: Actualizar usuario con algun campo en null - 400 Bad Request
        Given url baseUrl
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        * eval requestBody[<CampoBody>] = null
        And request requestBody
        When method put
        Then status 400
        And assert response[<CampoBody>] == `${<CampoBody>} deve ser uma string` || response[<CampoBody>] == "administrador deve ser 'true' ou 'false'"
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)

        Examples:
            | CampoBody       |
            | "nome"          |
            | "email"         |
            | "password"      |
            | "administrador" |

    @ATU6 @regresion @smoke-test @unhappypath @actualizar-usuario
    Scenario Outline: Actualizar usuario con algun campo con valor numerico - 400 Bad Request
        Given url baseUrl
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        * eval requestBody[<CampoBody>] = <valor>
        And request requestBody
        When method put
        Then status 400
        And assert response[<CampoBody>] == `${<CampoBody>} deve ser uma string` || response[<CampoBody>] == "administrador deve ser 'true' ou 'false'"
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)

        Examples:
            | CampoBody       | valor                                        |
            | "nome"          | GeneracionDeValores.generarNumeroAleatorio() |
            | "email"         | GeneracionDeValores.generarNumeroAleatorio() |
            | "password"      | GeneracionDeValores.generarNumeroAleatorio() |
            | "administrador" | GeneracionDeValores.generarNumeroAleatorio() |

    @ATU7 @regresion @smoke-test @unhappypath @actualizar-usuario
    Scenario: Actualizar usuario con email invalido - 400 Bad Request
        Given url baseUrl
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        * set requestBody.email = GeneracionDeValores.generarCaracteresAleatorios()
        And request requestBody
        When method put
        Then status 400
        And assert response.email == "email deve ser um email válido"
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)

    @ATU8 @regresion @smoke-test @unhappypath @actualizar-usuario
    Scenario: Actualizar usuario con campo administrador invalido - 400 Bad Request
        Given url baseUrl
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        * set requestBody.administrador = GeneracionDeValores.generarCaracteresAleatorios()
        And request requestBody
        When method put
        Then status 400
        And assert response.administrador == "administrador deve ser 'true' ou 'false'"
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)

    @ATU9 @regresion @smoke-test @unhappypath @actualizar-usuario
    Scenario: Actualizar usuario con propiedades adicionales - 400 Bad Request
        Given url baseUrl
        And path ActualizarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        * def propiedadAdicional = GeneracionDeValores.generarCaracteresAleatorios(6)
        * def valorAleatorio = GeneracionDeValores.generarCaracteresAleatorios()
        * eval requestBody[propiedadAdicional] = valorAleatorio
        And request requestBody
        When method put
        Then status 400
        And assert response[propiedadAdicional] == `${propiedadAdicional} não é permitido`
        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)
