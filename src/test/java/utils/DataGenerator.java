package utils;
import java.util.HashMap;
import java.util.Map;

import com.github.javafaker.Faker;

public class DataGenerator {
    private static final Faker faker = new Faker();
    
    public static String getRandomFirstName() {
        return faker.name().firstName();
    }
    
    public static String getRandomLastName() {
        return faker.name().lastName();
    }
    
    public static String getRandomEmail() {
        return faker.internet().emailAddress();
    }
    
    public static String getRandomPhoneNumber() {
        return faker.phoneNumber().phoneNumber();
    }
    
    public static int getRandomInteger(int min, int max) {
        return faker.number().numberBetween(min, max);
    }
    
    public static String getRandomAddress() {
        return faker.address().streetAddress();
    }
    
    public static String getRandomCity() {
        return faker.address().city();
    }
    
    public static boolean getRandomBoolean() {
        return faker.bool().bool();
    }
    
    public static Map<String, String> getCompleteContactData() {
        Map<String, String> contactData = new HashMap<>();
        
        // Basic Info
        contactData.put("firstName", faker.name().firstName());
        contactData.put("lastName", faker.name().lastName());
        contactData.put("middleName", faker.name().firstName().substring(0, 1));
        contactData.put("email", faker.internet().emailAddress());
        contactData.put("email2", faker.internet().emailAddress());
        contactData.put("email3", faker.internet().emailAddress());
        
        // Company Info
        contactData.put("company", faker.company().name());
        contactData.put("jobTitle", faker.job().title());
        
        // Phone Numbers
        contactData.put("workPhone", faker.phoneNumber().phoneNumber());
        contactData.put("workPhone2", faker.phoneNumber().phoneNumber());
        contactData.put("homePhone", faker.phoneNumber().phoneNumber());
        contactData.put("homePhone2", faker.phoneNumber().phoneNumber());
        contactData.put("mobilePhone", faker.phoneNumber().cellPhone());
        contactData.put("callbackPhone", faker.phoneNumber().phoneNumber());
        contactData.put("carPhone", faker.phoneNumber().phoneNumber());
        contactData.put("otherPhone", faker.phoneNumber().phoneNumber());
        contactData.put("pager", faker.number().digits(4));
        
        // Fax Numbers
        contactData.put("workFax", faker.number().digits(4));
        contactData.put("homeFax", faker.number().digits(4));
        contactData.put("otherFax", faker.number().digits(4));
        
        // Work Address
        contactData.put("workStreet", faker.address().streetAddress());
        contactData.put("workCity", faker.address().city());
        contactData.put("workState", faker.address().state());
        contactData.put("workPostalCode", faker.address().zipCode());
        contactData.put("workCountry", faker.address().country());
        contactData.put("workURL", faker.internet().url());
        
        // Notes
        contactData.put("notes", faker.lorem().paragraph());
        
        return contactData;
    }
}
