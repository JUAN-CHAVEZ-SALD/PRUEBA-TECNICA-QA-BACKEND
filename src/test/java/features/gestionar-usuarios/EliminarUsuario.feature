Feature: Eliminar Usuario del Sistema

    Background:
        * def baseUrl = Url_Base_Api_Server_Rest
        * def EliminarUsuarioPath = "usuarios/:idUsuario"
        
        * def GeneracionDeValores = read('classpath:utils/js/generacionDeValores.js')
        * def OperacionesConUsuarios = read('classpath:utils/js/operacionesConUsuarios.js')
        
        * def idUsuario = karate.get("idUsuario", null)      
        
        * def responseSchemas = read("classpath:res/gestionar-usuarios/eliminar-usuario-schemas.json")
        
        * def SchemaUtils = Java.type('utils.SchemaUtils')
        

    @ELU1 @regresion @smoke-test @happypath @eliminar-usuario @util
    Scenario: Eliminar usuario existente por Id valido - 200 OK
        Given url baseUrl

        * def idUsuarioExistente = idUsuario ? idUsuario : OperacionesConUsuarios.crearUsuario(GeneracionDeValores.generarUsuarioValido())

        And path EliminarUsuarioPath.replace(":idUsuario", idUsuarioExistente)
        When method delete
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.message == "Registro excluído com sucesso"

    @ELU2 @regresion @smoke-test @unhappypath @eliminar-usuario
    Scenario: Eliminar usuario con Id no existente - 200 OK
        Given url baseUrl
        And path EliminarUsuarioPath.replace(":idUsuario", GeneracionDeValores.generarCaracteresAleatorios())
        When method delete
        Then status 200
        And assert SchemaUtils.isValid(response, responseSchemas["200"])
        And assert response.message == "Nenhum registro excluído"
    
