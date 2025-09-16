defmodule NameBadge.Screen.Animation do
  use NameBadge.Screen

  alias NameBadge.Display

  require Logger

  @frame_count 5

  @impl true
  def render(_assigns) do
    # Return empty string since we're drawing directly to display
    ""
  end

  @impl true
  def init(_args, screen) do
    # Load the binary frames
    frames =
      Application.app_dir(:name_badge, "priv/custom_animation.bin")
      |> File.read!()
      |> :erlang.binary_to_term()

    # Start the animation timer
    Process.send_after(self(), :next_frame, 500)

    screen =
      screen
      |> assign(:current_frame, 0)
      |> assign(:frames, frames)
      |> assign(:button_hints, %{a: "Next", b: "Back"})

    # Draw the first frame
    first_frame = Enum.at(frames, 0)
    Display.draw(first_frame, refresh_type: :partial)

    {:ok, screen}
  end

  def handle_info(:next_frame, screen) do
    current_frame = screen.assigns.current_frame
    next_frame = rem(current_frame + 1, @frame_count)

    # Draw the current frame
    frame = Enum.at(screen.assigns.frames, next_frame)
    Display.draw(frame, refresh_type: :partial)

    # Schedule next frame
    Process.send_after(self(), :next_frame, 500)

    screen = assign(screen, :current_frame, next_frame)
    {:norender, screen}
  end

  @impl true
  def handle_button(_, 0, screen) do
    {:render, navigate(screen, :back)}
  end

  def handle_button(_, _, screen) do
    {:norender, screen}
  end
end