import type { NextConfig } from "next";
import webpack from "webpack";

const nextConfig: NextConfig = {
  webpack: (config) => {
    // @coinbase/cdp-sdk (pulled in transitively by RainbowKit's Base Account
    // connector) statically references optional x402 payment-protocol
    // packages we don't depend on and don't need for wallet connection.
    // Ignore the whole @x402/* scope instead of installing that stack.
    config.plugins.push(new webpack.IgnorePlugin({ resourceRegExp: /^@x402\// }));
    // @metamask/sdk's React Native storage backend is unused in a browser
    // bundle; it's behind a runtime feature check, so ignoring it is safe.
    config.plugins.push(
      new webpack.IgnorePlugin({ resourceRegExp: /^@react-native-async-storage\/async-storage$/ }),
    );
    return config;
  },
};

export default nextConfig;
