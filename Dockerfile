FROM debian:buster

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    # Verify git, process tools, lsb-release (common in install instructions for CLIs), wget installed
    && apt-get -y install git procps lsb-release wget \
    # Install Editor
    && apt-get install vim -y \
    # Install PowerShell 7
    && wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Powershell customization
RUN \
    ## Create PS profile
    pwsh -c 'New-Item -Path $profile -ItemType File -Force' \
    ## Add alias
    && pwsh -c "'New-Alias \"tf\" \"terraform\"' | Out-File -FilePath \$profile"

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
