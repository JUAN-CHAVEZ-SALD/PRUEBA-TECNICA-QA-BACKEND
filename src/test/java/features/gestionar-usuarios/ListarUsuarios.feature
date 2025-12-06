Feature: Listar Usuarios del Sistema

    Background:
        * def baseUrl = Url_Base_Api_Server_Rest
        * def ListarUsuariosPath = 'usuarios'
    
    @LTU1 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar todos los usuarios sin filtros con validaciones completas
        Given url baseUrl
        And path ListarUsuariosPath
        When method get
        Then status 200

    @LTU2 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios filtrando por nombre
        Given url baseUrl
        And path ListarUsuariosPath
        And param nome = 'Fulano'
        When method get
        Then status 200
        And assert response.usuarios.length > 0
        And match each response.usuarios contains { nome: '#string' }
        And assert response.usuarios.every(usuario => usuario.nome.includes('Fulano'))

    @LTU3 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios filtrando por email valido
        Given url baseUrl
        And path ListarUsuariosPath
        And param email = 'fulano@qa.com'
        When method get
        Then status 200
        
    @LTU4 @regresion @smoke-test @happypath @listar-usuarios
    Scenario Outline: Listar usuarios con filtro administrador valido
        Given url baseUrl
        And path ListarUsuariosPath
        And param administrador = <es_administrador>
        When method get
        Then status 200
        And match each response.usuarios contains { administrador: <es_administrador> }
        Examples:
            | es_administrador |
            | "true"           |
            | "false"          |

    @LTU5 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Filtrar usuarios por ID específico
        Given url baseUrl
        And path ListarUsuariosPath
        And param _id = '0uxuPY0cbmQhpEz1'
        When method get
        Then status 200
        And assert response.usuarios.length <= 1
        And match response.usuarios[0]._id == '0uxuPY0cbmQhpEz1'

    @LTU6 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Filtrar usuarios por password específico
        Given url baseUrl
        And path ListarUsuariosPath
        And param password = 'teste'
        When method get
        Then status 200
        And assert response.usuarios.length > 0
        And assert response.usuarios.every(usuario => usuario.password.toLowerCase().includes('teste'))

    @LTU7 @regresion @happypath @listar-usuarios
    Scenario: Filtrar por ID no existente debe retornar lista vacía
        Given url baseUrl
        And path ListarUsuariosPath
        And param _id = 'IDnoExistente12345'
        When method get
        Then status 200
        And assert response.usuarios.length == 0
        And assert response.quantidade == 0

    @LTU8 @regresion @happypath @listar-usuarios
    Scenario: Validar estructura de respuesta sin filtros
        Given url baseUrl
        And path ListarUsuariosPath
        When method get
        Then status 200
        * def usuarioSchema = { nome: '#string', email: '#string', password: '#string', administrador: '#string', _id: '#string' }
        And match each response.usuarios == usuarioSchema
    
    @LTU9 @regresion @smoke-test @unhappypath @listar-usuarios
    Scenario: Filtrar usuarios por email invalido - 400 Bad Request
        Given url baseUrl
        And path ListarUsuariosPath
        And param email = 'qa.com'
        When method get
        Then status 400
        And assert response.email == "email deve ser um email válido"

    @LTU10 @regresion @smoke-test @happypath @listar-usuarios
    Scenario: Listar usuarios con filtro administrador invalido
        Given url baseUrl
        And path ListarUsuariosPath
        And param administrador = "fiefqenfjqef"
        When method get
        Then status 400
        And assert response.administrador == "administrador deve ser 'true' ou 'false'"