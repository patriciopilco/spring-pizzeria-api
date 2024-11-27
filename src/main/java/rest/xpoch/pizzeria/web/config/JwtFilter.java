package rest.xpoch.pizzeria.web.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class JwtFilter extends OncePerRequestFilter{

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String jwt = request.getHeader("Authorization");
        System.out.println("jwt: " + jwt);
        if(jwt != null && jwt.startsWith("Bearer ")){
            jwt = jwt.substring(7);
            if(JwtAdapter.isValid(jwt)){
                String payload = JwtAdapter.getPayload(jwt);
                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(null, null, List.of(new SimpleGrantedAuthority(payload)));
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }
        filterChain.doFilter(request, response);
    }


}
