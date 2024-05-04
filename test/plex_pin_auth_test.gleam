import gleam/http.{Get, Post}
import gleam/int
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import plex_pin_auth/internal/request.{type FetchError, fetch}
import plex_pin_auth/util/parser.{type PlexError, type PlexPin}

const unique_id = "plex_pin_auth_test"

pub fn main() {
  gleeunit.main()
}

pub fn decode_error_test() {
  let fake_error_response =
    "{\"errors\":[{\"code\":1000,\"message\":\"hello world\",\"status\":400}]}"
  let error = parser.decode_error_json(fake_error_response)

  // Should not error
  error
  |> should.be_ok
  let assert Ok(error_obj) = error

  // Each key matches the expected value
  error_obj.code
  |> should.equal(1000)
  error_obj.message
  |> should.equal("hello world")
  error_obj.status
  |> should.equal(400)
}

pub fn decode_pin_test() {
  let fake_pin_response =
    "{\"id\":1,\"code\":\"code\",\"product\":\"product\",\"trusted\":false,\"qr\":\"qr\",\"clientIdentifier\":\"clientID\",\"location\":{\"code\":\"loc_code\",\"european_union_member\":false,\"continent_code\":\"loc_cont_code\",\"country\":\"country\",\"city\":\"city\",\"time_zone\":\"timezone\",\"postal_code\":\"postalCode\",\"in_privacy_restricted_country\":false,\"subdivisions\":\"subdivisions\",\"coordinates\":\"coordinates\"},\"expiresIn\":900,\"createdAt\":\"createdAt\",\"expiresAt\":\"expiresAt\",\"authToken\":null,\"newRegistration\":null}"
  let pin = parser.decode_pin_json(fake_pin_response)

  // Should not error
  pin
  |> should.be_ok
  let assert Ok(pin_obj) = pin

  // Each key matches the expected value
  pin_obj.id
  |> should.equal(1)
  pin_obj.code
  |> should.equal("code")
  pin_obj.product
  |> should.equal("product")
  pin_obj.trusted
  |> should.equal(False)
  pin_obj.qr
  |> should.equal("qr")
  pin_obj.client_identifier
  |> should.equal("clientID")
  pin_obj.location.code
  |> should.equal("loc_code")
  pin_obj.location.european_union_member
  |> should.equal(False)
  pin_obj.location.continent_code
  |> should.equal("loc_cont_code")
  pin_obj.location.country
  |> should.equal("country")
  pin_obj.location.city
  |> should.equal("city")
  pin_obj.location.time_zone
  |> should.equal("timezone")
  pin_obj.location.postal_code
  |> should.equal(Some("postalCode"))
  pin_obj.location.in_privacy_restricted_country
  |> should.equal(False)
  pin_obj.location.coordinates
  |> should.equal("coordinates")
  pin_obj.expires_in
  |> should.equal(900)
  pin_obj.created_at
  |> should.equal("createdAt")
  pin_obj.expires_at
  |> should.equal("expiresAt")
  pin_obj.auth_token
  |> should.be_none
  pin_obj.new_registration
  |> should.be_none
}

pub fn request_test() {
  // Pin throws error
  fetch("", "/api/v2/pins", Post)
  |> is_plex_error

  // Pin is successful
  let pin =
    fetch(unique_id, "/api/v2/pins", Post)
    |> is_plex_pin

  // Token throws error
  fetch("", "/api/v2/pins/" <> int.to_string(pin.id), Get)
  |> is_plex_error

  // Token is successful
  fetch(unique_id, "/api/v2/pins/" <> int.to_string(pin.id), Get)
  |> is_plex_pin
}

fn is_plex_error(error_response: Result(String, FetchError)) -> PlexError {
  // Should error
  let response_err =
    error_response
    |> should.be_error

  // Convert JSON string into error object
  let error =
    parser.decode_error_json(response_err.message)
    |> should.be_ok

  // Message should be about missing the client identifier
  error.message
  |> should.equal("X-Plex-Client-Identifier is missing")
  error
}

fn is_plex_pin(success_response: Result(String, FetchError)) -> PlexPin {
  // Should not error
  let response =
    success_response
    |> should.be_ok

  // Convert JSON string into pin object
  let pin =
    parser.decode_pin_json(response)
    |> should.be_ok

  // Make sure the client identifier is correct
  pin.client_identifier
  |> should.equal(unique_id)

  pin
}
