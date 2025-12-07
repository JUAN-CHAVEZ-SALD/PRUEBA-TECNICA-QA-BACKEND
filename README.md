# Prueba Técnica QA Backend - Proyecto de Automatización de Pruebas de API con Karate DSL

Este proyecto contiene pruebas automatizadas para una API REST de gestión de usuarios. Las pruebas están desarrolladas con [Karate](https://github.com/karatelabs/karate), un framework de código abierto para la automatización de pruebas de API.

## Autor

Juan Manuel Chavez Saldaña 

## Tecnologías y Dependencias

*   **Java 17**: Lenguaje de programación base.
*   **Maven**: Herramienta para la gestión de dependencias y construcción del proyecto.
*   **Karate**: Framework para la automatización de pruebas de API.
*   **JUnit 5**: Framework de pruebas para la ejecución de los tests de Karate.
*   **Cucumber Reporting**: Herramienta para la generación de reportes de prueba en formato HTML.
*   **JavaFaker**: Librería para la generación de datos de prueba aleatorios.
*   **JSON Schema Validator**: Librería para la validación de esquemas JSON.

## Estructura del Proyecto

El proyecto sigue la estructura estándar de un proyecto de Karate con Maven:

```
.
├── pom.xml
├── README.md
└── src
    └── test
        └── java
            ├── karate-config.js
            ├── logback-test.xml
            ├── features
            │   ├── RunnerTests.java
            │   └── gestionar-usuarios
            │       ├── ActualizarUsuario.feature
            │       ├── EliminarUsuario.feature
            │       ├── ListarUsuarios.feature
            │       ├── ObtenerUsuarioPorId.feature
            │       └── RegistrarUsuario.feature
            ├── req
            │   └── gestionar-usuarios
            │       ├── body-actualizar-usuario.json
            │       └── body-registrar-usuario.json
            ├── res
            │   └── gestionar-usuarios
            │       ├── actualizar-usuario-schemas.json
            │       ├── eliminar-usuario-schemas.json
            │       ├── listar-usuarios-schemas.json
            │       ├── obtener-usuario-por-id-schemas.json
            │       └── registrar-usuario-schemas.json
            └── utils
                ├── SchemaUtils.java
                └── js
                    └── gestionar-usuarios
                        ├── generacionDeValores.js
                        └── operacionesConUsuarios.js
```

-   `src/test/java/features`: Contiene los archivos `.feature` de Karate con los escenarios de prueba.
-   `src/test/java/req`: Almacena los cuerpos de las peticiones en formato JSON.
-   `src/test/java/res`: Contiene los esquemas JSON para la validación de las respuestas.
-   `src/test/java/utils`: Incluye utilidades en Java y JavaScript para la generación de datos y otras operaciones.
-   `karate-config.js`: Archivo de configuración global para Karate.
-   `pom.xml`: Archivo de configuración de Maven con las dependencias y plugins del proyecto.

## Prerrequisitos

*   Tener instalado **Java 17** o una versión superior.
*   Tener instalado **Maven**.

## Instalación

1.  Clonar el repositorio:
    ```sh
    git clone <URL_DEL_REPOSITORIO>
    ```
2.  Navegar al directorio del proyecto:
    ```sh
    cd PRUEBA-TECNICA-QA-BACKEND
    ```
3.  Instalar las dependencias de Maven:
    ```sh
    mvn install
    ```

## Ejecución de las Pruebas

### Ejecutar todas las pruebas

Para ejecutar todas las pruebas de regresión, utilice el siguiente comando de Maven. Este comando limpiará el proyecto y luego ejecutará los tests.

```sh
mvn clean test
```

### Ejecutar pruebas por tags

Es posible ejecutar un subconjunto de pruebas utilizando los tags de Karate. Los tags se especifican en los archivos `.feature`. Para pasar los tags, se utiliza la propiedad `karate.options`.

La sintaxis para pasar argumentos puede variar según el sistema operativo.

**Windows (cmd o PowerShell):**

En Windows, es una buena práctica incluir toda la propiedad `-D` entre comillas.

```sh
# Ejemplo para ejecutar los escenarios de @smoke-test en Windows
mvn clean test "-Dkarate.options=--tags @smoke-test"
```

**Linux / macOS:**

En sistemas basados en Unix como Linux y macOS, puedes pasar el argumento sin comillas adicionales, aunque usarlas también es válido.

```sh
# Ejemplo para ejecutar los escenarios de @smoke-test en Linux/macOS
mvn clean test -Dkarate.options="--tags @smoke-test"
```

Algunos de los tags disponibles en este proyecto son:

-   `@regresion`: Para todas las pruebas de regresión.
-   `@smoke-test`: Para un conjunto reducido de pruebas críticas.
-   `@happypath`: Para los escenarios de "camino feliz".
-   `@unhappypath`: Para los escenarios de "camino triste" o de error.
-   `@actualizar-usuario`, `@eliminar-usuario`, etc.: Tags específicos por funcionalidad.

## Reportes de Pruebas

Después de la ejecución de las pruebas, se genera un reporte HTML en el directorio `target/cucumber-html-reports`.

Abra el archivo `overview-features.html` en su navegador para ver un reporte detallado de la ejecución de las pruebas.