#!/usr/bin/env bash
set -euo pipefail
SCENARIO="${1:-pass}"
mkdir -p /tmp/demo && cd /tmp/demo
npm init -y > /dev/null
echo "Scenario: $SCENARIO"
case "$SCENARIO" in
  pass)           node -e "console.log('3 tests passed')" ;;
  test-fail)      node -e "require('assert').strictEqual(1 + 1, 3, 'expected 1+1 to equal 3')" ;;
  build-error)    echo "const x = ;" > broken.js; node --check broken.js ;;
  dependency)     npm install this-package-does-not-exist-zzz-404 ;;
  flaky)          if [ $((RANDOM % 2)) -eq 0 ]; then echo "passed"; else echo "Timing-dependent test failed"; exit 1; fi ;;
  missing-secret) echo "build ok - failure happens at deploy" ;;
  *)              echo "Unknown scenario"; exit 2 ;;
esac
