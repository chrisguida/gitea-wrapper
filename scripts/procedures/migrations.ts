import { compat, matches, types as T } from "../deps.ts";

export const migration: T.ExpectedExports.migration = compat.migrations
  .fromMapping({
    "1.18.3": {
      up: compat.migrations.updateConfig(
        (config) => {
          config["email-settings"] = { enabled: "false" };
          return config;
        },
        true,
        { version: "1.18.3", type: "up" },
      ),
      down: compat.migrations.updateConfig(
        (config) => {
          if (
            matches.shape({
              "email-settings": matches.unknown,
            }).test(config)
          ) {
            delete config["email-settings"];
          }
          return config;
        },
        true,
        { version: "1.18.3", type: "down" },
      ),
    },
  }, "1.18.3");