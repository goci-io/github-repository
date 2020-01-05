# ${repository}

%{ for workflow in workflows ~}
[![](https://${github_url}/${organization}/${repository}/workflows/${workflow}/badge.svg)](https://${github_url}/${organization}/${repository}/actions?query=workflow%3A"${workflow}")
%{ endfor ~}

${description}
