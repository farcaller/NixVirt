stuff@{ packages, ... }:
{ name
, uuid
, memory ? { count = 4; unit = "GiB"; }
, storage_vol_path
, install_vol_path ? null
, virtio_video ? true
, ...
}:
let
  base = import ./base.nix stuff
    {
      inherit name uuid memory storage_vol_path install_vol_path virtio_video;
      virtio_net = true;
    };
in
base //
{
  devices = base.devices //
  {
    channel = base.devices.channel ++
    [
      {
        type = "unix";
        target = { type = "virtio"; name = "org.qemu.guest_agent.0"; };
      }
    ];
    rng =
      {
        model = "virtio";
        backend = { model = "random"; source = /dev/urandom; };
      };
  };
}
