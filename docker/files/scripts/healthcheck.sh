#!/bin/bash
set -e

# Check if Postfix master process is running
if postfix status > /dev/null 2>&1
then
  exit 0
else
  exit 1
fi
