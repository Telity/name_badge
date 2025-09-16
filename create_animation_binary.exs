#!/usr/bin/env elixir

# Script to convert PNG frames to device-optimized binary format
# Usage: elixir create_animation_binary.exs

defmodule AnimationConverter do
  def convert_frames_to_binary() do
    frame_files = [
      "photos/frame_tiny_0.png",
      "photos/frame_tiny_1.png",
      "photos/frame_tiny_2.png",
      "photos/frame_tiny_3.png",
      "photos/frame_tiny_4.png"
    ]

    IO.puts("Converting #{length(frame_files)} frames to binary format...")

    frames =
      frame_files
      |> Enum.with_index()
      |> Enum.map(fn {file, index} ->
        IO.puts("Processing frame #{index}: #{file}")
        convert_png_to_raw(file)
      end)

    binary_data = :erlang.term_to_binary(frames)

    File.write!("priv/custom_animation.bin", binary_data)

    IO.puts("Created priv/custom_animation.bin with #{length(frames)} frames")
    IO.puts("Binary size: #{byte_size(binary_data)} bytes")
  end

  defp convert_png_to_raw(png_file) do
    # Use ImageMagick to convert PNG to 400x300 grayscale raw format
    temp_file = "/tmp/frame_raw_#{:rand.uniform(10000)}.gray"

    # Convert PNG to 400x300 grayscale raw bytes
    {_output, 0} = System.cmd("convert", [
      png_file,
      "-resize", "400x300!",  # Force resize to 400x300
      "-colorspace", "Gray",   # Convert to grayscale
      "-depth", "8",           # 8-bit grayscale
      "gray:#{temp_file}"      # Output as raw grayscale
    ])

    # Read the raw bytes
    raw_data = File.read!(temp_file)

    # Clean up temp file
    File.rm!(temp_file)

    # Verify size (should be 400 * 300 = 120,000 bytes)
    expected_size = 400 * 300
    actual_size = byte_size(raw_data)

    if actual_size != expected_size do
      IO.puts("Warning: Frame size mismatch. Expected #{expected_size}, got #{actual_size}")
    end

    raw_data
  end
end

# Run the conversion
AnimationConverter.convert_frames_to_binary()