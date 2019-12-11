defmodule DemoWeb.StyleLive do
  use Phoenix.LiveView, id: "style-live", container: {:style, []}
  alias DemoWeb.StyleLive.Style
  alias DemoWeb.StyleLive.Styles
  alias DemoWeb.StyleLive.StyleComponent
  alias DemoWeb.StyleUpdates

  def mount(_session, socket) do
    _ = StyleUpdates.subscribe_live_view()
    {:ok, assign(socket, :styles, %Styles{})}
  end

  def handle_info({_requesting_module, [:updated], [%Style{} = style]}, socket) do
    new_styles = Styles.update(socket.assigns.styles, style)
    {:noreply, assign(socket, :styles, new_styles)}
  end

  def render(assigns) do
    ~L"""
    <%= for id <- @styles.ids do %>
      <%= Map.fetch!(@styles.styles, id) %>
    <% end %>
    """
  end
end
