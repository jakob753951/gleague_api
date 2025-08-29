import client
import envoy
import gleague_api
import gleeunit
import platform
import puuid
import region

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn account_by_puuid_is_ok_test() {
  let assert Ok(api_key) = envoy.get("RIOT_API_KEY")
  let assert Ok(puuid_string) = envoy.get("TEST_USER_PUUID")
  let assert Ok(puuid) = puuid.parse(puuid_string)

  let client = client.Client(api_key, platform.EUW1, region.Europe)
  let assert Ok(account) = client |> gleague_api.get_account_by_puuid(puuid)

  account.puuid
}

pub fn account_by_riot_id_is_ok_test() {
  let assert Ok(api_key) = envoy.get("RIOT_API_KEY")
  let assert Ok(game_name) = envoy.get("TEST_USER_GAME_NAME")
  let assert Ok(tag_line) = envoy.get("TEST_USER_TAG_LINE")

  let client = client.Client(api_key, platform.EUW1, region.Europe)
  let assert Ok(account) =
    client |> gleague_api.get_account_by_riot_id(game_name:, tag_line:)

  account.puuid
}
