package utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.SpecVersion;
import com.networknt.schema.ValidationMessage;
import java.util.Set;

public class SchemaUtils {
    
    private static final ObjectMapper mapper = new ObjectMapper();
    private static final JsonSchemaFactory factory = 
        JsonSchemaFactory.getInstance(SpecVersion.VersionFlag.V7);

    public static boolean isValid(Object jsonData, Object jsonSchema) {
        try {
            // Convertir ambos objetos a JsonNode
            JsonNode dataNode = mapper.valueToTree(jsonData);
            JsonNode schemaNode = mapper.valueToTree(jsonSchema);
            
            // Crear el schema validator
            JsonSchema schema = factory.getSchema(schemaNode);
            
            // Validar
            Set<ValidationMessage> errors = schema.validate(dataNode);
            
            if (!errors.isEmpty()) {
                System.err.println("========================================");
                System.err.println("JSON SCHEMA VALIDATION ERRORS:");
                System.err.println("========================================");
                for (ValidationMessage error : errors) {
                    System.err.println("❌ " + error.getMessage());
                    System.err.println("   Path: " + error.getPath());
                    System.err.println("   Type: " + error.getType());
                }
                System.err.println("========================================");
                return false;
            }
            
            // Si no hay errores es porque la validación fue exitosa
            return true;
            
        } catch (Exception e) {
            System.err.println("========================================");
            System.err.println("JSON SCHEMA VALIDATION EXCEPTION:");
            System.err.println("========================================");
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
            System.err.println("========================================");
            return false;
        }
    }
}