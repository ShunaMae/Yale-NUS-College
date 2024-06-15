a2e <- letters[1:5]
a2e <- append(x = a2e, values = c("F", "G"))

x |> 
  append(y) |> 
  length() |>
  log(base = 3) |>
  print(digits = 10)
