{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.zola
    pkgs.imagemagick
    pkgs.inkscape
    pkgs.typst
    pkgs.inter
    pkgs.ibm-plex
  ];

  processes = {
    zola.exec = "zola serve";
  };
  languages.python = {
    enable = true;
    venv.enable = true;
    venv.requirements = lib.readFile ./cv-build/requirements.txt;
  };

  env.TYPST_FONT_PATHS = "${pkgs.inter}/share/fonts/truetype:${pkgs.ibm-plex}/share/fonts/opentype";

  git-hooks.hooks.build = {
    enable = false;
    name = "Build site before committing";
    entry = "zola build";
    pass_filenames = false;
  };

}
