import gleam/dynamic/decode
import gleam/json
import gleam/option.{type Option}

pub type Account {
  Account(puuid: String, game_name: Option(String), tag_line: Option(String))
}

pub fn from_json(json: String) -> Result(Account, json.DecodeError) {
  let account_decoder = {
    use puuid <- decode.field("puuid", decode.string)
    use game_name <- decode.field("gameName", decode.optional(decode.string))
    use tag_line <- decode.field("tagLine", decode.optional(decode.string))
    decode.success(Account(puuid:, game_name:, tag_line:))
  }
  json.parse(from: json, using: account_decoder)
}
