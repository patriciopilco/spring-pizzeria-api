package rest.xpoch.pizzeria.web.config;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


@Component
public class JwtAdapter {

    //@Value("${jwt.secret}")
    //private String jwtSecret;

    private String SECRET_KEY;
    private Algorithm ALGORITHM;

    @PostConstruct
    public void init() {
        SECRET_KEY = "3bec6270906972aa535e0ca0";
        ALGORITHM = Algorithm.HMAC256(SECRET_KEY);
    }

    public boolean isValid(String jwt) {
        try {
            JWT.require(ALGORITHM).build().verify(jwt);
            return true;
        } catch (JWTVerificationException e) {
            return false;
        }
    }

    public String getPayload(String jwt) {
        return JWT.decode(jwt).getPayload();
    }
}
