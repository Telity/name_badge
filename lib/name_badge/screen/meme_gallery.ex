defmodule NameBadge.Screen.MemeGallery do
  use NameBadge.Screen

  require Logger

  @art_gallery [
    %{
      title: "Dev Life",
      art: """
      ╭─────────────────╮
      │ while(true) {   │
      │   coffee();     │ ☕
      │   code();       │ 💻
      │   debug();      │ 🐛
      │   repeat();     │ 🔄
      │ }               │
      ╰─────────────────╯

      Life.exe is running...
      """,
      subtitle: "The eternal loop"
    },
    %{
      title: "Current Mood",
      art: """
      ┌───────────────┐
      │               │
      │  ¯\\_(ツ)_/¯   │ 😅
      │               │
      │ "It works on  │
      │  my machine"  │
      │               │
      └───────────────┘

      Status: OPTIMISTIC
      """,
      subtitle: "Works for me!"
    }
  ]

  @impl true
  def render(%{current_art: art_index}) do
    art_piece = Enum.at(@art_gallery, art_index)

    """
    #place(center + horizon,
      stack(dir: ttb, spacing: 10pt,
        text(size: 24pt, font: "New Amsterdam", "#{art_piece.title}"),
        v(8pt),
        text(size: 11pt, font: "monospace", raw("#{art_piece.art}")),
        v(8pt),
        text(size: 16pt, font: "Silkscreen", "#{art_piece.subtitle}"),
        v(6pt),
        text(size: 12pt, "#{art_index + 1}/#{length(@art_gallery)}")
      )
    );
    """
  end

  @impl true
  def init(_args, screen) do
    screen =
      screen
      |> assign(:current_art, 0)
      |> assign(:total_art, length(@art_gallery))
      |> assign(:button_hints, %{a: "Next Art", b: "Back"})

    {:ok, screen}
  end

  @impl true
  def handle_button("BTN_1", 0, screen) do
    new_index = rem(screen.assigns.current_art + 1, screen.assigns.total_art)
    screen = assign(screen, :current_art, new_index)
    {:render, screen}
  end

  def handle_button("BTN_2", 0, screen) do
    {:render, navigate(screen, :back)}
  end

  def handle_button(_, _, screen) do
    {:norender, screen}
  end
end