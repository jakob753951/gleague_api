import account.{type Account}
import client.{type Client}
import gleam/dynamic/decode
import gleam/http/response
import gleam/httpc
import gleam/json
import gleam/result
import gleam/uri
import puuid.{type Puuid}

// get request-info from https://developer.riotgames.com/apis

fn http_error_to_string(error: httpc.HttpError) -> String {
  case error {
    httpc.InvalidUtf8Response ->
      "Invalid UTF-8 response: The response body contained non-UTF-8 data, but UTF-8 data was expected."
    httpc.FailedToConnect(_, _) ->
      "Failed to connect: It was not possible to connect to the host."
    httpc.ResponseTimeout ->
      "Response timeout: The response was not received within the configured timeout period."
  }
}

fn check_response_status_code(response: response.Response(a)) {
  case response.status {
    400 -> Error("Http error 400: Bad request")
    401 -> Error("Http error 401: Unauthorized")
    403 -> Error("Http error 403: Forbidden")
    404 -> Error("Http error 404: Data not found")
    405 -> Error("Http error 405: Method not allowed")
    415 -> Error("Http error 415: Unsupported media type")
    429 -> Error("Http error 429: Rate limit exceeded")
    500 -> Error("Http error 500: Internal server error")
    502 -> Error("Http error 502: Bad gateway")
    503 -> Error("Http error 503: Service unavailable")
    504 -> Error("Http error 504: Gateway timeout")
    _ -> Ok(response)
  }
}

// Account V1

pub fn get_account_by_puuid(
  client client: Client,
  puuid puuid: Puuid,
) -> Result(Account, String) {
  let path = "/riot/account/v1/accounts/by-puuid/" <> puuid |> puuid.to_string()
  let request =
    client
    |> client.get_request(client.Region, path)
  use response <- result.try(
    request
    |> httpc.send()
    |> result.map_error(http_error_to_string),
  )

  use response <- result.try(check_response_status_code(response))

  response.body
  |> account.from_json()
  |> result.replace_error("Could not parse JSON")
}

pub fn get_account_by_riot_id(
  client client: Client,
  game_name game_name: String,
  tag_line tag_line: String,
) -> Result(Account, String) {
  let path = {
    "/riot/account/v1/accounts/by-riot-id/"
    <> uri.percent_encode(game_name)
    <> "/"
    <> uri.percent_encode(tag_line)
  }

  let request =
    client
    |> client.get_request(client.Region, path)
  use response <- result.try(
    request
    |> httpc.send()
    |> result.map_error(http_error_to_string),
  )

  use response <- result.try(check_response_status_code(response))

  response.body
  |> account.from_json()
  |> result.replace_error("Could not parse JSON")
}

pub fn get_account_by_access_token(
  client client: Client,
  access_token access_token: String,
) -> Result(Account, String) {
  todo
}

pub type ShardedGame {
  Valorant
  LegendsOfRuneterra
}

fn sharded_game_to_string(game: ShardedGame) -> String {
  case game {
    LegendsOfRuneterra -> "lor"
    Valorant -> "val"
  }
}

fn sharded_game_decoder() {
  use game <- decode.then(decode.string)
  case game {
    "lor" -> decode.success(LegendsOfRuneterra)
    "val" -> decode.success(Valorant)
    _ -> decode.failure(Valorant, "ShardedGame")
  }
}

pub type ActiveShard {
  ActiveShard(puuid: String, game: ShardedGame, active_shard: String)
}

pub fn active_shard_from_json(
  json: String,
) -> Result(ActiveShard, json.DecodeError) {
  let account_decoder = {
    use puuid <- decode.field("puuid", decode.string)
    use game <- decode.field("game", sharded_game_decoder())
    use active_shard <- decode.field("activeShard", decode.string)
    decode.success(ActiveShard(puuid:, game:, active_shard:))
  }
  json.parse(from: json, using: account_decoder)
}

pub fn get_active_shard_for_a_player(
  client client: Client,
  game game: ShardedGame,
  puuid puuid: Puuid,
) -> Result(ActiveShard, String) {
  let path = {
    "/riot/account/v1/active-shards/by-game/"
    <> game |> sharded_game_to_string()
    <> "/by-puuid"
    <> puuid |> puuid.to_string()
  }

  let request =
    client
    |> client.get_request(client.Region, path)
  use response <- result.try(
    request
    |> httpc.send()
    |> result.map_error(http_error_to_string),
  )

  use response <- result.try(check_response_status_code(response))

  response.body
  |> active_shard_from_json()
  |> result.replace_error("Could not parse JSON")
  |> echo
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
