![Spring Logo](images\spring-boot-security.png) <!-- .element: style="border-width: 0;" -->
# Spring Security & OpenID Connect

--

## Inhoud

* Wat is Spring (Boot)?
* Wat is Spring Security?
* Waarom Spring Security?
* Waarom OpenID Connect?
* Hoe te implementeren?

---

## Wat is spring (Boot)?
### Spring
* Spring is een Java _Framework_
* Dependency Injection
* Data Access
* etc.

--

## Wat is spring (Boot)?
### Spring Boot
* Vereenvoudigt configuratie met auto-configurators
* Maakt het mogelijk servlet apps standalone te draaien

--

## Wat is Spring Security
* Authentication & Authorization
* Beschermt tegen diverse aanvallen
  - Session Fixation
  - Clickjacking
  - XSRF
* Security op request niveau

--

## Waaron OpenID Connect?
* Biedt authenticatie uit een centrale bron
* Biedt authorizatie
* Vermindert risico's van passwordgebruik

---

### Hoe te implementeren
1. Registreer bij een OpenID provider
2. Configureer spring security
3. Pas security toe op controllers

--

![Oauth2 Flow](images\active-directory-oauth-code-flow-web-app.png)

--

### Registered APP

* https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/Overview/appId/81eac4d7-1674-446c-baad-66900725ee88/isMSAApp/

--

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
  <groupId>com.microsoft.azure</groupId>
  <artifactId>azure-active-directory-spring-boot-starter</artifactId>
  <version>2.2.0</version>
</dependency>
```

--

```yaml
azure:
  activedirectory:
    active-directory-groups: AquariumAppTest, Admin
    tenant-id: c3855cb8-41c4-4c7f-917b-3ebbd50f36e1
security:
    oauth2:
      client:
        provider:
          azure-oauth-provider:
            authorization-uri: https://login.microsoftonline.com/c3855cb8-41c4-4c7f-917b-3ebbd50f36e1/oauth2/authorize
            token-uri: https://login.microsoftonline.com/c3855cb8-41c4-4c7f-917b-3ebbd50f36e1/oauth2/token
            user-info-uri: https://login.microsoftonline.com/c3855cb8-41c4-4c7f-917b-3ebbd50f36e1/openid/userinfo
            jwk-set-uri: https://login.microsoftonline.com/c3855cb8-41c4-4c7f-917b-3ebbd50f36e1/discovery/keys

        registration:
          azure:
            provider: azure-oauth-provider
            client-id: 81eac4d7-1674-446c-baad-66900725ee88
            client-secret: _secret_
```

--

```java
@Configuration
public class AzureAdSecurityConfiguration extends WebSecurityConfigurerAdapter {

  @Autowired
  private OAuth2UserService<OidcUserRequest, OidcUser> oidcUserService;


  protected void configure(HttpSecurity http) throws Exception {
    http
      .authorizeRequests()
          .anyRequest().authenticated()
      .and()
          .oauth2Login()
          .userInfoEndpoint()
          .oidcUserService(oidcUserService)
      .and().defaultSuccessUrl("/")
      ;
  }
```

---

### Bronnen

* https://github.com/microsoft/azure-spring-boot
* https://spring.io/guides/gs/securing-web
* https://spring.io/guides/topicals/spring-security-architecture

--

### Deze slides

* https://wouterhummelink.github.io/slides/springboot_oauth.html
