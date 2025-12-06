package utils;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.networknt.schema.JsonSchema;
import com.networknt.schema.JsonSchemaFactory;
import com.networknt.schema.ValidationMessage;
import java.util.Set;

public class SchemaUtils {
    
    public static boolean isValid(String jsonData, String jsonSchema) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonSchemaFactory factory = JsonSchemaFactory.getInstance();
            
            JsonSchema schema = factory.getSchema(jsonSchema);
            JsonNode jsonNode = mapper.readTree(jsonData);
            
            Set<ValidationMessage> errors = schema.validate(jsonNode);
            return errors.isEmpty();
            
        } catch (Exception e) {
            return false;
        }
    }
}