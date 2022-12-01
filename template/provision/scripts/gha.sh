#!/usr/bin/env bash
set -e
set -o pipefail

cd $HOME
echo Removing older runner
rm -r actions-runner
echo Setting new runner
mkdir actions-runner && cd actions-runner
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v$ACTIONS_VERSION/actions-runner-osx-arm64-$ACTIONS_VERSION.tar.gz
tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz

echo Creating teardown script
cd $HOME
mkdir actions-scripts && cd actions-scripts
touch teardown.sh
cat > teardown.sh << EOF
#!/usr/bin/env bash
set -x
set -o pipefail
rm -r $HOME/Library/Developer/Xcode/DerivedData/*
xcrun simctl erase all
EOF

echo Ceating .env for github actions
# Creating .env in actions-runner
cd $HOME/actions-runner
touch .env
cat > .env << EOF
ACTIONS_RUNNER_HOOK_JOB_COMPLETED=$HOME/actions-scripts/teardown.sh
EOF
cat .env
