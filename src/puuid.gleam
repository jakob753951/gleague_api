import gleam/string

pub opaque type Puuid {
  Puuid(value: String)
}

pub fn parse(s: String) -> Result(Puuid, Nil) {
  case s |> string.length {
    78 -> Ok(Puuid(s))
    _ -> Error(Nil)
  }
}

pub fn to_string(puuid: Puuid) -> String {
  puuid.value
}
