Feature: Listar Usuarios del Sistema

    Background:
        * def baseUrl = Url_Base_Api_Server_Rest
        * def ListarUsuariosPath = "usuarios"

        * def GeneracionDeValores = read('classpath:utils/js/generacionDeValores.js')
        * def SchemaUtils = Java.type('utils.SchemaUtils')

        * def usuarioAleatorioGenerado = GeneracionDeValores.generarUsuarioValido()

        * def responseSchemas = read("classpath:res/gestionar-usuarios/listar-usuarios-schemas.json")
    
    @LTU1 @regresion @smoke-test @happypath @listar-usuarios @util
    Scenario: Listar todos los usuarios sin filtros - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])

    @LTU2 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios filtrando por nombre valido - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param nome = usuarioAleatorioGenerado.nome
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.usuarios.length > 0
        And assert response.usuarios.every(usuario => usuario.nome.includes(usuarioAleatorioGenerado.nome))

    @LTU3 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios filtrando por email valido - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param email = usuarioAleatorioGenerado.email
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])

    @LTU4 @regresion @smoke-test @happypath @listar-usuarios
    Scenario Outline: Listar usuarios con filtro administrador valido - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param administrador = <es_administrador>
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])
        And match each response.usuarios contains { administrador: <es_administrador> }
        Examples:
            | es_administrador |
            | "true"           |
            | "false"          |

    @LTU5 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Filtrar usuarios por id específico - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param _id = usuarioAleatorioGenerado._id
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])
        # Solo un usuario debe coincidir con el ID específico como maximo
        And assert response.usuarios.length <= 1   
        And match response.usuarios[0]._id == usuarioAleatorioGenerado._id

    @LTU6 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Filtrar usuarios por password específico - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param password = usuarioAleatorioGenerado.password
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.usuarios.length > 0
        And assert response.usuarios.every(usuario => usuario.password.toLowerCase().includes('teste'))

    @LTU7 @regresion @happypath @listar-usuarios
    Scenario: Filtrar por ID no existente debe retornar lista vacía - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param _id = 'IDnoExistente12345'
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.usuarios.length == 0
        And assert response.quantidade == 0

    @LTU8 @regresion @happypath @listar-usuarios
    Scenario: Listar Usuarios por distintas combinaciones de filtros - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath

        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])
    
    @LTU9 @regresion @smoke-test @unhappypath @listar-usuarios
    Scenario: Filtrar usuarios por email invalido - 400 Bad Request
        Given url baseUrl
        And path ListarUsuariosPath
        And param email = GeneracionDeValores.generarCaracteresAleatorios(10)
        When method get
        Then status 400
        And assert response.email == "email deve ser um email válido"

    @LTU10 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios con filtro administrador invalido - 400 Bad Request
        Given url baseUrl
        And path ListarUsuariosPath
        And param administrador = GeneracionDeValores.generarCaracteresAleatorios()
        When method get
        Then status 400
        And assert response.administrador == "administrador deve ser 'true' ou 'false'"