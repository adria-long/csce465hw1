#set -evo pipefall

if [[ "$#" -ne 1 || "$1" != "course-marker" ]]; then
	printf 'Usage: %s course-maker\n' "$0" >&2
	exit 1
fi

readonly MARKER_FILE="$HOME/csce465-agentsec/hw1/markers/marker.txt"

printf '%s\n' "course-marker" > "$MARKER_FILE"
printf 'Created marker: %s\n' "$MARKER_FILE"
