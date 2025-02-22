enum Cluster {
  mainnet("mainnet-beta"),
  devnet("devnet"),
  testnet("testnet"),
  helius("helius"),
  publicnode("publicnode");

  final String value;
  const Cluster(this.value);

  factory Cluster.fromString(String input) {
    return Cluster.values.firstWhere((it) => it.value == input);
  }
}

class ClusterUrl {
  final String rpcUrl, websocketUrl;
  ClusterUrl(this.rpcUrl, this.websocketUrl);
}

ClusterUrl clusterApiUrl(Cluster cluster) {
  switch (cluster) {
    case Cluster.publicnode:
      return ClusterUrl(
        "https://solana-rpc.publicnode.com",
        "wss://solana-rpc.publicnode.com",
      );
    case Cluster.helius:
      return ClusterUrl(
        "https://mainnet.helius-rpc.com/?api-key=3d542648-a8a5-42b1-aa2c-d6ae650b2a96",
        "wss://mainnet.helius-rpc.com/?api-key=3d542648-a8a5-42b1-aa2c-d6ae650b2a96",
      );
    case Cluster.mainnet:
      return ClusterUrl(
        "https://api.mainnet-beta.solana.com",
        "wss://api.mainnet-beta.solana.com",
      );
    case Cluster.devnet:
      return ClusterUrl(
        "https://api.devnet.solana.com",
        "wss://api.devnet.solana.com",
      );

    case Cluster.testnet:
      return ClusterUrl(
        "https://api.testnet.solana.com",
        "wss://api.testnet.solana.com",
      );
  }
}
