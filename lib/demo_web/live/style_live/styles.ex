defmodule DemoWeb.StyleLive.Styles do
  alias DemoWeb.StyleLive.Style
  alias __MODULE__, as: Styles
  defstruct ids: [], styles: %{}

  def update(%Styles{ids: ids, styles: s} = styles, %Style{id: id} = style) do
    cond do
      id in ids ->
        Map.update!(styles, :styles, &Map.update!(&1, id, fn s -> Map.merge(s, style) end))

      true ->
        %Styles{ids: [id | ids], styles: Map.put(s, id, style)}
    end
  end

  defimpl Phoenix.HTML.Safe, for: DemoWeb.StyleLive.Styles do
    alias DemoWeb.StyleLive.Styles

    def to_iodata(%Styles{styles: styles}) do
      for s <- styles, do: Phoenix.HTML.Safe.to_iodata(s)
    end
  end
end
