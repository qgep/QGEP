#!/bin/bash

set -e

zip qgep.zip project/qgep.qgs project/*.qm

python3 plugin_ci/release/create_release.py -f qgep.zip
