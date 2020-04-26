# ${repository}

%{ for workflow in workflows ~}
[![](https://${github_url}/${organization}/${repository}/workflows/${replace(workflow, " ", "%20")}/badge.svg?branch=master)](https://${github_url}/${organization}/${repository}/actions?query=workflow%3A"${urlencode(workflow)}")
%{ endfor ~}

%{ if prp_team != "" ~}
**Maintained by [@${organization}/${prp_team}](https://github.com/orgs/${organization}/teams/${prp_team})**
%{ endif ~}

${description}

_This repository was created via [github-repository](https://github.com/goci-io/github-repository). Synchronization for this file is not enabled, which means that you are responsible to keep it up to date. Think about codifying your repository settings as with any other provider!_
