self: super: {
  # Additions, which can import custom packages
  additions = final: prev: import ../pkgs { pkgs = final; };

  # Modifications to existing packages
  modifications = final: prev: {
    # Override the spotify package to include spotiblock functionality
    spotiblock = prev.spotify.overrideAttrs (oldAttrs: rec {
      postInstall = ''
        ExecMe="env LD_PRELOAD=${prev.spotify-adblock}/lib/libspotifyadblock.so spotify"
        sed -i "s|^TryExec=.*|TryExec=$ExecMe %U|" $out/share/applications/spotify.desktop
        sed -i "s|^Exec=.*|Exec=$ExecMe %U|" $out/share/applications/spotify.desktop
      '';
    });

    # Modify the steam package to include forced desktop scaling
    steam-scaling = prev.steamPackages.steam-fhsenv.override (oldAttrs: rec {
      extraArgs = (oldAttrs.extraArgs or "") + " -forcedesktopscaling 1.0 ";
    });
  };
}
