package rest.xpoch.pizzeria.web.config;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import org.springframework.stereotype.Component;


@Component
public class JwtAdapter {

    private static final String SECRET_KEY = "3bec6270906972aa535e0ca0";
    private static final Algorithm ALGORITHM = Algorithm.HMAC256(SECRET_KEY);

    static public boolean isValid(String jwt) {
        try {
            JWT.require(ALGORITHM).build().verify(jwt);
            return true;
        } catch (JWTVerificationException e) {
            return false;
        }
    }

    static public String getPayload(String jwt) {
        return JWT.decode(jwt).getPayload();
    }
}
