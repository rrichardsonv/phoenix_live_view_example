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

  defp do_build!(pair, %__MODULE__{} = style),
    do: struct!(style, [pair])

  defp do_build!(%__MODULE__{} = style, pair),
    do: struct!(style, pair)

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

  defmacro sigil_Z(term, modifiers)

  defmacro sigil_Z({:<<>>, _meta, [string]}, modifiers) when is_binary(string) do
    Macro.escape(split_rules(:elixir_interpolation.unescape_chars(string), modifiers))
  end

  defmacro sigil_Z({:<<>>, meta, pieces}, modifiers) do
    binary = {:<<>>, meta, unescape_tokens(pieces)}
    Macro.escape(split_rules(binary, modifiers))
  end

  # Helper to handle the :ok | :error tuple returned from :elixir_interpolation.unescape_tokens
  defp unescape_tokens(tokens) do
    case :elixir_interpolation.unescape_tokens(tokens) do
      {:ok, unescaped_tokens} -> unescaped_tokens
      {:error, reason} -> raise ArgumentError, to_string(reason)
    end
  end

  defp split_rules(string, _) do
    f = fn
      "" ->
        false

      s ->
        case String.split(s, :binary.compile_pattern([":", " : ", ": ", " :"])) do
          [name, value] ->
            {true, {String.to_atom(name), value}}

          _ ->
            false
        end
    end

    re = :binary.compile_pattern([";", ";\n", "; "])

    case is_binary(string) do
      true ->
        parts = String.split(string, re)
        __MODULE__.new(:lists.filtermap(f, parts))

      false ->
        parts = quote(do: String.split(unquote(string), unquote(re)))
        quote(do: unquote(__MODULE__).new(:lists.filtermap(unquote(f), unquote(parts))))
    end
  end
end
