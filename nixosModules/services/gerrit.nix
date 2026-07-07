{
  fn,
  pkgs,
  config,
  ...
}: {
  services = fn.ifHost "uriel" {
    gerrit = {
      package = pkgs.gerrit.overrideAttrs {patches = [./0001-nuke-AI-features.patch];};
      enable = true;
      serverId = "a8888a06-4fc9-4f11-9a8d-139c80df39dc";
      settings = {
        auth = {
          type = "HTTP";
          httpHeader = "X-Forwarded-User";
          logoutUrl = "https://hl.squishcat.net/oauth2/sign_out?rd=https://hl.squishcat.net/";
        };
        gerrit.canonicalWebUrl = "https://hl.squishcat.net/";
        httpd.listenUrl = "proxy-https://127.0.0.1:8080/";
        sshd.listenAddress = "*:29418";
      };
      plugins = [
        (builtins.getFlake "github:Notarin/nix-gerrit?rev=f24d697816ccb07ae3d71ebd86cb39bf7ee6c099").packages.x86_64-linux.download-commands
      ];
    };
    oauth2-proxy = {
      enable = true;

      provider = "oidc";

      redirectURL = "https://hl.squishcat.net/oauth2/callback";
      oidcIssuerUrl = "https://account.spacestation14.com";

      clientID = "87791c15-801c-4f9d-b313-7cf66c306aad";
      clientSecretFile = config.sops.secrets.ss14-oauth-secret.path;
      cookie.secretFile = config.sops.secrets.oauth2-cookie-secret.path;
      email.domains = ["*"];

      scope = "openid profile email";

      setXauthrequest = true;
      passAccessToken = true;
      reverseProxy = true;
      extraConfig = {
        user-id-claim = "preferred_username";
        code-challenge-method = "S256";
        trusted-proxy-ip = "127.0.0.1";
      };
    };

    nginx = {
      enable = true;
      virtualHosts."hl.squishcat.net" = {
        useACMEHost = "squishcat.net";
        forceSSL = true;
        locations = {
          "/oauth2/" = {
            proxyPass = "http://127.0.0.1:4180";
            extraConfig = ''
              proxy_set_header Host                    $host;
              proxy_set_header X-Real-IP               $remote_addr;
              proxy_set_header X-Auth-Request-Redirect $request_uri;
              proxy_set_header Cookie                  $http_cookie;
            '';
          };
          "/oauth2/auth" = {
            proxyPass = "http://127.0.0.1:4180";
            extraConfig = ''
              proxy_set_header Host             $host;
              proxy_set_header X-Real-IP        $remote_addr;
              proxy_set_header X-Forwarded-Uri  $request_uri;
              proxy_set_header Content-Length   "";
              proxy_pass_request_body           off;
            '';
          };
          "/tools/hooks/commit-msg" = {
            proxyPass = "http://127.0.0.1:8080";
            extraConfig = ''
              proxy_set_header Host              $host;
              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host  $host;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            '';
          };
          "/" = {
            proxyPass = "http://127.0.0.1:8080";
            extraConfig = ''
              auth_request /oauth2/auth;
              error_page 401 = @oauth2_signin;
              auth_request_set $user $upstream_http_x_auth_request_preferred_username;
              auth_request_set $email $upstream_http_x_auth_request_email;

              proxy_set_header X-Forwarded-User $user;
              proxy_set_header X-Email $email;
              auth_request_set $token  $upstream_http_x_auth_request_access_token;
              proxy_set_header X-Forwarded-User $user;
              proxy_set_header X-Access-Token $token;
              auth_request_set $auth_cookie $upstream_http_set_cookie;
              add_header Set-Cookie $auth_cookie;
              auth_request_set $auth_cookie_name_upstream_1 $upstream_cookie_auth_cookie_name_1;
              if ($auth_cookie ~* "(; .*)") {
              	set $auth_cookie_name_0 $auth_cookie;
              	set $auth_cookie_name_1 "auth_cookie_name_1=$auth_cookie_name_upstream_1$1";
              }
              if ($auth_cookie_name_upstream_1) {
              	add_header Set-Cookie $auth_cookie_name_0;
              	add_header Set-Cookie $auth_cookie_name_1;
              }
            '';
          };
        };
        extraConfig = ''
          location @oauth2_signin {
            return 302 /oauth2/sign_in?rd=$scheme://$host$request_uri;
          }
        '';
      };
    };
  };

  #security.acme = {
  #	acceptTerms = true;
  #	defaults.email = "drkellinbox@gmail.com"; # might have to use mine but idkkk
  #	certs = {
  #		"gerrit" = {
  #			domain = "hl.squishcat.net";
  #			group = "nginx";
  #			dnsProvider = "cloudflare";
  #			credentialsFile = config.sops.secrets."cloudflare-api-token".path;
  #		};
  #	};
  #};

  networking.firewall = {
    allowedTCPPorts = [80 29418 443];
  };
}
