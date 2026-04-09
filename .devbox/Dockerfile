FROM debian:bookworm-slim

# ── System packages ──────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server zsh tmux git curl wget vim build-essential \
    python3 python3-pip python3-venv \
    locales sudo ripgrep fd-find unzip jq ca-certificates gnupg \
  && rm -rf /var/lib/apt/lists/*

# ── Locale ───────────────────────────────────────────────────────
RUN sed -i 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# ── Timezone ───────────────────────────────────────────────────
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ── Node.js 24 via NodeSource ────────────────────────────────────
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

# ── pnpm & bun ──────────────────────────────────────────────────
RUN corepack enable && corepack prepare pnpm@latest --activate
RUN curl -fsSL https://bun.sh/install | BUN_INSTALL=/usr/local bash

# ── Neovim (latest stable from GitHub) ──────────────────────────
RUN curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    | tar xz -C /opt \
  && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# ── zoxide & thefuck ────────────────────────────────────────────
RUN curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash \
  && cp /root/.local/bin/zoxide /usr/local/bin/zoxide
RUN pip3 install --break-system-packages thefuck

# ── vim-plug ───────────────────────────────────────────────────
RUN curl -fLo /usr/share/vim/vimfiles/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# ── Claude Code CLI ─────────────────────────────────────────────
RUN npm install -g @anthropic-ai/claude-code

# ── User setup ──────────────────────────────────────────────────
RUN useradd -m -s /bin/zsh -G sudo pitoune \
  && passwd -l pitoune \
  && echo 'pitoune ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/pitoune

# ── Oh My Zsh for pitoune ───────────────────────────────────────
RUN su - pitoune -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# ── SSH config ──────────────────────────────────────────────────
RUN mkdir -p /run/sshd \
  && sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
  && sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
  && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
  && sed -i 's/#AllowAgentForwarding.*/AllowAgentForwarding yes/' /etc/ssh/sshd_config

# ── Entrypoint ──────────────────────────────────────────────────
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 5173
ENTRYPOINT ["/entrypoint.sh"]
