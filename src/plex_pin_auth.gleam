import gleam/http.{Get, Post}
import gleam/int
import plex_pin_auth/internal/request.{type FetchError, fetch}
import plex_pin_auth/util/parser.{type PlexError, type PlexPin}

/// Internal function to handle the duplicate response handling that'll occur
fn handle_response(
  response: Result(String, FetchError),
) -> Result(PlexPin, PlexError) {
  case response {
    Ok(response) -> {
      let assert Ok(pin) = parser.decode_pin_json(response)
      Ok(pin)
    }
    Error(response) -> {
      let assert Ok(error) = parser.decode_error_json(response.message)
      Error(error)
    }
  }
}

/// Creates a Plex pin from the Plex API. Requires a client identifier.
pub fn create_pin(
  client_id client_identifier: String,
) -> Result(PlexPin, PlexError) {
  fetch(client_identifier, "/api/v2/pins", Post)
  |> handle_response
}

/// Returns the Plex pin object from the Plex API. Requires a client identifier and the pin ID.
/// 
/// If the Plex pin hasn't been linked (plex.tv/link) then the 'auth_token' field will be empty.
pub fn get_token(
  client_id client_identifier: String,
  id pin_id: Int,
) -> Result(PlexPin, PlexError) {
  fetch(client_identifier, "/api/v2/pins/" <> int.to_string(pin_id), Get)
  |> handle_response
}
