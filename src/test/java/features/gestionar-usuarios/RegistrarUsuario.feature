Feature: Registrar Usuario en el Sistema

    Background:
        * def baseUrl = Url_Base_Api_Server_Rest
        * def RegistrarUsuarioPath = "usuarios"

        * def GeneracionDeValores = read('classpath:utils/js/generacionDeValores.js')
        * def OperacionesConUsuarios = read('classpath:utils/js/operacionesConUsuarios.js')
        * def SchemaUtils = Java.type('utils.SchemaUtils')

        * def responseSchemas = read("classpath:res/gestionar-usuarios/registrar-usuario-schemas.json")

        * def usuarioValido = karate.get("usuarioValido", null)
        
        * def elFeatureEstaSiendoInvocado = usuarioValido != null 

        * def usuarioValido = usuarioValido ? usuarioValido : GeneracionDeValores.generarUsuarioValido()

        * def requestBody = read('classpath:req/gestionar-usuarios/body-registrar-usuario.json')
        * set requestBody.nome = usuarioValido.nome
        * set requestBody.email = usuarioValido.email
        * set requestBody.password = usuarioValido.password
        * set requestBody.administrador = usuarioValido.administrador

    @RTU1 @regresion @smoke-test @happypath @registrar-usuario @util
    Scenario: Registrar usuario con datos validos - 201 Created
        Given url baseUrl
        And path RegistrarUsuarioPath
        And request requestBody
        When method post
        Then status 201
        And assert SchemaUtils.isValid(response, responseSchemas["201"])
        And assert response.message == "Cadastro realizado com sucesso"
        * def IdNuevoUsuario = response._id

    @RTU2 @regresion @smoke-test @unhappypath @registrar-usuario
    Scenario Outline: Registrar usuario con algun campo vacio - 400 Bad Request
        Given url baseUrl
        And path RegistrarUsuarioPath
        And eval requestBody[<CampoBody>] = <valor>
        And request requestBody
        When method post
        Then status 400
        And assert response[<CampoBody>] == `${<CampoBody>} não pode ficar em branco` || response[<CampoBody>] == "administrador deve ser 'true' ou 'false'"
        
        Examples:
            | CampoBody       | valor |
            | "nome"          | ""    |
            | "email"         | ""    |
            | "password"      | ""    |
            | "administrador" | ""    |

    @RTU3 @regresion @smoke-test @unhappypath @registrar-usuario
    Scenario Outline: Registrar usuario con algun campo en null - 400 Bad Request
        Given url baseUrl
        And path RegistrarUsuarioPath
        And eval requestBody[<CampoBody>] = null
        And request requestBody
        When method post
        Then status 400
        And assert response[<CampoBody>] == `${<CampoBody>} deve ser uma string` || response[<CampoBody>] == "administrador deve ser 'true' ou 'false'"
        Examples:
            | CampoBody       |
            | "nome"          |
            | "email"         |
            | "password"      |
            | "administrador" |


    @RTU4 @regresion @smoke-test @unhappypath @registrar-usuario
    Scenario Outline: Registrar usuario con algun campo con valor numerico - 400 Bad Request
        Given url baseUrl
        And path RegistrarUsuarioPath
        And eval requestBody[<CampoBody>] = <valor>
        And request requestBody
        When method post
        Then status 400
        And assert response[<CampoBody>] == `${<CampoBody>} deve ser uma string` || response[<CampoBody>] == "administrador deve ser 'true' ou 'false'"
        Examples:
            | CampoBody       | valor                                        |
            | "nome"          | GeneracionDeValores.generarNumeroAleatorio() |
            | "email"         | GeneracionDeValores.generarNumeroAleatorio() |
            | "password"      | GeneracionDeValores.generarNumeroAleatorio() |
            | "administrador" | GeneracionDeValores.generarNumeroAleatorio() |

    @RTU5 @regresion @smoke-test @unhappypath @registrar-usuario
    Scenario: Registrar usuario con email invalido - 400 Bad Request
        Given url baseUrl
        And path RegistrarUsuarioPath
        And set requestBody.email = GeneracionDeValores.generarCaracteresAleatorios()
        And request requestBody
        When method post
        Then status 400
        And assert response.email == "email deve ser um email válido"

    @RTU6 @regresion @smoke-test @unhappypath @registrar-usuario
    Scenario: Registrar usuario con campo administrador invalido - 400 Bad Request
        Given url baseUrl
        And path RegistrarUsuarioPath
        And request requestBody
        And set requestBody.administrador = GeneracionDeValores.generarCaracteresAleatorios()
        When method post
        Then status 400
        And assert response.administrador == "administrador deve ser 'true' ou 'false'"

    @RTU7 @regresion @smoke-test @unhappypath @registrar-usuario
    Scenario: Registrar usuario con email ya registrado para otro usuario - 400 Bad Request
        Given url baseUrl
        And path RegistrarUsuarioPath
        * def otroUsuarioValido = GeneracionDeValores.generarUsuarioValido()
        * set otroUsuarioValido.email = requestBody.email
        * eval OperacionesConUsuarios.crearUsuario(otroUsuarioValido)
        And request requestBody
        When method post
        Then status 400
        And assert response.message == "Este email já está sendo usado"
    
    @RTU8 @regresion @smoke-test @unhappypath @registrar-usuario
    Scenario: Registrar usuario con propiedades adicionales - 400 Bad Request
        Given url baseUrl
        And path RegistrarUsuarioPath
        * def propiedadAdicional = GeneracionDeValores.generarCaracteresAleatorios(6)
        * def valorAleatorio = GeneracionDeValores.generarCaracteresAleatorios()
        * eval requestBody[propiedadAdicional] = valorAleatorio
        And request requestBody
        When method post
        Then status 400
        And assert response[propiedadAdicional] == `${propiedadAdicional} não é permitido`