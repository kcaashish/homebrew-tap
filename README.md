# Homebrew Tap

Personal homebrew tap

```sh
brew install --cask kcaashish/tap/neovim-nightly
```

## neovim-nightly

Neovim deletes and recreates its [`nightly`][upstream] release every night, so
the files behind its download URLs change daily and cannot be pinned to a
checksum. Instead of downloading from there, the cask downloads from a
`neovim-nightly-<version>` release on this repo, a copy of one Neovim nightly
build, and pins the SHA-256 of both macOS tarballs. The version, URL and
checksum in the cask always name the same file.

### How a copy is made

The [bump workflow](.github/workflows/bump-neovim-nightly.yml) runs daily at
07:17 UTC, about two hours after Neovim publishes. GitHub often starts it hours
late. Each run:

1. Finds the newest nightly with `brew livecheck`, which reads the version from
   Neovim's release notes.
2. If this repo has no release for that version yet, downloads
   `nvim-macos-arm64.tar.gz` and `nvim-macos-x86_64.tar.gz` from Neovim and
   checks each against the SHA-256 digest GitHub reports for Neovim's upload.
   Only if both match does it publish them, unchanged, as a prerelease.
3. Writes the version and both checksums into the cask.
4. Downloads both tarballs through the cask with `brew fetch`, then commits and
   pushes the bump.
5. Deletes all but the three newest `neovim-nightly-*` releases.

The release is published before the cask points at it, and the cask is
checked to download correctly before the bump is pushed. A run that fails
partway can simply be rerun; it reuses a release that is already published.

A new nightly reaches `brew upgrade` once the bump commit lands, not when
Neovim publishes it.

### Older taps

`brew install` and `brew upgrade` run `brew update` first unless it already ran
within the last day (the last hour, once a developer command such as
`brew livecheck` has been used). The tap is then at most a bump or two behind,
and the three releases kept here cover that. With `HOMEBREW_NO_AUTO_UPDATE` set, a tap
three or more bumps behind points at a deleted release; run `brew update` first.

### Running the workflow by hand

- **Dry run:** start it from any branch other than `main`, or tick `dry_run`.
  It goes through the same steps on the runner, but publishes no release,
  pushes nothing and deletes nothing.
- **Editing the cask:** a push to `main` that changes the cask or the workflow
  starts a run straight away, which publishes the release the cask needs.
  Pushes made by the workflow itself do not start runs.

[upstream]: https://github.com/neovim/neovim/releases/tag/nightly
