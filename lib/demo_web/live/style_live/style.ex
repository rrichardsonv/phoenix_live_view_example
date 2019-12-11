defmodule DemoWeb.StyleLive.Style do
  @type t :: %__MODULE__{
          id: String.t() | nil,
          color: String.t() | nil,
          background_color: String.t() | nil
        }

  defstruct [
    :color,
    :background_color,
    :id
  ]

  def new(attrs \\ %{}) do
    %__MODULE__{}
    |> do_build!(attrs)
  end

  defp do_build!(%__MODULE__{} = style, attrs) when is_map(attrs) do
    Enum.reduce(attrs, style, &do_build!/2)
  end

  defp do_build!(%__MODULE__{} = style, pair) do
    struct!(style, [pair])
  end

  def to_rule_list(%__MODULE__{} = style) do
    style
    |> Map.from_struct()
    |> Map.delete(:id)
    |> Enum.reduce([], fn
      {_prop_name, nil}, acc ->
        acc

      {prop_name, value}, acc ->
        rule_name =
          prop_name
          |> Atom.to_string()
          |> String.split("-")
          |> Enum.join("_")

        ["#{rule_name}:#{value};" | acc]
    end)
  end

  def classname(%__MODULE__{id: id}) do
    "##{id}"
  end

  defimpl Phoenix.HTML.Safe, for: DemoWeb.StyleLive.Style do
    alias DemoWeb.StyleLive.Style

    def to_iodata(%Style{} = style) do
      rule_list =
        style
        |> Style.to_rule_list()
        |> Enum.join("\n")

      """
      #{Style.classname(style)} {
          #{rule_list}
        }
      """
    end
  end
end
