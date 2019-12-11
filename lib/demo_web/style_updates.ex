defmodule DemoWeb.StyleUpdates do
  @moduledoc """
  The message bus for passing data to topics via Phoenix.PubSub.
  """

  alias DemoWeb.Style

  @topic inspect(__MODULE__)

  @doc "subscribe for all users"
  def subscribe_live_view do
    Phoenix.PubSub.subscribe(Demo.PubSub, topic(), link: true)
  end

  @doc "notify for all users"
  def notify_live_view(module, events, result) do
    Phoenix.PubSub.broadcast(Demo.PubSub, topic(), {module, events, result})
  end

  defp topic, do: @topic
end
