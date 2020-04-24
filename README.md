# github-repository

The first rule of `github-repository` is don't talk about `github-repository`

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

This module provisions a new github repository. A new repository consists of the following:

- Initial `README.md`, `LICENSE` and `.gitignore` file  
- GitHub Actions to build and deploy the project (optional)  
- Webhook with ability to autogenerate secrets (optional)  
- [Atlantis](https://www.runatlantis.io/guide/) Repo level configuration (optional)  
- Commit and sync additional files (optional)  

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
You also need to make sure to have a valid token set in `GITHUB_TOKEN` environment variable to configure the terraform provider.

### Configuration

| Name | Description | Default |
|-----------------|----------------------------------------|---------|
| github_base_url | The base url to github | `github.com` |
| github_organization | The organization name to create resources for | - |
| github_token | Github token to use to manage settings. Defaults to environment variable `GITHUB_TOKEN` | `""` |
| create_repository | Creates the repository if set to true | `true` |
| repository_name | The name of the repository | - |
| repository_description | Short description of the repository | `Repository created by goci-io/github-repository` |
| repository_visibility_private | If set to true the repository will be private | `false` | 
| topics | List of strings as topis to attach to the repository | `[]` |
| homepage_url | URL to a homepage on the repository | - |
| description | Initial README description | `repository_description` | 
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
| atlantis_workspaces | List of workspaces to deploy Terraform modules for | `[{ name = "default", workflow = "default" }]` |
| atlantis_domain | Domain of the atlantis server. Must be set to enable atlantis. | `""` |
| additional_commits | List of objects with additional templatefiles to commit and sync | `[]` |
| additional_template_dir | Path to the template directory containing your additional files | `"."` | 

##### Example GitHub-Action configuration:
```hcl
actions = {
  template-name = {
    config-data-key = value
  },
  ...
}
```

The template name should reference a file created in [`templates`](https://github.com/goci-io/github-repository/tree/master/templates) directory ending with `.yaml`.

##### Example [Atlantis](https://www.runatlantis.io/guide/) configuration for the repo level config:
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
```

This creates the `atlantis.yaml` repo level configuration and the corresponding webhook to notify atlantis about changes in your infrastructure.

##### Example `additional_commits` configuration
```hcl
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

If you need to make different commits, enable or stop sync of specific files you may want to use [terraform-git-commit](https://github.com/goci-io/terraform-git-commit) module and configure it specifically for your needs.
