# Clone a repo into ~/git/<host>/<org>/<repo> and print that path.
def parse-git-url [repo_url: string] {
  let ssh = $repo_url | parse --regex '^git@(?<host>[^:]+):(?<org>[^/]+)/(?<repo>[^/]+?)(?:\.git)?$'
  if not ($ssh | is-empty) { return $ssh.0 }

  let https = $repo_url | parse --regex '^https://(?<host>[^/]+)/(?<org>[^/]+)/(?<repo>[^/]+?)(?:\.git)?$'
  if not ($https | is-empty) { return $https.0 }

  error make {
    msg: $"Unsupported git URL: ($repo_url)"
    help: "Expected git@host:org/repo.git or https://host/org/repo.git"
  }
}

def main [repo_url: string] {
  let repo_url = $repo_url | str trim
  let parts = parse-git-url $repo_url
  let dest = $"($env.HOME)/git/($parts.host)/($parts.org)/($parts.repo)"

  mkdir ($dest | path dirname)

  if not ($dest | path exists) {
    ^git clone $repo_url $dest
  }

  print $dest
}
