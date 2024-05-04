/// Modules for making HTTP requests only exports the FetchError type and the fetch method
import gleam/hackney
import gleam/http.{type Method}
import gleam/http/request

pub type FetchError {
  FetchError(status: Int, message: String)
}

/// Makes a HTTP Request, current designed for plex tv
pub fn fetch(
  id client_id: String,
  path path: String,
  method method: Method,
) -> Result(String, FetchError) {
  // Prepare a HTTP request record
  let req =
    request.new()
    |> request.set_method(method)
    |> request.set_host("plex.tv")
    |> request.set_path(path)
    |> request.prepend_header("accept", "application/json")
    |> request.prepend_header("X-Plex-Client-Identifier", client_id)

  // Send the HTTP request to the server
  let assert Ok(res) = hackney.send(req)

  // Handle the status
  case res.status {
    // The basic success codes
    200 | 201 | 204 -> {
      Ok(res.body)
    }
    // Handle all other statuses as unexpected errors
    status -> {
      Error(FetchError(status: status, message: res.body))
    }
  }
}
