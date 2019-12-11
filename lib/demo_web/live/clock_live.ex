defmodule DemoWeb.ClockLive do
  use Phoenix.LiveView
  alias DemoWeb.StyleLive
  alias DemoWeb.StyleLive.Style
  alias DemoWeb.StyleUpdates
  import Calendar.Strftime

  def render(assigns) do
    ~L"""
    <div>
      <h2>It's <%= strftime!(@date, "%r") %></h2>
      <%= live_render(@socket, DemoWeb.ImageLive, id: "image") %>
    </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_date(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
  end

  def handle_event("nav", _path, socket) do
    {:noreply, socket}
  end

  defp put_date(socket) do
    assign(socket, date: :calendar.local_time())
  end
end
