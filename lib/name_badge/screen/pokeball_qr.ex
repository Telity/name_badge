defmodule NameBadge.Screen.PokeballQR do
  use NameBadge.Screen

  require Logger

  @github_url "https://github.com/Telity"
  @animation_frames 8
  @frame_duration 500

  @impl true
  def render(%{state: :qr_code, qr_code: qr_code}) do
    """
    #place(center + horizon,
      stack(dir: ttb, spacing: 8pt,
        text(size: 24pt, font: "New Amsterdam", "Gotta Code 'Em All!"),
        image(height: 50%, format: "svg", bytes("#{qr_code}")),
        text(size: 16pt, font: "Silkscreen", "github.com/Telity")
      )
    );
    """
  end

  def render(%{state: :animation, frame: frame}) do
    work_art = get_work_frame(frame)
    work_text = get_work_text(frame)

    """
    #place(center + horizon,
      stack(dir: ttb, spacing: 16pt,
        text(size: 28pt, font: "New Amsterdam", "#{work_text}"),
        v(12pt),
        text(size: 14pt, font: "monospace", raw("#{work_art}")),
        v(12pt),
        text(size: 18pt, font: "Silkscreen", "Press B for GitHub!")
      )
    );
    """
  end

  @impl true
  def init(_args, screen) do
    Logger.info("Starting work animation")

    # Generate QR code for later use
    {:ok, qr_code_svg} =
      @github_url
      |> QRCode.create()
      |> QRCode.render()

    screen =
      screen
      |> assign(:state, :animation)
      |> assign(:frame, 0)
      |> assign(:qr_code, encode(qr_code_svg))
      |> assign(:button_hints, %{a: "Back", b: "GitHub QR"})

    # Start animation timer
    Process.send_after(self(), :next_frame, @frame_duration)

    {:ok, screen}
  end

  @impl true
  def handle_button("BTN_1", 0, screen) do
    {:render, navigate(screen, :back)}
  end

  def handle_button("BTN_2", 0, screen) do
    screen = assign(screen, :state, :qr_code)
    {:render, screen}
  end

  def handle_button(_, _, screen) do
    {:norender, screen}
  end


  def handle_info(:next_frame, %{assigns: %{state: :animation}} = screen) do
    new_frame = rem(screen.assigns.frame + 1, @animation_frames)
    screen = assign(screen, :frame, new_frame)

    # Continue animation
    Process.send_after(self(), :next_frame, @frame_duration)

    {:partial, screen}
  end

  def handle_info(:next_frame, screen) do
    {:norender, screen}
  end

  # Simple work-themed ASCII animation frames
  defp get_work_frame(frame) do
    frames = [
      # Frame 0-1: Computer setup
      """
      ┌─────────┐
      │ ▓▓▓▓▓▓▓ │  💻
      │ ▓▓▓▓▓▓▓ │
      └─────────┘
      """,
      """
      ┌─────────┐
      │ ░░░░░░░ │  💻
      │ ░░░░░░░ │
      └─────────┘
      """,
      # Frame 2-3: Typing
      """
      ┌─────────┐
      │ > code  │  💻 ⌨️
      │ ░░░░░░░ │
      └─────────┘
      """,
      """
      ┌─────────┐
      │ > coding│  💻 ⌨️
      │ ....    │
      └─────────┘
      """,
      # Frame 4-5: Progress
      """
      ┌─────────┐
      │ BUILD   │  💻 ⚡
      │ [████░] │
      └─────────┘
      """,
      """
      ┌─────────┐
      │ SUCCESS │  💻 ✅
      │ [██████]│
      └─────────┘
      """,
      # Frame 6-7: Coffee break
      """
      ┌─────────┐
      │ DEPLOY  │  💻 🚀
      │ ░░░░░░░ │
      └─────────┘
      """,
      """
      ┌─────────┐
      │ ☕ TIME │  💻 😊
      │ ░░░░░░░ │
      └─────────┘
      """
    ]

    Enum.at(frames, frame)
  end

  defp get_work_text(frame) when frame < 2, do: "Setup..."
  defp get_work_text(frame) when frame < 4, do: "Coding..."
  defp get_work_text(frame) when frame < 6, do: "Building..."
  defp get_work_text(_), do: "Get to Work!"

  defp encode(str) do
    str
    |> String.replace("\\", "\\\\")
    |> String.replace("\"", "\\\"")
  end
end