# sneak/steemd docker image

# Build Args

    * `STEEMD_REPO`
    * `STEEMD_REV`
    * `SECP256K1_REPO`
    * `SECP256K1_REV`
    * `UBUNTU_MIRROR`

# Environment Variables

    * `STEEMD_WITNESS_NAME`
    * `STEEMD_MINER_NAME`
    * `STEEMD_PRIVATE_KEY`
        * Bitcoin Wallet Import Format (WIF)
    * `STEEMD_MINING_THREADS`
        * default 8
    * `STEEMD_EXTRA_OPTS`
        * passed in to steemd on command line

The init scripts will do all the silly escaping, just set these
to the actual unquoted strings.

# Versions

* sneak/steemd:latest -> steem master
