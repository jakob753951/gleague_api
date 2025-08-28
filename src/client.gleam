import gleam/http
import gleam/http/request
import platform.{type PlatformId}
import region.{type ApiRegion}

pub type Client {
  Client(api_key: String, platform_id: PlatformId, region: ApiRegion)
}

pub type RequestPrefix {
  PlatformId
  Region
}

pub fn get_request(
  client: Client,
  request_prefix: RequestPrefix,
  path: String,
) -> request.Request(String) {
  let prefix = case request_prefix {
    Region -> client.region |> region.to_string()
    PlatformId -> client.platform_id |> platform.to_string()
  }

  request.new()
  |> request.set_scheme(http.Https)
  |> request.set_host(prefix <> ".api.riotgames.com")
  |> request.set_path(path)
  |> request.set_header("X-Riot-Token", client.api_key)
}
