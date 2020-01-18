# ${repository}

%{ for workflow in workflows ~}
[![](https://${github_url}/${organization}/${repository}/workflows/${replace(workflow, "/\\s/", "%20")}/badge.svg?branch=master)](https://${github_url}/${organization}/${repository}/actions?query=workflow%3A"${urlencode(workflow)}")
%{ endfor ~}

%{ if prp_team ~}
**Maintained by [@${organization}/${prp_team}](https://github.com/orgs/${organization}/teams/${prp_team})**
%{ endif ~}

${description}

${ if length(contributors) > 0 ~}
### Contributors

%{ for contributor in contributors ~}
  [![${contributor.name}](${contributor.image_url})<br/>[${contributor.name}](${contributor.url})] |
%{ endfor ~}
${ endif ~}
