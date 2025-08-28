import client.{type Client}
import gleam/httpc
import gleam/io
import gleam/result
import puuid.{type Puuid}

// get request-info from https://developer.riotgames.com/apis

pub fn main() -> Nil {
  io.println("Hello from gleague_api!")
}

fn http_error_to_string(error: httpc.HttpError) -> String {
  case error {
    httpc.FailedToConnect(ip4:, ip6:) -> "Failed to connect"
    httpc.InvalidUtf8Response -> "Invalid UTF-8 response"
    httpc.ResponseTimeout -> "Response timeout"
  }
}

// Account V1
pub type Account {
  Account(puuid: String, game_name: String, tag_line: String)
}

pub fn get_account_by_puuid(
  client client: Client,
  puuid puuid: Puuid,
) -> Result(Account, String) {
  let path = "/riot/account/v1/accoutns/by-puuid/" <> puuid |> puuid.to_string()
  use request <- result.try(
    client
    |> client.get_request(client.Region, path)
    |> result.replace_error("Could not create request"),
  )
  use response <- result.try(
    request
    |> httpc.send()
    |> result.map_error(http_error_to_string),
  )
  todo
}

pub fn get_account_by_riot_id(
  client client: Client,
  game_name game_name: String,
  tag_line tag_line: String,
) -> Result(Account, String) {
  todo
}

pub fn get_account_by_access_token(
  client client: Client,
) -> Result(Account, String) {
  todo
}

pub type ShardedGame {
  Valorant
  LegendsOfRuneterra
}

pub type ActiveShard {
  ActiveShard
}

pub fn get_active_shard_for_a_player(
  client client: Client,
  game game: ShardedGame,
  puuid puuid: Puuid,
) -> Result(ActiveShard, String) {
  todo
}

pub type RegionGame {
  LeagueOfLegends
  TeamfightTactics
}

pub type AccountRegion

pub fn get_active_region(
  client client: Client,
  game game: RegionGame,
  puuid puuid: Puuid,
) -> Result(AccountRegion, String) {
  todo
}
