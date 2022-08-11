import { types as T, compat } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
  "tor-address": {
    "name": "Tor Address",
    "description": "The Tor address for the main ui.",
    "type": "pointer",
    "subtype": "package",
    "package-id": "gitea",
    "target": "tor-address",
    "interface": "main"
  },
  "local-mode": {
    "name": "Local Mode",
    "description": "Toggle this on to change UI links and the SSH domain to the .local domain. Toggle it off to switch back to .onion.",
    "type": "boolean",
    "default": false,
  },
})
