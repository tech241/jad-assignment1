package servlets;

import org.mindrot.jbcrypt.BCrypt;

public class bcryptHelper {
	static String salt = BCrypt.gensalt();
	
	public static String hash (String password) {
		return BCrypt.hashpw(password, salt);
	}
	
	public static boolean check (String password, String hash) {
		return BCrypt.checkpw(password, hash);
	}
}