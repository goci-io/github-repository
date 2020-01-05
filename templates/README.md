# ${repository}

%{ for workflow in workflows ~}
[![](https://${github_url}/${organization}/${repository}/workflows/${replace(workflow, "/\\s/", "%20")}/badge.svg?branch=master)](https://${github_url}/${organization}/${repository}/actions?query=workflow%3A"${urlencode(workflow)}")
%{ endfor ~}

${description}
