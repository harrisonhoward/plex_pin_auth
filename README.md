# Plex Pin Authentication built with Gleam

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![Made with Gleam](https://img.shields.io/badge/Made%20with-Gleam-ffaff3.svg)](https://shields.io/)
[![Status](https://img.shields.io/badge/Status-Work%20in%20progress-yellow.svg)](https://shields.io/)

## Scope

This project is linked to the project [plex_discord_rpc](https://github.com/harrisonhoward/plex_discord_rpc). The purpose of this project is to create a Gleam application that will authenticate with Plex using the pin authentication method. This will allow the user to authenticate with Plex and get the necessary token to make requests to the Plex API.

Specifically I created this to allow the user to authenticate themselves easily within the `plex_discord_rpc` tool, doing so allows the tool to connect to their Plex Media Server to connect to the WebSocket.

### Plex Pin Auth Documentation

It appears the API isn't officially documented however I found some third-party documentation website. This website will be used in the creation of the pin authentication.

-   [get-pin](https://plexapi.dev/docs/plex/get-pin)
-   [get-token](https://plexapi.dev/docs/plex/get-token)

## Development

Requires Gleam to be installed to run the project\
[How to install Gleam](https://gleam.run/getting-started/installing/)

```sh
# Runs the project
gleam run
```

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
