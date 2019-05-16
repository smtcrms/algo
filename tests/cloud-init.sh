#!/bin/bash
echo "#!/bin/bash
export METHOD=local
export ONDEMAND_CELLULAR=true
export ONDEMAND_WIFI=true
export ONDEMAND_WIFI_EXCLUDE=test1,test2
export WINDOWS=true
export STORE_CAKEY=true
export LOCAL_DNS=true
export SSH_TUNNELING=true
export ENDPOINT=10.0.8.100
export USERS=desktop,user1,user2
export EXTRA_VARS='install_headers=false tests=true apparmor_enabled=false'
export ANSIBLE_EXTRA_ARGS='--skip-tags apparmor'
export REPO_SLUG=${TRAVIS_PULL_REQUEST_SLUG:-${TRAVIS_REPO_SLUG:-trailofbits/algo}}
export REPO_BRANCH=${TRAVIS_PULL_REQUEST_BRANCH:-${TRAVIS_BRANCH:-master}}

curl -s https://raw.githubusercontent.com/${TRAVIS_PULL_REQUEST_SLUG:-${TRAVIS_REPO_SLUG}}/${TRAVIS_PULL_REQUEST_BRANCH:-${TRAVIS_BRANCH}}/install.sh | sudo -E bash -x"
