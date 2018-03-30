defmodule FastIso do
  @on_load :load_nifs

  def load_nifs do
    :erlang.load_nif('./isoformat', 0)
  end

  def formatiso(_a) do
    raise "NIF fast_compare/1 not implemented"
  end
end
