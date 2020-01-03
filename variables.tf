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

variable "create_webhook" {
  type        = bool
  default     = true
  description = "Creates a webhook for push events"
}

variable "webhook_push_name" {
  type        = string
  default     = "trigger-change-update"
  description = "The name of the webhook"
}

variable "webhook_push_url" {
  type        = string
  default     = ""
  description = "URL to send webhook events to"
}

variable "webhook_push_secret" {
  type        = string
  default     = ""
  description = "Secret to include in webhook events"
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

variable "ssh_key_file" {
  type        = string
  default     = "~/.ssh/git_rsa"
  description = "The file path to the ssh key file to use when using git"
}

variable "project_id" {
  type        = string
  description = "A project ID to uniquely identify the project"
}

variable "account_id" {
  type        = string
  description = "Account ID the project belongs to"
}

variable "actions" {
  type        = map(map(string))
  default     = {}
  description = "GitHub Actions to commit to the repository. Available actions can be found in templates/actions"
}
