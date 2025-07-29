package utils;
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
}
