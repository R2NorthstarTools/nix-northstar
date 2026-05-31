{ pkgs, ... }:
{
  repak = pkgs.callPackage ./repak { };
  mrvn-radiant = pkgs.callPackage ./mrvn-radiant { };
  maxima = pkgs.callPackage ./maxima { };
  sqformat = pkgs.callPackage ./sqformat { };
}
