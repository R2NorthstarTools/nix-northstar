{ pkgs, ... }:
rec {
  repak = pkgs.callPackage ./repak { };
  mrvn-radiant = pkgs.callPackage ./mrvn-radiant { };
  maxima = pkgs.callPackage ./maxima { maxima-unwrapped = maxima-unwrapped; };
  maxima-unwrapped = pkgs.callPackage ./maxima-unwrapped { };
  sqformat = pkgs.callPackage ./sqformat { };
}
