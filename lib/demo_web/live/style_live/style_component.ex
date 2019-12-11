defmodule DemoWeb.StyleLive.StyleComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <%= @style %>
    """
  end
end
