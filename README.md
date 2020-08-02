# github-repository

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

![terraform](https://github.com/goci-io/github-repository/workflows/terraform/badge.svg?branch=master&event=push)

This module provisions a new github repository. A new repository consists of the following:

- Initial `README.md`, `LICENSE` and `.gitignore` file  
- GitHub Actions to build and deploy the project (optional)  
- Webhook with ability to autogenerate secrets (optional)  
- Commit and sync additional files (optional)  
- Branch protections and repository settings

Changes to any file, unrelated to the project itself (eg. github actions), are commited and pushed to a new branch.
You are responsible to create new pull requests, review and accept them. You can also use this module for an existing repository to deploy settings like branch protection and github actions.

A bare example and change history can be found [here](https://github.com/goci-io/goci-repository-setup-example).
This example is generated based on the terraform.tfvars.example.

### Usage

```hcl
module "repository" {
  source                   = "git::https://github.com/goci-io/github-repository.git?ref=tags/<latest-version>"
  repository_name          = "goci-repository-setup-example"
  github_organization      = "goci-io"
  create_branch_protection = false
  topics                   = ["projectX"]
  webhooks                 = [
    {
      name   = "webhook"
      events = ["push"]
      url    = "https://notify.me.on.events.com"
    }
  ]
}
```

Look into the [terraform.tfvars](terraform.tfvars.example) example file or find more variables in the [variables.tf](variables.tf).
Make sure to configure your Github Provider with a Token set (e.g. via `GITHUB_TOKEN` environment variable).

In case the repository already exists but you still want to configure settings you can set `create_repository` to false.

### Configuration

| Name | Description | Default |
|-----------------|----------------------------------------|---------|
| enabled | Whether to create any resources at all | `true` |
| github_base_url | The base url to github | `github.com` |
| github_organization | The organization name to create resources for | - |
| create_repository | Creates the repository if set to true | `true` |
| repository_name | The name of the repository | - |
| repository_description | Short description of the repository | `Repository created by goci-io/github-repository` |
| repository_visibility_private | If set to true the repository will be private | `false` | 
| topics | List of strings as topis to attach to the repository | `[]` |
| homepage_url | URL to a homepage on the repository | - |
| description | Initial README description | `repository_description` | 
| enable_projects | Enables Github Projects for the repository | `false` |
| enable_issues | Enables Github Issues for the repository | `true` |
| enable_wiki | Enables Github Wiki for the repository | `true` |
| create_branch_protection | Creates a branch protection for the master branch | `true` |
| webhooks | Creates webhooks for events. List of object with url and additionally you can set events and secret | `[]` |
| license_template | Name of license template to use | `apache-2.0` |
| gitignore_template | Name of the gitignore template to use | - |
| prp_team | Team of rimary responsible people | - |
| create_team | If set to true we will create the team specified in `prp_team` | `false` |
| ssh_key_file | Path to the private SSH key file to use. Leave empty to generate one | `""` |
| public_ssh_key_file | Path to the SSH key file to upload to github. Leave empty to generate one | `""` |
| status_checks | List of required status checks before merging. Only used when branch protection is enabled | `[]` |
| actions | Map of actions and config to enable | `{}` | 
| additional_commits | List of objects with additional templatefiles to commit and sync | `[]` |
| additional_template_dir | Path to the template directory containing your additional files | `"."` | 
| sync_additional_commits | Creates new branches for changes in the tempate files | `false` |

##### Example GitHub-Action configuration:
```hcl
actions = {
  "terraform/pull-request" = {
    environment  = {}
    make_plan    = false
    check_format = true
    working_dirs = ["."]
  },
  ...
}
```

The template name should reference a file created in [`templates`](https://github.com/goci-io/github-repository/tree/master/templates) directory ending with `.yaml`.

##### CI credentials

The SSH-Key given in `ssh_key_file` can be updated at any time. To make changes to your repository and create new branches we use a Github Deploy Key which is limited to the scope of your repository and stays in sync with your SSH key. We suggest to leave `ssh_key_file` **empty** to autogenerate an SSH key. To rotate the auto generated SSH key you need to destroy the SSH key resource using `terraform destroy -target=tls_private_key.ci_ssh`. 

You either need to provide an already configured Github provider and inject it using `providers = { github = github.my-provider }` or pass `github_token` variable to this module. The token needs to have access to make changes to the repository settings on your behalf, manage deploy keys and create repositories when `create_repository` is set to true (default).

##### Example `additional_commits` configuration
```hcl
sync_additional_commits = true|false
additional_template_dir = abspath(path.module)
additional_commits      = {
  "templates/my-file" = {
    target = "dir/file"
    data   = {
      template_variable = "value"
    }
  }
}
```

This configuration will create a file called `file` within the `dir` directory. Before committing the file all terraform variables are replaced.
Therefore you also always need to make sure to escape `${}` in your template files with `$${}`. 

Please refer to [terraform-git-commit](https://github.com/goci-io/terraform-git-commit) module to create completely customized git commits.
