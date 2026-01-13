# NVIDIA GPU Cloud

[NVIDIA GPU Cloud (NGC)](https://www.nvidia.com/en-us/gpu-cloud/) is an [online hub for models, containers, etc](https://catalog.ngc.nvidia.com/) that NVIDIA publishes that are "optimized" for NVIDIA platforms.  I'm not currently invested in fine tuning performance, so I'll take their word for it.

They have a command line binary that can be used to browse/pull models.  It's pretty handy to have really.  Grab it from the [downloads page](https://org.ngc.nvidia.com/setup/installers/cli).  There is no CLI way to download it now it seems.

I suggest placing it in `/opt/ngc-cli` then adding that to the `PATH` via a drop-in file `echo 'export PATH=/opt/ngc-cli:$PATH' > /etc/profile.d/ngc-cli.sh`.

