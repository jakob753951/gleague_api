pub type ApiRegion {
  Americas
  Asia
  Europe
  Sea
}

pub fn to_string(region: ApiRegion) -> String {
  case region {
    Americas -> "americas"
    Asia -> "asia"
    Europe -> "europe"
    Sea -> "sea"
  }
}
