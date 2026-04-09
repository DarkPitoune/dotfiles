#!/bin/bash
set -e

# Ensure .ssh directory exists with correct permissions
mkdir -p /home/pitoune/.ssh
cp /etc/ssh/authorized_keys /home/pitoune/.ssh/authorized_keys
chmod 700 /home/pitoune/.ssh
chmod 600 /home/pitoune/.ssh/authorized_keys
chown -R pitoune:pitoune /home/pitoune/.ssh

# First boot setup (home is a persistent volume)
if [ ! -d /home/pitoune/.oh-my-zsh ]; then
  su - pitoune -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' \
    || echo "WARN: oh-my-zsh install failed, skipping"
fi

if [ ! -d /home/pitoune/.dotfiles ]; then
  su - pitoune -c 'git clone --bare https://github.com/darkpitoune/dotfiles.git /home/pitoune/.dotfiles' \
    && su - pitoune -c 'git --git-dir=/home/pitoune/.dotfiles --work-tree=/home/pitoune checkout -f' \
    || echo "WARN: dotfiles clone failed, skipping"
fi

# Write machine-specific local configs (always overwrite)
cat > /home/pitoune/.zshrc.local <<'EOF'
PROMPT="%F{cyan}[devbox]%f %F{green}%n%f:%F{blue}%~%f$ "
if [ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ]; then
  tmux attach-session -t main 2>/dev/null || tmux new-session -s main; exit
fi
EOF
chown pitoune:pitoune /home/pitoune/.zshrc.local

cat > /home/pitoune/.tmux.conf.local <<'EOF'
# Devbox - cyan
set -g @host-name "devbox"
set -g @host-color "#56b6c2"
EOF
chown pitoune:pitoune /home/pitoune/.tmux.conf.local

# Start SSH daemon in foreground
exec /usr/sbin/sshd -D -e
