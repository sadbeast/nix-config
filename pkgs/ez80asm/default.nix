{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "ez80asm";
  version = "1.11";

  meta = with lib; {
    description = "ez80 assembler, running natively on the Agon platform";
    homepage = "https://github.com/envenomator/agon-ez80asm";
    license = licenses.mit;
    platforms = platforms.linux;
    # maintainers = [ maintainers.sadbeast ];
  };

  src = fetchFromGitHub {
    owner = "envenomator";
    repo = "agon-ez80asm";
    rev = "v${version}";
    hash = "sha256-0AOblG3QGRpdUzoSffhFaRjgOCmbu3WFjvOiiA4NT8U=";
  };

  installPhase = ''
    mkdir --parents "$out/bin"
    cp ./bin/ez80asm "$out/bin"
  '';
}
