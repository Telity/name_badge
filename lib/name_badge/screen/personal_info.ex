defmodule NameBadge.Screen.PersonalInfo do
  use NameBadge.Screen

  require Logger

  @name "Nikolaj Gundstrup"
  @email "Gunniko@gmail.com"
  @title "Developer"

  @impl true
  def render(_assigns) do
    """
    #place(center + horizon,
      stack(dir: ttb, spacing: 18pt,
        text(size: 64pt, font: "New Amsterdam", "#{@name}"),
        v(8pt),
        text(size: 36pt, font: "Silkscreen", "#{@title}"),
        v(12pt),
        text(size: 40pt, font: "New Amsterdam", "🔍 Looking for Internship"),
        v(16pt),
        stack(dir: ttb, spacing: 10pt,
          text(size: 26pt, "📧 #{@email}"),
          text(size: 26pt, "🐙 github.com/Telity"),
          text(size: 26pt, "💻 Nerves Enthusiast")
        ),
        v(12pt),
        text(size: 22pt, "Available for interesting projects!")
      )
    );
    """
  end

  @impl true
  def init(_args, screen) do
    screen =
      screen
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
end