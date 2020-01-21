#!/bin/bash

# Install oh-my-zs on the supervisor of cluster                                                                                                                
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"    
sed -i 's/plugins\=\(git\)/plugins\=\(git kubectl\)/g' ~/.zshrc                     
echo -e "PROMPT='%(!.%{%F{yellow}%}.)\$USER@%{\$fg[white]%}%M \${ret_status} %{\$fg[cyan]%}%c%{\$reset_color%} \$(git_prompt_info) '" >> ~/.zshrc
echo "KUBECONFIG=\"\$HOME/.kube/config\"" 
