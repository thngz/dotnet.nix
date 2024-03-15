{
  description = "Simple dotnet flake";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [ 
            jetbrains.rider 
            dotnetCorePackages.dotnet_8.sdk
            postgresql
        ];

        shellHook = ''
          echo "i run"
          dotnet new tool-manifest
          dotnet tool install dotnet-ef
          dotnet tool install dotnet-aspnet-codegenerator
        '';
      };
    };
}
