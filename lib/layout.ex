defmodule HexGrid.Layout do
  @moduledoc false

  alias HexGrid, as: Grid

  @type t :: %__MODULE__{orientation: Grid.Orientation.t, size: non_neg_integer, origin: Grid.Point.t}

  defstruct [:orientation, :size, :origin]

  def new(orientation, size, origin) do
    %__MODULE__{orientation: orientation, size: size, origin: origin}
  end

  def hex_to_pixel(layout, h) do
    o = layout.orientation

    x = (o.f0 * h.q + o.f1 * h.r) * layout.size.x
    y = (o.f2 * h.q + o.f3 * h.r) * layout.size.y

    %Grid.Point{x: x + layout.origin.x, y: y + layout.origin.y}
  end

  def pixel_to_hex(layout, point) do
    o = layout.orientation

    pt = %Grid.Point{x: (point.x - layout.origin.x) / layout.size.x, y: (point.y - layout.origin.y) / layout.size.y}

    q = o.b0 * pt.x + o.b1 * pt.y
    r = o.b2 * pt.x + o.b3 * pt.y

    {:ok, hex} = HexGrid.Hex.new(q, r, -q - r)
    hex
  end

  def hex_round(h) do
    {q, r, s} = {round(h.q), round(h.r), round(h.s)}

    [qd, rd, sd] = [abs(q - h.q), abs(r - h.r), abs(s - h.s)]

    # diff_max = Enum.max diffs
    # q = if(diff_max == qd, do: -r - s, else: q)

    cond do
      qd > rd and qd > sd ->
        q = -r - s
      rd > sd ->
        r = -q - s
      true -> # sd >= rd
        s = -q - r
    end

    {:ok, hex} = HexGrid.Hex.new(q, r, s)
    hex
  end

  defp lerp(a, b, t) do
    a * (1 - t) + b * t
  end

  def hex_lerp(a, b, t) do
    HexGrid.Hex.new!(lerp(a.q, b.q, t), lerp(a.r, b.r, t), lerp(a.s, b.s, t))
  end

  @doc ~S"""
  Returns a list of hexes on a line from hex a to b

  # Examples

    iex> HexGrid.Layout.hex_linedraw(%HexGrid.Hex{q: 0, r: 1, s: -1}, %HexGrid.Hex{q: 2, r: 0, s: -2})
    [%HexGrid.Hex{q: 0, r: 1, s: -1}, %HexGrid.Hex{q: 1, r: 0, s: -1}, %HexGrid.Hex{q: 2, r: 0, s: -2}]

  """
  def hex_linedraw(a, b) do
    n = HexGrid.Hex.distance(a, b)
    a_nudge = nudge(a)
    b_nudge = nudge(b)
    step = 1.0 / max(n, 1)
    for i <- 0..n, do: hex_round(hex_lerp(a_nudge, b_nudge, step * i))
  end

  defp nudge(hex) do
    %{hex | q: hex.q - 1.0e-6, r: hex.r - 1.0e-6, s: hex.s + 2.0e-6}
  end
end
