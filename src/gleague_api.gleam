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

pub fn get_account_by_puuid(client: Client) -> Result(Account, String) {
  todo
}
