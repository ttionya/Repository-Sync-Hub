# Repository Sync Hub

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/ttionya/Repository-Sync-Hub?label=Release&logo=github) [![GitHub](https://img.shields.io/github/license/ttionya/vaultwarden-backup?label=License&logo=github)](https://github.com/ttionya/Repository-Sync-Hub/blob/master/LICENSE)

A GitHub Actions for sync current repository to other hub.

## Features

- Sync branches and tags to other repository (GitHub, GitLab, Gitee, etc.)
- Target repository support SSH and HTTP URL
- Automatic delete branches and tags that is deleted
- Can triggered on `PUSH` and `DELETE` event
- Can triggered on a timer (`SCHEDULE`)

## Usage

Be sure to run the [actions/checkout](https://github.com/actions/checkout) in a step before this action.

### SSH URL

```yml
# File .github/workflows/sync-ssh.yml

steps:
  - uses: actions/checkout@v2
    with:
      fetch-depth: 0
  - uses: ttionya/Repository-Sync-Hub@v1
    with:
      # Sync to target repository full clone URL.
      target_repository: 'git@github.com:ttionya/Repository-Sync-Hub-Test.git'
      # SSH key used to authenticate with git operations.
      ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
```

### HTTP URL

```yml
# File .github/workflows/sync-http.yml

steps:
  - uses: actions/checkout@v2
    with:
      fetch-depth: 0
      # Be sure use your own access token when you want to sync to GitHub repository,
      # only HTTP URL need this.
      token: ${{ secrets.HTTP_ACCESS_TOKEN }}
  - uses: ttionya/Repository-Sync-Hub@v1
    with:
      # Sync to target repository full clone URL.
      target_repository: 'https://github.com/ttionya/Repository-Sync-Hub-Test.git'
      # Login name used to authenticate with git operations.
      http_access_name: 'ttionya'
      # Personal Access Token (PAT) used to authenticate with git operations.
      http_access_token: ${{ secrets.HTTP_ACCESS_TOKEN }}
```

**Note:** Access token needs **workflow** access, it will automatically check the full access to the repository.

You can see [sample workflows](/.github/workflows/) for more usages.

## Thanks

Inspired by the following actions which may be more suitable for your workflow.

- [wei/git-sync](https://github.com/wei/git-sync)
- [net-engine/github-repository-sync-action](https://github.com/net-engine/github-repository-sync-action)

## License

MIT
