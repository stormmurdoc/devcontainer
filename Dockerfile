FROM debian:12

# https://code.visualstudio.com/docs/remote/containers-advanced#_creating-a-nonroot-user
ARG USERNAME=murdoc
# https://docs.docker.com/engine/reference/builder/#env
# ARG is not persisted in the image so need to set it as ENV so that
# child images built from this can reference it.
ENV USERNAME=${USERNAME}
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# hadolint disable=DL3008
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/zsh \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends ssh sudo python3 python3-apt bash zsh \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Get git, starship shell and vim installed.
    # This explains why you should not separate
    # the `apt-get update` and
    # the remaining `apt-get install commands`:
    # http://lenguyenthedat.com/docker-cache/
    && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    vim git curl ca-certificates build-essential git-lfs

USER $USERNAME
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes \
    && git config --global core.editor "vim" \
    && git config --global user.email "murdoc@storm-clan.de" \
    && git config --global user.name "Patrick" \
    #
    # https://code.visualstudio.com/docs/remote/containers-advanced#_persist-zsh-history-between-runs
    && SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history" \
    && sudo mkdir /commandhistory \
    && sudo touch /commandhistory/.zsh_history \
    && sudo chown -R $USERNAME /commandhistory \
    && echo $SNIPPET >> "/home/$USERNAME/.zshrc" \
    && echo 'eval "$(starship init zsh)"' >> "/home/$USERNAME/.zshrc" \
    && echo 'export TERM=ansi' >> "/home/$USERNAME/.zshrc" \
    && echo 'alias ll="ls -l"' >> "/home/$USERNAME/.zshrc"
