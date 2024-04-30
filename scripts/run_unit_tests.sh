#!/bin/bash

# Runs the unit tests for the project.
# This is meant to be hooked up into .git/hooks/pre-commit

# Example pre-commit hook:
# #!/bin/sh
# #
# # Runs the unit tests for the project.
# ./scripts/run_unit_tests.sh

# This command was copied from the output of CI, it might need to be kept in sync.
# This version of the command was used because there are false positives of orphans
# in the simpler version of the command.
./scripts/runtest.sh \
  --audio-driver Dummy \
  --display-driver x11 \
  --rendering-driver opengl3 \
  --single-window \
  --continue \
  --add res://test/
