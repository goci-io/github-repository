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

variable "readme_sync_enabled" {
  type        = bool
  default     = false
  description = "If enabled the content of the README will be synchronized with the version control system. Usually it is a better idea to manage repository related content within the repository itself and only setup the initial structure."
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

variable "is_individual" {
  type        = bool
  default     = false
  description = "When a single person name is specified in the github_organization but the token belongs to an individual"
}

variable "prp_team" {
  type        = string
  default     = ""
  description = "A team of primary responsible people for this project. See also contributors variable"
}

variable "contributors" {
  type        = list(object({
    image_url = string
    name      = string
    url       = string
  }))
  default     = []
  description = "List of contributors to add to the README. See also prp_team variable" 
}

variable "ssh_key_file" {
  type        = string
  default     = "~/.ssh/git_rsa"
  description = "The file path to the ssh key file to use when using git"
}

variable "actions" {
  type        = map(map(string))
  default     = {}
  description = "GitHub Actions to commit to the repository. Available actions can be found in templates/actions"
}

variable "atlantis_modules" {
  type        = list(object({
    path     = string
    name     = string
  }))
  default     = []
  description = "If not empty synchronises the atlantis.yaml with the repository when atlantis_domain is set"
}

variable "atlantis_workspaces" {
  type        = list(object({
    autoplan = bool
    name     = string
    workflow = string
  }))
  default     = []
  description = "Specifies workspaces to deploy the modules into. Defaults to default name and workflow with autoplan true"
}

variable "atlantis_sync_enabled" {
  type        = bool
  default     = true
  description = "Enables sync of atlantis.yaml when there are changes in atlantis_modules or workspaces"
}

variable "atlantis_domain" {
  type        = string
  default     = ""
  description = "Domain of the atlantis server. Must be set to enable atlantis"
}

variable "additional_commits" {
  type        = map(object({
    target = string
    data   = any
  }))
  default     = {}
  description = "Additional files to commit. Key of the map must be the path to the file/template"
}

variable "additional_template_dir" {
  type        = string
  default     = "."
  description = "Path to the directory containing additional files to commit"
}
