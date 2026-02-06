{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    home = "/srv/ollama";
    user = "ollama";
    group = "ollama";
    host = "http://0.0.0.0";
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0";
      OLLAMA_ORIGINES = "*";
    };
  };
}
