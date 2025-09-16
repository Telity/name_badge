defmodule NameBadge.Screen.GitHubQR do
  use NameBadge.Screen

  require Logger

  @github_url "https://github.com/Telity"

  @impl true
  def render(%{qr_code: qr_code}) do
    """
    #place(center + horizon,
      stack(dir: ttb, spacing: 12pt,
        text(size: 36pt, font: "New Amsterdam", "GitHub Profile"),
        image(height: 60%, format: "svg", bytes("#{qr_code}")),
        v(8pt),
        text(size: 18pt, font: "Silkscreen", "github.com/Telity")
      )
    );
    """
  end

  @impl true
  def init(_args, screen) do
    Logger.info("Generating GitHub QR code for: #{@github_url}")

    {:ok, qr_code_svg} =
      @github_url
      |> QRCode.create()
      |> QRCode.render()

    screen =
      screen
      |> assign(:qr_code, encode(qr_code_svg))
      |> assign(:button_hints, %{a: "Next", b: "Back"})

    {:ok, screen}
  end

  @impl true
  def handle_button(_, 0, screen) do
    {:render, navigate(screen, :back)}
  end

  def handle_button(_, _, screen) do
    {:norender, screen}
  end

  defp encode(str) do
    str
    |> String.replace("\\", "\\\\")
    |> String.replace("\"", "\\\"")
  end
end