import gleam/result
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

pub fn get_request(client: Client, request_prefix: RequestPrefix, path: String) -> Result(request.Request(String), Nil) {
  let prefix = case request_prefix {
    Region -> client.region |> region.to_string()
    PlatformId -> client.platform_id |> platform.to_string()
  }

  request.to(prefix <> ".api.riotgames.com" <> path)
  |> result.map(request.set_header(_, "Authorization", client.api_key))
}
