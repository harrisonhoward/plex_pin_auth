# Plex Pin Authentication built with Gleam

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![Made with Gleam](https://img.shields.io/badge/Made%20with-Gleam-ffaff3.svg)](https://shields.io/)
[![Status](https://img.shields.io/badge/Status-Completed-green.svg)](https://shields.io/)

[![Package Version](https://img.shields.io/hexpm/v/plex_pin_auth)](https://hex.pm/packages/plex_pin_auth)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/plex_pin_auth/)

## Scope

This project is linked to the project [plex_discord_rpc](https://github.com/harrisonhoward/plex_discord_rpc). The purpose of this project is to create a Gleam application that will authenticate with Plex using the pin authentication method. This will allow the user to authenticate with Plex and get the necessary token to make requests to the Plex API.

Specifically I created this to allow the user to authenticate themselves easily within the `plex_discord_rpc` tool, doing so allows the tool to connect to their Plex Media Server to connect to the WebSocket.

## Usage

The method in which you handle getting a token is entirely left on the Developer. This an example of how you would create a pin and get the token.

Feel free to use a package like [repeatedly](https://hexdocs.pm/repeatedly/) to handle the polling of the token.

```gleam
import plex_pin_auth
import gleam/io

const my_client_id = "YOUR_CLIENT_ID"

pub fn main() {
    // Creates the Plex pin
    let assert Ok(pin) = plex_pin_auth.create_pin(client_id: my_client_id)
    io.println("ID: " <> pin.id)
    io.println("Pin: " <> pin.code)

    // ... waiting for token

    // Gets the token
    let assert Ok(pin) = plex_pin_auth.get_token(my_client_id, pin.id)
    let assert Some(token) = pin.auth_token
    io.println("Token: " <> token)
}
```

## Plex Pin Auth Documentation

It appears the API isn't officially documented however I found some third-party documentation website. This website will be used in the creation of the pin authentication.

- [get-pin](https://plexapi.dev/docs/plex/get-pin)
- [get-token](https://plexapi.dev/docs/plex/get-token)

## Contributing

1. [Fork it](https://github.com/harrisonhoward/plex_pin_auth/fork)
2. Clone your forked repository `git clone https://github.com/YOUR_USERNAME/plex_pin_auth.git`
3. Create your feature branch `git checkout -b feature/my-new-feature`
4. Commit your changes `git commit -am 'Add some feature'`
5. Push to the branch `git push origin feature/my-new-feature`
6. Create a new Pull Request

## Author

[Harrison Howard](https://github.com/harrisonhoward)

> harrison.howard00707@gmail.com
