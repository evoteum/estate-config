locals {
  website = "${var.org_name}.com"
  repos_names_alphabetical = sort(data.github_repositories.all.names)
  repos_full_names_alphabetical = sort(data.github_repositories.all.full_names)
}
