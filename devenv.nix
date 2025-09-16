{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.MIX_TARGET = "trellis";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    # Nerves system dependencies
    fwup
    squashfsTools
    coreutils
    unzip
    zip
    mtools
    dosfstools
    # Build tools
    gnumake
    gcc
    pkg-config
    autoconf
    automake
    # USB flashing tools (optional)
    sunxi-tools
  ];

  # https://devenv.sh/languages/
  languages.elixir = {
    enable = true;
    package = pkgs.elixir_1_18;
  };

  languages.rust = {
    enable = true;
    channel = "stable";
    targets = [ "armv7-unknown-linux-gnueabihf" ];
  };

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.firmware.exec = ''
    export MIX_TARGET=trellis
    mix firmware
  '';

  scripts.upload.exec = ''
    export MIX_TARGET=trellis
    mix upload
  '';

  scripts.burn.exec = ''
    export MIX_TARGET=trellis
    mix burn
  '';

  enterShell = ''
    echo "🚀 Nerves Name Badge Development Environment"
    echo "📱 Target: $MIX_TARGET"
    echo "🔧 Available commands: firmware, upload, burn"
    mix --version
    rustc --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
    mix test
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
