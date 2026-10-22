{ config, pkgs, lib, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # Adds --experimental to bluetoothd (replaces your drop-in)
    settings.General.Experimental = true;
  };

  systemd.services."tether-btclass@" = {
    description = "Set Bluetooth Class of Device to A/V Hands-Free for Tether";
    documentation = [ "https://github.com/zackb/tether/blob/main/docs/BLUETOOTH.md" ];
    after = [ "bluetooth.service" ];
    partOf = [ "bluetooth.service" ];
    wantedBy = [ "bluetooth.service" ];

    path = [ pkgs.bluez pkgs.gnugrep pkgs.coreutils ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = 60;
    };

    # %i is the instance name (e.g. hci0)
    script = ''
      for t in $(seq 30); do
        a=%i
        [ -e /sys/class/bluetooth/$a ] || a=$(ls /sys/class/bluetooth 2>/dev/null | head -n1)
        if [ -n "$a" ]; then
          echo | btmgmt --index "$a" class 4 8 >/dev/null 2>&1
          echo | btmgmt --index "$a" info 2>/dev/null | grep -q "class 0x..0408" && exit 0
        fi
        sleep 1
      done
      exit 1
    '';
  };
}
