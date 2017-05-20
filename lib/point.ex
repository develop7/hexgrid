defmodule HexGrid.Point do
  @moduledoc false
  @type t :: %__MODULE__{x: number, y: number}

  @enforce_keys [:x, :y]
  defstruct [:x, :y]
end
