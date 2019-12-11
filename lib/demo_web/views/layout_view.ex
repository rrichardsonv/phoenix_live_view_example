defmodule DemoWeb.LayoutView do
  use DemoWeb, :view

  defp styled_components(conn) do
    live_render(conn, DemoWeb.StyleLive)
  end
end
