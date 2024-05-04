//// This module is for decoding JSON objects from HTTP requests. Designed specifically for the Plex API.

import gleam/dynamic
import gleam/json
import gleam/list
import gleam/option.{type Option}
import util/decode

/// Represents a single plex error that would be returned from the API
pub type PlexError {
  PlexError(code: Int, message: String, status: Int)
}

/// Private type to handle multiple plex errors as the API returns multiple. However we only return one so we don't need this to be public
type PlexErrors {
  PlexErrors(errors: List(PlexError))
}

/// Represents the location object returns from get-pin API
pub type PlexLocation {
  PlexLocation(
    code: String,
    european_union_member: Bool,
    continent_code: String,
    country: String,
    city: String,
    time_zone: String,
    postal_code: Option(String),
    in_privacy_restricted_country: Bool,
    subdivisions: String,
    coordinates: String,
  )
}

/// Represents the object response from the get-pin API
pub type PlexPin {
  PlexPin(
    id: Int,
    code: String,
    product: String,
    trusted: Bool,
    qr: String,
    client_identifier: String,
    location: PlexLocation,
    expires_in: Int,
    created_at: String,
    expires_at: String,
    auth_token: Option(String),
    new_registration: Option(Bool),
  )
}

/// Returns a single PlexError from a JSON string that represents a list of PlexError
pub fn decode_error_json(
  json_string: String,
) -> Result(PlexError, json.DecodeError) {
  // The decoder to handle a single PlexError  
  let decode_error =
    dynamic.decode3(
      PlexError,
      dynamic.field("code", dynamic.int),
      dynamic.field("message", dynamic.string),
      dynamic.field("status", dynamic.int),
    )

  // The decoder to handle a list of PlexError
  let decoder_errors =
    dynamic.decode1(
      PlexErrors,
      dynamic.field("errors", dynamic.list(decode_error)),
    )

  case json.decode(from: json_string, using: decoder_errors) {
    // Return the first error
    Ok(plex_errors) -> {
      let assert Ok(plex_error) = list.first(plex_errors.errors)
      Ok(plex_error)
    }
    Error(err) -> Error(err)
  }
}

/// Returns a PlexPin from a JSON string that represents a PlexPin
pub fn decode_pin_json(json_string: String) -> Result(PlexPin, json.DecodeError) {
  // The decoder to handle a single PlexLocation
  let decode_location =
    decode.decode10(
      PlexLocation,
      dynamic.field("code", dynamic.string),
      dynamic.field("european_union_member", dynamic.bool),
      dynamic.field("continent_code", dynamic.string),
      dynamic.field("country", dynamic.string),
      dynamic.field("city", dynamic.string),
      dynamic.field("time_zone", dynamic.string),
      dynamic.field("postal_code", dynamic.optional(dynamic.string)),
      dynamic.field("in_privacy_restricted_country", dynamic.bool),
      dynamic.field("subdivisions", dynamic.string),
      dynamic.field("coordinates", dynamic.string),
    )

  // The decoder to handle a single PlexPin
  let decode_pin =
    decode.decode12(
      PlexPin,
      dynamic.field("id", dynamic.int),
      dynamic.field("code", dynamic.string),
      dynamic.field("product", dynamic.string),
      dynamic.field("trusted", dynamic.bool),
      dynamic.field("qr", dynamic.string),
      dynamic.field("clientIdentifier", dynamic.string),
      dynamic.field("location", decode_location),
      dynamic.field("expiresIn", dynamic.int),
      dynamic.field("createdAt", dynamic.string),
      dynamic.field("expiresAt", dynamic.string),
      dynamic.field("authToken", dynamic.optional(dynamic.string)),
      dynamic.field("newRegistration", dynamic.optional(dynamic.bool)),
    )

  case json.decode(from: json_string, using: decode_pin) {
    Ok(plex_pin) -> Ok(plex_pin)
    Error(err) -> Error(err)
  }
}
