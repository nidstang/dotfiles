{ pkgs, ... }:

let
  ralph = pkgs.writeShellApplication {
    name = "ralph";
    runtimeInputs = with pkgs; [ docker git curl ];
    text = builtins.readFile ../files/scripts/ralph.sh;
  };
in
{
  home.packages = [ ralph ];
}
