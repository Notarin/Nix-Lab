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
      jvmHeapLimit = "6g";
      settings = {
        auth = {
          type = "HTTP";
          httpHeader = "X-Forwarded-User";
          httpEmailHeader = "X-Forwarded-Email";
          logoutUrl = "https://hl.squishcat.net/oauth2/sign_out?rd=https://hl.squishcat.net/";
        };
        gerrit.canonicalWebUrl = "https://hl.squishcat.net/";
        httpd.listenUrl = "proxy-https://127.0.0.1:8080/";
        sshd.listenAddress = "*:29418";
        core = {
          packedGitOpenFiles = "4096";
          packedGitLimit = "2g";
          deltaBaseCacheLimit = "128m";
        };
        gc = {
          autobg = "true";
          aggressive = "true";
        };
        pack = {
          indexObjectsWithoutSize = "true";
          window = "250";
          depth = "250";
          compression = "9";
        };
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
        whitelist-domain = "hl.squishcat.net";
        standard-logging = true;
        auth-logging = true;
        request-logging = true;
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

              auth_request_set $saved_set_cookie $upstream_http_set_cookie;
              add_header Set-Cookie $saved_set_cookie;
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
          "~ ^/([^/]+)/info/refs$|^/([^/]+)/git-upload-pack$|^/([^/]+)/git-receive-pack$" = {
            proxyPass = "http://127.0.0.1:8080";
            extraConfig = ''
              auth_request off;
              proxy_set_header Host              $host;
              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host  $host;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;

              proxy_set_header Authorization $http_authorization;
              proxy_pass_header Authorization;

              # Hardening adjustments for huge Git packfiles:
              client_max_body_size       0;        # Disable request body size limits
              proxy_connect_timeout      3000s;     # Give backend time to spin up loose objects
              proxy_read_timeout         12000s;    # Keep connection alive during giant pack streams
              proxy_send_timeout         12000s;
              proxy_buffering            off;
            '';
          };
          "/" = {
            proxyPass = "http://127.0.0.1:8080";
            extraConfig = ''
              # 1. Protect the entire application route via oauth2-proxy
              auth_request /oauth2/auth;
              error_page 401 = @oauth2_signin;

              # 2. Extract identity parameters from the auth container
              auth_request_set $preferred_user $upstream_http_x_auth_request_preferred_username;
              auth_request_set $token $upstream_http_x_auth_request_access_token;
              auth_request_set $auth_cookie $upstream_http_set_cookie;

              # 3. Explicitly pass identity context down to Gerrit
              proxy_set_header X-Forwarded-User $preferred_user;
              proxy_set_header X-Access-Token $token;
              proxy_set_header X-Forwarded-Email "";

              # 4. Standard reverse proxy header pass
              proxy_set_header Host              $host;
              proxy_set_header X-Real-IP         $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host  $host;
              proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;

              # 5. Pass auth-proxy cookies back down to browser smoothly
              add_header Set-Cookie $auth_cookie;

              # 6. Large buffers to prevent large cookie payload drops
              proxy_buffer_size          128k;
              proxy_buffers            4 256k;
              proxy_busy_buffers_size    256k;
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

  networking.firewall = {
    allowedTCPPorts = [80 29418 443];
  };
}
