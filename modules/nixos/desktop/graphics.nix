# AMD GPU configuration for Wayland
# Ryzen 6800H with RDNA2 integrated graphics
_:
{
  # OpenGL/Vulkan support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # 32-bit app support
  };

  # Mesa Vulkan drivers are included by default
  # RADV (Mesa) is preferred over AMDVLK for most use cases
}
