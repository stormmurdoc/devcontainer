# Developer Image
FROM debian:12@sha256:321341744acb788e251ebd374aecc1a42d60ce65da7bd4ee9207ff6be6686a62

# https://code.visualstudio.com/docs/remote/containers-advanced#_creating-a-nonroot-user
ARG USERNAME=murdoc
ARG NAME="Patrick"
ARG EMAIL="murdoc@storm-clan.de"

LABEL org.opencontainers.image.authors="murdoc@storm-clan.de" \
      org.label-schema.name="DevPod Image" \
      org.label-schema.vendor="murdoc" \
      org.label-schema.schema-version="0.11" \
      org.opencontainers.image.description="Debian 12 Development Container for DevPod" \
      org.opencontainers.image.licenses=MIT

# https://docs.docker.com/engine/reference/builder/#env
# ARG is not persisted in the image so need to set it as ENV so that
# child images built from this can reference it.
ENV USERNAME=${USERNAME}
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# > Force apt to not be interactive/not ask
ENV DEBIAN_FRONTEND=noninteractive

# Set image timezone
ENV TZ=Europe/Berlin
# Set image locale.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
#ENV LANG C.UTF-8
ENV LC_ALL=C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/zsh \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends ssh sudo bash zsh zsh-syntax-highlighting zsh-autosuggestions \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Get git, starship shell and vim installed.
    # This explains why you should not separate
    # the `apt-get update` and
    # the remaining `apt-get install commands`:
    # http://lenguyenthedat.com/docker-cache/
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        python3 python3-apt pip vim cmake wget libtool autoconf automake cmake \
        libncurses5-dev g++ git curl ca-certificates build-essential git-lfs \
        lf ripgrep shellcheck npm unzip python3.11-venv bat jq yq \
        tmux tmux-plugin-manager fzf locate locales \
    && pip install --no-cache-dir --break-system-packages pre-commit ansible \
    && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && ln -s /squashfs-root/AppRun /usr/bin/nvim \
    && NVIM_PATH=/usr/bin/nvim \
    && update-alternatives --install /usr/bin/ex ex "${NVIM_PATH}" 110 \
    && update-alternatives --install /usr/bin/vi vi "${NVIM_PATH}" 110 \
    && update-alternatives --install /usr/bin/view view "${NVIM_PATH}" 110 \
    && update-alternatives --install /usr/bin/vim vim "${NVIM_PATH}" 110 \
    && update-alternatives --install /usr/bin/vimdiff vimdiff "${NVIM_PATH}" 110 \
    && sed --in-place '/en_US.UTF-8/s/^# //' /etc/locale.gen \
    && sed --in-place '/de_DE.UTF-8/s/^# //' /etc/locale.gen \
    && locale-gen \
    && LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && install lazygit /usr/local/bin \
    && rm lazygit.tar.gz \
    && rm -rf ./lazygit

USER $USERNAME
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes \
    && git config --global core.editor "vim" \
    && git config --global user.email "$EMAIL" \
    && git config --global user.name "$NAME" \
    && git config --global alias.br 'branch' \
    && git config --global alias.ci 'commit' \
    && git config --global alias.co 'checkout' \
    && git config --global alias.cob 'checkout -d' \
    && git config --global alias.df 'diff' \
    && git config --global alias.del 'branch -D' \
    && git config --global alias.s 'status' \
    && git config --global alias.st 'status' \
    && git config --global alias.up 'rebase' \
    && git config --global alias.undo 'reset HEAD~1 --mixed' \
    && git config --global alias.unstage 'reset HEAD --' \
    && set -o vi \
    && SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history" \
    && sudo mkdir /commandhistory \
    && sudo touch /commandhistory/.zsh_history \
    && sudo chown -R $USERNAME /commandhistory \
    && echo $SNIPPET >> "/home/$USERNAME/.zshrc" \
    && echo 'eval "$(starship init zsh)"' >> "/home/$USERNAME/.zshrc" \
    && echo 'export TERM=ansi' >> "/home/$USERNAME/.zshrc" \
    && echo 'alias ll="ls -l"' >> "/home/$USERNAME/.zshrc" \
    && echo 'alias lg="lazygit"' >> "/home/$USERNAME/.zshrc" \
    # && git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 \
    # && git clone https://github.com/stormmurdoc/nvchad-custom-config ~/.config/nvim/lua/custom --depth 1 \
    && git clone https://github.com/NvChad/starter ~/.config/nvim \
    && nvim --headless +PlugInstall +qall
