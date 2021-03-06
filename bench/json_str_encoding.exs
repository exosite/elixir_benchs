# Json encoding

data = "lnkjsfasadf\"safdasfdsaF\"as;fas;flj;alkdsjfa;kdslfjal;jsfenoaspdf\asf;lkas;fjklas;jfdsadf\"safas;fljlkj\"sadfasffffffffffasdfsafd56789"

severity = "asf"

string_obj = fn ->
  Enum.map(1..1000, fn numb ->
    numb = Integer.to_string(numb)
    "{\"type\":\"call\",\"severity\":\"" <> severity <>
    "\",\"timestamp\":" <> numb <>
    ",\"elapsed\":" <> numb <>
    ",\"tracking_id\":\"" <> severity <>
    "\",\"solution_id\":\"" <> severity <>
    "\",\"service\":\"" <> severity <>
    "\",\"service_type\":\"" <> severity <>
    "\",\"event\":\"" <> severity <>
    "\",\"message\":" <> numb <>
    ",\"code\":" <> numb <>
    ",\"data\":{" <>
    ",\"request\":" <> :jiffy.encode(%{
      "a" => 1,
      "b" => 2,
      "c" => 3
    }) <>
    ",\"response\":" <> :jiffy.encode(%{
      "d" => 4,
      "e" => 5,
      "f" => 6
    }) <>
    ",\"processing_time\":" <> numb <>
    ",\"data_in\":" <> numb <>
    ",\"data_out\":" <> numb <>
    "}}"
  end)
end

list_obj = fn ->
  Enum.map(1..1000, fn numb ->
    numb = Integer.to_string(numb)
    <<"{\"type\":\"call\",\"severity\":\"",severity::binary,
    "\",\"timestamp\":",numb::binary,
    ",\"elapsed\":",numb::binary,
    ",\"tracking_id\":\"",severity::binary,
    "\",\"solution_id\":\"",severity::binary,
    "\",\"service\":\"",severity::binary,
    "\",\"service_type\":\"",severity::binary,
    "\",\"event\":\"",severity::binary,
    "\",\"message\":",numb::binary,
    ",\"code\":",numb::binary,
    ",\"data\":{\"processing_time\":",numb::binary,
    ",\"request\":", :jiffy.encode(%{
      "a" => 1,
      "b" => 2,
      "c" => 3
    })::binary,
    ",\"response\":",:jiffy.encode(%{
      "d" => 4,
      "e" => 5,
      "f" => 6
    })::binary,
    ",\"data_in\":",numb::binary,
    ",\"data_out\":",numb::binary,
    "}}">>
  end)
end

jiffy_obj = fn ->
  Enum.map(1..1000, fn numb ->
    numb = Integer.to_string(numb)
    :jiffy.encode(%{"type" => "call",
    "severity" => severity,
    "timestamp" => numb,
    "elapsed" => numb,
    "tracking_id" => severity,
    "solution_id" => severity,
    "service" => severity,
    "service_type" => severity,
    "event" => severity,
    "message" => numb,
    "code" => numb,
    "data" => %{
      "request" => %{
        "a" => 1,
        "b" => 2,
        "c" => 3
      },
      "response" => %{
        "d" => 4,
        "e" => 5,
        "f" => 6
      },
      "processing_time" => numb,
      "data_in" => numb,
      "data_out" => numb,
    }}, [:use_nil])
  end)
end

jiffy_obj_atom = fn ->
  Enum.map(1..1000, fn numb ->
    numb = Integer.to_string(numb)
    :jiffy.encode(%{type: "call",
    severity: severity,
    timestamp: numb,
    elapsed: numb,
    tracking_id: severity,
    solution_id: severity,
    service: severity,
    service_type: severity,
    event: severity,
    message: numb,
    code: numb,
    data: %{
      processing_time: numb,
      data_in: numb,
      data_out: numb,
    }}, [:use_nil])
  end)
end

inspect_obj = fn ->
  Enum.map(1..1000, fn numb ->
    numb = Integer.to_string(numb)
    inspect(%{"type" => "call",
    "severity" => severity,
    "timestamp" => numb,
    "elapsed" => numb,
    "tracking_id" => severity,
    "solution_id" => severity,
    "service" => severity,
    "service_type" => severity,
    "event" => severity,
    "message" => numb,
    "code" => numb,
    "data" => %{
      "processing_time" => numb,
      "data_in" => numb,
      "data_out" => numb,
    }})
  end)
end

# Start benchmark
Benchee.run(%{
  "Full jiffy encoding: key=strings" => jiffy_obj,
  "Full jiffy encoding: key=atoms" => jiffy_obj_atom,
  "Inspect" => inspect_obj,
  "List with encoded values" => list_obj,
  "String with encoded values" => string_obj
}, time: 10, formatter_options: %{console: %{extended_statistics: true}})
