# Repository Sync Hub

A GitHub Actions for sync current repository to other hub.

## Features

- Sync branches and tags to other repository (GitHub, GitLab, Gitee, etc.)
- Automatic delete branches and tags that is deleted
- Can triggered on `PUSH` and `DELETE` event
- Can triggered on a timer (`SCHEDULE`)

## Usage

Be sure to run the [actions/checkout](https://github.com/actions/checkout) in a step before this action.

```yml
# File .github/workflows/sync.yml

steps:
  - uses: actions/checkout@v2
    with:
      fetch-depth: 0
  - uses: ttionya/Repository-Sync-Hub@v1
    with:
      # Sync to target repository full clone URL (SSH Only)
      target_repository: 'git@github.com:ttionya/Repository-Sync-Hub-Test.git'
      # SSH key used to authenticate with git operations (optional)
      ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
```

Please see [sample workflows](/.github/workflows/) for more usages.

## Thanks

Inspired by the following actions which may be more suitable for your workflow.

- [wei/git-sync](https://github.com/wei/git-sync)
- [net-engine/github-repository-sync-action](https://github.com/net-engine/github-repository-sync-action)

## License

MIT
