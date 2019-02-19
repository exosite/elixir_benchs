# Full versus partial regex

log_miss = "eacead5f4bc7d5b63ff7313ded00afb5888efb9de076b6f695eca3c3f2899627 murano-content-service-dev [18/Dec/2018:14:06:28 +0000] 54.214.158.253 - EFAEB0CF85CC4659 REST.GET.BUCKET - \"GET /murano-content-service-dev/?delimiter=%2F&marker=&max-keys=2&prefix= HTTP/1.1\" 301 PermanentRedirect 489 211 1 - \"-\" \"hackney/1.10.1\" -"
log = "eacead5f4bc7d5b63ff7313ded00afb5888efb9de076b6f695eca3c3f2899627 murano-content-service-dev [18/Dec/2018:14:06:28 +0000] 54.214.158.253 - EFAEB0CF85CC4659 REST.GET.OBJECT contextid/key \"GET /murano-content-service-dev/?delimiter=%2F&marker=&max-keys=2&prefix= HTTP/1.1\" 200 PermanentRedirect 489 211 1 - \"-\" \"hackney/1.10.1\" -"

named_captures = fn ->
  Enum.each(1..1000, fn _ ->
    Regex.named_captures(~r/(?<bucket_owner>.{64}) (?<bucket>[^ ]+) \[(?<time>[^\]]+)\] (?<ip>[0-9\.]*) (?<requester>[^ ]+) (?<request_id>[^ ]+) (?<operation>[^ ]+) (?<key>[^ ]+) \"(?<request_uri>[^\"]+)\" (?<http_status>[0-9]{3}) (?<error_code>[^ ]+) (?<bytes_sent>[^ ]+) (?<object_size>[^ ]+) (?<total_time>[0-9]+) (?<turn_around_time>[^ ]+) \"(?<referrer>[^\"]+)\" \"(?<user_agent>[^\"]+)\" (?<version_id>.*)/, log)
  end)
end

named_captures_short = fn ->
  Enum.each(1..1000, fn _ ->
    Regex.named_captures(~r/^.{64} [^ ]+ \[[^\]]+\] [0-9\.]* [^ ]+ [^ ]+ REST.GET.OBJECT (?<context>[^\/ ]+)\/[^ ]+ \"[^\"]+\" 200 [^ ]+ [^ ]+ (?<object_size>[0-9]+) /, log)
  end)
end

r = ~r/^.{64} [^ ]+ \[[^\]]+\] [0-9\.]* [^ ]+ [^ ]+ REST.GET.OBJECT (?<context>[^\/ ]+)\/[^ ]+ \"[^\"]+\" 200 [^ ]+ [^ ]+ (?<object_size>[0-9]+) /
named_captures_short_const = fn ->
  Enum.each(1..1000, fn _ ->
    Regex.named_captures(r, log)
  end)
end

run_short_const = fn ->
  Enum.each(1..1000, fn _ ->
    Regex.run(r, log)
  end)
end

Benchee.run(%{
  "Regex.run short & const" => run_short_const,
  "Regex.named_captures" => named_captures,
  "Regex.named_captures short" => named_captures_short,
  "Regex.named_captures short & const" => named_captures_short_const
}, time: 10, parallel: 1)
