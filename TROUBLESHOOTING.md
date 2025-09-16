# Troubleshooting Guide

## Firmware Compilation Issues

### squashfs Error

**Problem**: Getting error "squashfs is required by the Nerves tooling"

**Cause**: Missing squashfs tools required for creating the firmware image

**Solution**:
1. The project uses devenv for development environment
2. Make sure `squashfsTools` is included in `devenv.nix` packages:
   ```nix
   packages = with pkgs; [
     # ... other packages
     squashfsTools  # NOT squashfs-tools-ng
     # ... other packages
   ];
   ```
3. Reload the devenv environment: `direnv reload`
4. Run firmware compilation within devenv context

### Environment Variables

**Problem**: RuntimeError about missing BASE_URL environment variable

**Cause**: The application requires BASE_URL to be set during compilation

**Solution**: Set the required environment variables before compilation:
```bash
BASE_URL=goatmire.fly.dev MIX_TARGET=trellis mix firmware
```

From the README, the correct values are:
- `BASE_URL=goatmire.fly.dev`
- `MIX_TARGET=trellis`

### Running Commands in devenv

**Correct way to run commands**:
```bash
# Using direnv (if .envrc is set up)
direnv exec . bash -c 'BASE_URL=goatmire.fly.dev MIX_TARGET=trellis mix firmware'

# Or enter devenv shell first
devenv shell
# Then run: BASE_URL=goatmire.fly.dev mix firmware
```

**Note**: The devenv.nix already sets `MIX_TARGET=trellis` in the environment, so you only need to set BASE_URL when inside the devenv shell.

### Package Dependencies

The project requires these key packages in devenv.nix:
- `squashfsTools` - for creating firmware images (provides mksquashfs)
- `fwup` - for firmware updates
- `elixir` - language runtime
- `rust` with `armv7-unknown-linux-gnueabihf` target

### Common Commands

After successful setup:
- **Build firmware**: `BASE_URL=goatmire.fly.dev mix firmware`
- **Upload to device**: `mix upload`
- **Burn to SD card**: `mix burn`
- **Generate upload script**: `mix firmware.gen.script`

The firmware file is created at: `_build/trellis_dev/nerves/images/name_badge.fw`