# sneak/steemd docker image

## Build Args

* STEEMD\_REPO
* STEEMD\_REV
* SECP256K1\_REPO
* SECP256K1\_REV
* UBUNTU\_MIRROR

## Environment Variables

* STEEMD\_WITNESS\_NAME
* STEEMD\_MINER\_NAME
* STEEMD\_PRIVATE\_KEY
    * Bitcoin Wallet Import Format (WIF)
* STEEMD\_MINING\_THREADS
    * default 8
* STEEMD\_EXTRA\_OPTS
    * passed in to steemd on command line

The init scripts will do all the silly escaping as required
by the daemon, just set these vars to the actual unquoted strings.

# Versions

* sneak/steemd:latest -> steem master
