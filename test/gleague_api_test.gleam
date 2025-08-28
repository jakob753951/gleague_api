import client
import gleague_api
import gleam/result
import gleeunit
import platform
import puuid
import region

pub fn main() -> Nil {
  gleeunit.main()
}

const api_key = "INSERT API-KEY HERE"

const puuid_string = "INSERT PUUID HERE"

// gleeunit test functions end in `_test`
pub fn account_by_puuid_is_ok_test() {
  let client = client.Client(api_key, platform.EUW1, region.Europe)
  let assert Ok(puuid) = puuid.parse(puuid_string)

  assert client
    |> gleague_api.get_account_by_puuid(puuid)
    |> echo
    |> result.is_ok
}
