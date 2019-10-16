list = Enum.map(1..1000, fn key -> to_string(key) end)

defmodule Recursion do

  def join(l, sep \\ "")
  def join([], _sep), do: ""
  def join([h], _sep) when is_binary(h), do: h
  def join([true], _sep), do: "true"
  def join([false], _sep), do: "false"
  def join([h], _sep) when is_integer(h), do: Integer.to_string(h)
  def join([h], _sep) when is_number(h), do: Float.to_string(h)
  def join([h], _sep) when is_atom(h), do: Atom.to_string(h)
  def join([h], _sep), do: :jiffy.encode(h)
  def join([h | t], sep) when is_binary(h), do: h <> sep <> join(t, sep)
  def join([true | t], sep), do: "true" <> sep <> join(t, sep)
  def join([false | t], sep), do: "false" <> sep <> join(t, sep)
  def join([h | t], sep) when is_integer(h), do: Integer.to_string(h) <> sep <> join(t, sep)
  def join([h | t], sep) when is_number(h), do: Float.to_string(h) <> sep <> join(t, sep)
  def join([h | t], sep) when is_atom(h), do: Atom.to_string(h) <> sep <> join(t, sep)
  def join([h | t], sep), do: :jiffy.encode(h) <> sep <> join(t, sep)

  def join!([], _sep), do: ""
  def join!([h], _sep), do: h
  def join!([h | t], sep), do: <<h :: binary, sep :: binary , join!(t, sep) :: binary >>

  def join2!(l, sep, acc \\ "")
  def join2!([], _sep, acc), do: acc
  def join2!([h], sep, acc), do: << acc :: binary, sep :: binary , h :: binary >>
  def join2!([h | t], sep, acc), do: join2!(t, sep, << acc :: binary, sep :: binary , h :: binary >>)

  def join3!(l, acc \\ "")
  def join3!([], acc), do: acc
  def join3!([h], acc), do: << acc :: binary, h :: binary >>
  def join3!([h | t], acc), do: join3!(t, << acc :: binary, h :: binary >>)

  def join4!(l)
  def join4!([]), do: ""
  def join4!([h]), do: h
  def join4!([h | t]), do: <<h :: binary, join4!(t) :: binary >>
end

enum_join = fn ->
  Enum.join(list, "")
end

list_join = fn ->
  List.to_string(list)
end

to_string = fn ->
  to_string(list)
end

custom_join = fn ->
  Recursion.join(list, "")
end

custom_join! = fn ->
  Recursion.join!(list, "")
end

custom_join2! = fn ->
  Recursion.join2!(list, "")
end

custom_join3! = fn ->
  Recursion.join3!(list)
end

custom_join4! = fn ->
  Recursion.join4!(list)
end

Benchee.run(%{
  "enum_join" => enum_join,
  "list_join" => list_join,
  "to_string" => to_string,
  "custom_join" => custom_join,
  "custom_join!" => custom_join!,
  "custom_join2!" => custom_join2!,
  "custom_join3!" => custom_join3!,
  "custom_join4!" => custom_join4!
}, time: 10, parallel: 1)
