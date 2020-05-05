obj = %{ "asdfsadf" => ["str", 123, %{ "sub" => "asfdsaf" }, :atom] }
str = :jiffy.encode({obj})

jiffy_enc = fn ->
  Enum.each(1..1000, fn _ ->
    :jiffy.encode(obj)
  end)
end

poison_enc = fn ->
  Enum.each(1..1000, fn _ ->
    Poison.encode!(obj)
  end)
end

poison_io_enc = fn ->
  Enum.each(1..1000, fn _ ->
    Poison.encode_to_iodata!(obj)
  end)
end

jiffy_dec = fn ->
  Enum.each(1..1000, fn _ ->
    :jiffy.decode(str)
  end)
end

poison_dec = fn ->
  Enum.each(1..1000, fn _ ->
    Poison.decode!(str)
  end)
end

Benchee.run(%{
  # "jiffy decoding" => jiffy_dec,
  # "poison decoding" => poison_dec,
  "jiffy encoding" => jiffy_enc,
  "poison encoding" => poison_enc,
  "poison io encoding" => poison_io_enc
}, time: 10, parallel: 1)
