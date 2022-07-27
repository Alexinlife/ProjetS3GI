package ca.usherbrooke.fgen.api.service;

import ca.usherbrooke.fgen.api.business.Horaire;
import ca.usherbrooke.fgen.api.persistence.horaireMapper;
import org.jsoup.parser.Parser;

import org.keycloak.KeycloakPrincipal;
import org.keycloak.KeycloakSecurityContext;
import org.keycloak.adapters.springsecurity.token.KeycloakAuthenticationToken;
import org.keycloak.authorization.client.AuthzClient;
import org.keycloak.authorization.client.Configuration;
import org.keycloak.representations.AccessToken;
import org.keycloak.representations.AccessTokenResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)

@Service
public class KeycloakService {

    private final String authServerUrl = "http://localhost:8180";
    private final String realm = "usager";
    private final String clientId = "backend";
    private final String clientSecret = "secret";
    private final String grant_type = "password";

    private final Configuration configuration;

    @GET
    @Path("KeyCloakService")
    public KeycloakService() {
        Map<String, Object> clientCredentials = new HashMap<>();
        clientCredentials.put("secret", clientSecret);
        clientCredentials.put("grant_type", grant_type);

        configuration = new Configuration(authServerUrl, realm, clientId, clientCredentials, null);
    }

    @GET
    @Path("login/{username}/{password}")
    public ResponseEntity<AccessTokenResponse> login(@PathParam("username")string username, @PathParam("paaword") string password) {

        AuthzClient authzClient = AuthzClient.create(configuration);
        try {
            return ResponseEntity.ok(authzClient.obtainAccessToken(username, password));
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
    }

    @GET
    @Path("getConnectedUserCip")
    public String getConnectedUserCip() {
        KeycloakAuthenticationToken authentication = (KeycloakAuthenticationToken) SecurityContextHolder.getContext()
                .getAuthentication();

        Principal principal = (Principal) authentication.getPrincipal();
        String userCip = "";

        if (principal instanceof KeycloakPrincipal) {

            KeycloakPrincipal<KeycloakSecurityContext> kPrincipal = (KeycloakPrincipal<KeycloakSecurityContext>) principal;
            AccessToken token = kPrincipal.getKeycloakSecurityContext().getToken();
            userCip = token.getPreferredUsername().toUpperCase();
            System.out.println(userCip);
        }

        return userCip;
    }

    @GET
    @Path("logout")
    public void logout() {
    }
}
