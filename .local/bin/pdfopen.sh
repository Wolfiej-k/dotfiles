#!/bin/bash

new_arg=()
idx_mnt_occur=0

for arg in "$@"; do
  if [[ "$arg" == /mnt* ]]; then
    ((idx_mnt_occur++))
    win_path=$(wslpath -m "$arg")
    new_arg+=("$win_path")

    if [[ $idx_mnt_occur -eq 1 ]]; then
      find "${PWD}" -maxdepth 1 -name "*.synctex.gz" -execdir \
        bash -c 'cat "$1" | gunzip | sed "s@/mnt/\(.\)/@\1:/@g" | gzip > "$1.tmp" && mv "$1.tmp" "$1"' _ {} \;
    fi
  else
    new_arg+=("$arg")
  fi
done

SumatraPDF.exe "${new_arg[@]}"
