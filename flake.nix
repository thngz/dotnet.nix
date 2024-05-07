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
            bruno
        ];

        shellHook = ''
            echo "i run"
            dotnet new tool-manifest
            dotnet tool install dotnet-ef
            dotnet tool install dotnet-aspnet-codegenerator
            
            #Start postgres
            
            export PG=$PWD/.dev_postgres/
            export PGDATA=$PG/data
            export PGPORT=5432
            export PGHOST=localhost
            export PGUSER=$USER
            export PGPASSWORD=postgres
            export PGDATABASE=foo
            export DB_URL=postgres://$PGUSER:$PGPASSWORD@$PGHOST:$PGPORT/$PGDATABASE

            pg_setup() {
              pg_ctl -D $PGDATA stop;
              rm -rf $PG;
              initdb -D $PGDATA &&
              echo "unix_socket_directories = '$PGDATA'" >> $PGDATA/postgresql.conf &&
              pg_ctl -D $PGDATA -l $PG/postgres.log start &&
              createdb
            }
        '';
      };
    };
}
