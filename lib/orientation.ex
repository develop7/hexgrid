defmodule HexGrid.Orientation do
  @moduledoc ~S"""
  """
  defstruct [:f0, :f1, :f2, :f3, :b0, :b1, :b2, :b3, :start_angle]

  def flat() do
    %__MODULE__{f0: 3.0 / 2.0, f1: 0.0, f2: :math.sqrt(3.0) / 2.0,  f3: :math.sqrt(3.0),
                b0: 2.0 / 3.0, b1: 0.0, b2: -1.0 / 3.0,             b3: :math.sqrt(3.0) / 3.0,
                start_angle: 0.0}
  end

  def pointy() do
    %__MODULE__{f3: 3.0 / 2.0, f2: 0.0, f1: :math.sqrt(3.0) / 2.0,  f0: :math.sqrt(3.0),
                b3: 2.0 / 3.0, b2: 0.0, b1: -1.0 / 3.0,             b0: :math.sqrt(3.0) / 3.0,
                start_angle: 0.5}
  end
end
