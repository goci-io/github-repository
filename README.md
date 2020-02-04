# github-repository

The first rule of `github-repository` is don't talk about `github-repository`

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

This module provisions a new github repository. A new repository consists of the following:

- Initial `README.md`, `LICENSE` and `.gitignore` file  
- GitHub Actions to build and deploy the project (optional)  
- Webhook for push events, including a secret (optional)  

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
  create_webhook           = false
  create_branch_protection = false
  topics                   = ["projectX"]
}
```

Look into the [terraform.tfvars](terraform.tfvars.example) example file or find more variables in the [variables.tf](variables.tf).
You also need to make sure to have a valid token set in `GITHUB_TOKEN` environment variable to configure the terraform provider.

### Configuration

| Name | Description | Default |
|-----------------|----------------------------------------|---------|
| github_base_url | The base url to github | `github.com` |
| github_organization | The organization name to create resources for | - |
| create_repository | Creates the repository if set to true | `true` |
| repository_name | The name of the repository | - |
| repository_description | Short description of the repository | `Repository created by goci-io/github-repository` |
| repository_visibility_private | If set to true the repository will be private | `false` | 
| topics | List of strings as topis to attach to the repository | `[]` |
| homepage_url | URL to a homepage on the repository | - |
| description | Initial README description | `repository_description` | 
| create_branch_protection | Creates a branch protection for the master branch | `true` |
| webhooks | Creates webhooks for events. List of object with name and url. Additionally you can set events and secret | `[]` |
| license_template | Name of license template to use | `apache-2.0` |
| gitignore_template | Name of the gitignore template to use | - |
| prp_team | Team of rimary responsible people | - |
| contributors | List of contributors to add to the initial README | `[]` |
| ssh_key_file | Path to the SSH key file to use | `~/.ssh/git_rsa` |
| status_checks | List of required status checks before merging. Only used when branch protection is enabled | `[]` |
| actions | Map of actions and config to enable | `{}` | 
| atlantis_modules | List of Terraform modules to enable [atlantis](https://www.runatlantis.io/guide/) for. If not empty it takes care about the repo level atlantis config | `[]` |
| atlantis_workspaces | List of workspaces to deploy Terraform modules for | `[{ name = "default", workflow = "default" }]` |
| atlantis_sync_enabled | Enables sync of updated atlantis.yaml. If false no updates are made | `true` |
| atlantis_url | URL to the atlantis server. Must be set to enable atlantis. | `""` |

Example GitHub-Action configuration:
```hcl
actions = {
  template-name = {
    config-data-key = value
  },
  ...
}
```

The template name should reference a file created in [`templates`](https://github.com/goci-io/github-repository/tree/master/templates) directory ending with `.yaml`. By default the following action templates are already included:   
- [actions/goci-terraform-app-deployment](https://github.com/goci-io/github-repository/tree/master/templates/actions/goci-terraform-app-deployment.yaml)  
- [actions/goci-terraform-pull-request](https://github.com/goci-io/github-repository/tree/master/templates/actions/goci-terraform-pull-request.yaml)  
- [actions/goci-terraform-change](https://github.com/goci-io/github-repository/tree/master/templates/actions/goci-terraform-change.yaml)  


Example [Atlantis](https://www.runatlantis.io/guide/) configuration for the repo level config:
```hcl
atlantis_workspaces = [
  {
    name     = "staging"
    workflow = "staging-aws"
    autoplan = true
  },
  {
    name     = "prod"
    workflow = "prod-aws"
    autoplan = true
  }
]

atlantis_modules = [
  {
    name = "cloudtrail"
    path = "modules/aws/cloudtrail"
  }
]
```

#### Todos
- Allow to use without goci context (project- and account-id)  
