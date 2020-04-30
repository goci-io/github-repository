variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create resources at all"
}

variable "create_repository" {
  type        = bool
  default     = true
  description = "Whether to create a new repository for this project or not"
}

variable "create_branch_protection" {
  type        = bool
  default     = true
  description = "Whether to enable branch protection on the master or not"
}

variable "status_checks" {
  type        = list(string)
  default     = []
  description = "List of status checks to require in order to merge"
}

variable "repository_name" {
  type        = string
  description = "Name of the git repository"
}

variable "repository_visibility_private" {
  type        = bool
  default     = false
  description = "Set to true to make the repository private"
}

variable "repository_description" {
  type        = string
  default     = "Repository created by goci-io/github-repository"
  description = "Description for the repository"
}

variable "delete_branch_on_merge" {
  type        = bool
  default     = true
  description = "Automatically delete head branches after merge. Generally its a good idea to keep open branches clean"
}

variable "homepage_url" {
  type        = string
  default     = ""
  description = "Homepage url to reference on the repository page on github"
}

variable "topics" {
  type        = list(string)
  default     = []
  description = "Topics the repository and project is about"
}

variable "gitignore_template" {
  type        = string
  default     = ""
  description = "Template name for the .gitignore file"
}

variable "license_template" {
  type        = string
  default     = "apache-2.0"
  description = "Template name for the .gitignore file"
}

variable "description" {
  type        = string
  default     = "Repository created by [goci-io/github-repository](https://github.com/goci-io/github-repository)"
  description = "Initial README description text"
}

variable "webhooks" {
  type        = list(any)
  default     = []
  description = "List of webhooks to add. Object containing url and name. Optionally you can overwrite events with a list of webhook events and the secret to use. Otherwise there is an autogenerated secret used"
}

variable "github_base_url" {
  type        = string
  default     = "github.com"
  description = "Base url to the github website"
}

variable "github_organization" {
  type        = string
  description = "The name of the github organization or individual"
}

variable "github_token" {
  type        = string
  default     = ""
  description = "Github token to use to manage settings. Defaults to environment variable GITHUB_TOKEN"
}

variable "is_individual" {
  type        = bool
  default     = false
  description = "When a single person name is specified in the github_organization but the token belongs to an individual"
}

variable "create_team" {
  type        = bool
  default     = false
  description = "If set to true we will try to create the Team specified in prp_team"
}

variable "prp_team" {
  type        = string
  default     = ""
  description = "A team of primary responsible people for this project. See also contributors variable"
}

variable "labels" {
  type = list(object({
    name  = string
    color = string
    # description = string
  }))
  default     = []
  description = "Issue labels for this repository"
}

variable "require_review" {
  type        = bool
  default     = true
  description = "Pull-Request will only be mergeable when it was approved by at least one contributor"
}

variable "create_readme" {
  type        = bool
  default     = true
  description = "Whether to commit an initial README file. Defaults to false when create_repository is set to false"
}

variable "additional_teams" {
  type        = list(object({ name = string, permission = string }))
  default     = []
  description = "Additional teams to grant access to the repository"
}

variable "action_secrets" {
  type        = map(string)
  default     = {}
  description = "Secrets to be added to the repository"
}

variable "ssh_key_file" {
  type        = string
  default     = ""
  description = "The file path to the ssh key file to use when using git. Generate one if empty"
}

variable "public_ssh_key_file" {
  type        = string
  default     = ""
  description = "The file path to the public ssh key file to be uploaded to github"
}

variable "actions" {
  type        = any
  default     = {}
  description = "GitHub Actions to commit to the repository. Available actions can be found in templates/actions"
}

variable "atlantis_workspaces" {
  type = list(object({
    autoplan = bool
    name     = string
    workflow = string
  }))
  default     = []
  description = "Specifies workspaces to deploy the modules into. Defaults to default name and workflow with autoplan true"
}

variable "atlantis_domain" {
  type        = string
  default     = ""
  description = "Domain of the atlantis server. Must be set to enable atlantis"
}

variable "atlantis_webhook_secret" {
  type        = string
  default     = ""
  description = "Webhook secret to use for atlantis. It must be the same secret for all repositories"
}

variable "atlantis_observe_changes" {
  type        = bool
  default     = true
  description = "When there are a changes to the template a new commit will be created"
}

variable "atlantis_branch" {
  type        = string
  default     = "atlantis"
  description = "The branch changes to atlantis files should be pushed to"
}

variable "additional_commits" {
  type        = any
  default     = {}
  description = "Additional files to commit. Key of the map must be the path to the file/template. Must contain target attribute and additional map of data"
}

variable "additional_template_dir" {
  type        = string
  default     = "."
  description = "Path to the directory containing additional files to commit"
}

variable "sync_additional_commits" {
  type        = bool
  default     = false
  description = "Creates new branches for changes in the tempate files"
}

variable "repository_checkout_dir" {
  type        = string
  default     = "/conf/git/checkout"
  description = "Directory to clone repositories to"
}

variable "enable_projects" {
  type        = bool
  default     = false
  description = "Enables Github Projects for the repository"
}

variable "enable_issues" {
  type        = bool
  default     = true
  description = "Enables Github Issues for the repository"
}

variable "enable_wiki" {
  type        = bool
  default     = true
  description = "Enables Github Wiki for the repository"
}
