#!/usr/bin/env bash
set -euo pipefail

FLAGS=""
SSH_VERSION_REPLACEMENT="SSH-2.0-OpenSSH_9.3"
USERDB_RULES=(
  "phil:x:!*"
  "richard:x:!*"
  "root:x:!root"
  "root:x:*"
  "*:x:*"
)

VALID_CONFIGS=(1 2 3 4 5 6)

show_usage() {
  echo "Usage: $0 [config_variant_number...]"
  echo
  echo "List of configuration variants:"
  echo -e " 1\tChange SSH banner to '$SSH_VERSION_REPLACEMENT'"
  echo -e " 2\tChange key order and use different keys (to be implemented)"
  echo -e " 3\tChange accepted user names and passwords"
  echo -e " 4\tChange outputs from commands like 'uname -a' (to be implemented)"
  echo -e " 5\tChange file structure layout (to be implemented)"
  echo -e " 6\tPersist file system of sessions (to be implemented)"
  echo
  echo "Example of starting a cowrie container with configuration variants 3 and 4 both applied:"
  echo -e "\t$0 3 4"
}

if [ "$#" -eq 0 ]; then
  echo "No configuration provided."
  echo "Cowrie with default configurations will be started."
  echo "To add configurations, consider the following:"
  echo
  show_usage
fi

CONFIGS="$@"


for CONFIG in ${CONFIGS[@]}; do
  case $CONFIG in
    1)
      FLAGS="${FLAGS:+$FLAGS }-e COWRIE_SSH_VERSION=${SSH_VERSION_REPLACEMENT} -e COWRIE_SHELL_SSH_VERSION=${SSH_VERSION_REPLACEMENT}"
      ;;
    2)
      echo "2 is not yet implemented"
      ;;
    3)
      TMP_USERDB="$(mktemp)"
      printf "%s\n" "${USERDB_RULES[@]}" > "$TMP_USERDB"
      chmod 644 "$TMP_USERDB"
      FLAGS="${FLAGS:+$FLAGS }-v ${TMP_USERDB}:/cowrie/cowrie-git/etc/userdb.txt:ro"
      ;;
    4)
      echo "4 is not yet implemented"
      ;;
    5)
      echo "5 is not yet implemented"
      ;;
    6)
      echo "6 is not yet implemented"
      ;;
    *)
      echo "'$CONFIG' is not a valid config. Choose from '${VALID_CONFIGS[*]}'."
      echo
      show_usage
      exit 1
      ;;
  esac
done

DOCKER_RUN_COMMAND="docker run ${FLAGS:+$FLAGS }-p 2222:2222/tcp cowrie/cowrie"

echo "Command run:"
echo "$DOCKER_RUN_COMMAND"
echo

$DOCKER_RUN_COMMAND
