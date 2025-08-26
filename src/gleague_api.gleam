import gleam/io

// get request-info from https://developer.riotgames.com/apis

pub fn main() -> Nil {
  io.println("Hello from gleague_api!")
}

pub type Client {
  Client(api_key: String)
}

pub type Account {
  Account(puuid: String, game_name: String, tag_line: String)
}

pub type ActiveShard {
  ActiveShard()
}

pub type ShardedGame {
  Valorant
  LegendsOfRuneterra
}

pub type RegionGame {
  LeagueOfLegends
  TeamfightTactics
}

pub fn get_account_by_puuid(client client: Client, puuid puuid: String) -> Result(Account, String) {
  todo
}

pub fn get_account_by_riot_id(client client: Client, game_name game_name: String, tag_line tag_line: String) -> Result(Account, String) {
  todo
}

pub fn get_account_by_access_token(client client: Client) -> Result(Account, String) {
  todo
}

pub fn get_active_shard_for_a_player(client client: Client, game game: ShardedGame, puuid puuid: String) -> Result(ActiveShard, String) {
  todo
}

pub fn get_active_region(client client: Client, game game: RegionGame, puuid puuid: String) -> Result(Account, String) {
  todo
}



