BEGIN {
  st_regexp = "[[:digit:]]{1,4}[[:punct:]][[:digit:]]{2}"
  hd_regexp = "time_rtq_ticker|Volume|Prev"
  RS = "/?span|/?td|/?th|/?div|/?title"
  FS = "[<>]"
}

{
  if (RT == "/title") print $0
}

$0 ~ hd_regexp {
  where = match($0, hd_regexp)
  name = substr($0, where, RLENGTH)
  if (name == "time_rtq_ticker") name = "Now"
}

$0 ~ st_regexp && name {
  values[name] = $2
  name = 0
}

END {
  format = "%-25s %s\n"
  format_pct = "%-25s %.2f%%\n"
  for(name in values) printf format, name, values[name]
  printf format_pct, "Change", 100.00*(values["Now"]-values["Prev"])/values["Prev"]
}
