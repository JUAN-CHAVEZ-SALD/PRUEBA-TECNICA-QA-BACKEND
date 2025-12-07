Feature: Listar Usuarios del Sistema con o sin Filtros

    Background:
        * def baseUrl = Url_Base_Api_Server_Rest
        * def ListarUsuariosPath = "usuarios"

        * def GeneracionDeValores = read('classpath:utils/js/gestionar-usuarios/generacionDeValores.js')
        * def OperacionesConUsuarios = read('classpath:utils/js/gestionar-usuarios/operacionesConUsuarios.js')
        
        * def usuarioAleatorioGenerado = GeneracionDeValores.generarUsuarioValido()
        
        * def responseSchemas = read("classpath:res/gestionar-usuarios/listar-usuarios-schemas.json")
        
        * def SchemaUtils = Java.type('utils.SchemaUtils')

    @LTU1 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar todos los usuarios sin filtros - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])

    @LTU2 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios filtrando por nombre valido - 200 OK
        Given url baseUrl

        # Crear un usuario para asegurar que exista al menos uno que coincida con el filtro
        * eval OperacionesConUsuarios.crearUsuario(usuarioAleatorioGenerado)

        And path ListarUsuariosPath
        And param nome = usuarioAleatorioGenerado.nome
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.usuarios.length > 0
        And assert response.usuarios.every(usuario => usuario.nome.includes(usuarioAleatorioGenerado.nome))

    @LTU3 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios filtrando por email valido - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param email = usuarioAleatorioGenerado.email
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])

    @LTU4 @regresion @smoke-test @happypath @listar-usuarios
    Scenario Outline: Listar usuarios con filtro administrador valido - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param administrador = <es_administrador>
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And match each response.usuarios contains { administrador: <es_administrador> }
        Examples:
            | es_administrador |
            | "true"           |
            | "false"          |

    @LTU5 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Filtrar usuarios por id específico - 200 OK
        Given url baseUrl

        * def idUsuarioRecienCreado = OperacionesConUsuarios.crearUsuario(usuarioAleatorioGenerado)

        And path ListarUsuariosPath
        And param _id = idUsuarioRecienCreado
        When method get
        Then status 200
        * assert SchemaUtils.isValid(response, responseSchemas["200"])
        # Solo se debe retornar el usuario con el Id especificado
        And assert response.usuarios.length == 1   
        And match response.usuarios[0]._id == idUsuarioRecienCreado

    @LTU6 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Filtrar usuarios por password específico - 200 OK
        Given url baseUrl

        * eval OperacionesConUsuarios.crearUsuario(usuarioAleatorioGenerado)

        And path ListarUsuariosPath
        And param password = usuarioAleatorioGenerado.password
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.usuarios.length > 0
        And assert response.usuarios.every(usuario => usuario.password.toLowerCase().includes(usuarioAleatorioGenerado.password.toLowerCase()))

    @LTU8 @regresion @happypath @listar-usuarios
    Scenario Outline: Listar Usuarios por distintas combinaciones de filtros - 200 OK
        Given url baseUrl
        * def idUsuarioExistente = OperacionesConUsuarios.crearUsuario(usuarioAleatorioGenerado)
        And path ListarUsuariosPath
        * def combinacionDeParametrosGenerada = GeneracionDeValores.generarCombinacionParametrosParaListarUsuarios(idUsuarioExistente, usuarioAleatorioGenerado, <Cantidad_Filtros>)
        * print combinacionDeParametrosGenerada
        * params combinacionDeParametrosGenerada
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.usuarios.length >= 1
        And assert response.usuarios[0]._id == idUsuarioExistente
        And assert response.usuarios[0].nome == usuarioAleatorioGenerado.nome
        And assert response.usuarios[0].email == usuarioAleatorioGenerado.email
        And assert response.usuarios[0].password == usuarioAleatorioGenerado.password
        And assert response.usuarios[0].administrador == usuarioAleatorioGenerado.administrador

        * eval OperacionesConUsuarios.eliminarUsuario(idUsuarioExistente)
        
        Examples:
        | Cantidad_Filtros |
        | 2                |
        | 3                |
        | 4                |
        | 5                |

    @LTU7 @regresion @happypath @listar-usuarios
    Scenario: Listar usuarios con id no existente - 200 OK
        Given url baseUrl
        And path ListarUsuariosPath
        And param _id = GeneracionDeValores.generarCaracteresAleatorios(50)
        When method get
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.usuarios.length == 0
        And assert response.quantidade == 0
    
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