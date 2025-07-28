package Runner;
import com.intuit.karate.junit5.Karate;

public class RunnerTest {
	 @Karate.Test
	    Karate testZimbraFeatures() {
	        // This will run all feature files under zimbra/ package
	        return Karate.run("classpath:features/CreateAccount.feature");
	        		
	    }
}