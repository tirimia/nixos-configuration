{ inputs, ... }:
{
  flake.modules.homeManager.sre =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.uv # TODO: move to an analysis module
        pkgs.gh
        pkgs.fd
        pkgs.coreutils
        pkgs.jq
        pkgs.yq
        pkgs.kubectl
        pkgs.kubectx
        pkgs.kubie
        pkgs.skaffold
        pkgs.k9s
        (pkgs.google-cloud-sdk.withExtraComponents (
          with pkgs.google-cloud-sdk.components;
          [
            kpt
            gke-gcloud-auth-plugin
          ]
        ))
      ];
    };
}
