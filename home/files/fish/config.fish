function get_venv_info
    set -l venvs
    
    # Python virtual environments
    set -q VIRTUAL_ENV; and set -a venvs (basename $VIRTUAL_ENV)
    
    # Conda environments
    set -q CONDA_DEFAULT_ENV; and test "$CONDA_DEFAULT_ENV" != base; and set -a venvs "conda:$CONDA_DEFAULT_ENV"
    
    # Nix shell
    set -q IN_NIX_SHELL; and set -a venvs "nix"
    
    # Pyenv (check file-based version, faster than command)
    if test -f .python-version
        set -l pyenv_version (cat .python-version 2>/dev/null | head -1)
        test -n "$pyenv_version"; and set -a venvs "py:$pyenv_version"
    else if set -q PYENV_VERSION
        set -a venvs "py:$PYENV_VERSION"
    end
    
    # Poetry virtual env
    set -q POETRY_ACTIVE; and set -a venvs "poetry"
    
    # Pipenv
    set -q PIPENV_ACTIVE; and set -a venvs "pipenv"
    
    # Ruby version managers
    set -q RBENV_VERSION; and set -a venvs "rb:$RBENV_VERSION"
    
    # Rust toolchain
    if test -f rust-toolchain.toml; or test -f rust-toolchain
        set -l toolchain (cat rust-toolchain.toml rust-toolchain 2>/dev/null | head -1)
        test -n "$toolchain"; and set -a venvs "rust:$toolchain"
    end
    
    # Return comma-separated list or empty
    test (count $venvs) -gt 0; and string join ',' $venvs
end

function fish_prompt
    set -l last_status $status
    
    # Colors
    set -l normal (set_color normal)
    set -l blue (set_color cyan)
    set -l green (set_color green)
    set -l red (set_color red)
    set -l yellow (set_color yellow)
    set -l magenta (set_color magenta)
    
    # User
    printf '%s%s%s' $green (whoami) $normal
    
    # Directory (relative to HOME)
    set -l cwd (string replace $HOME '~' (pwd))
    printf ' %s%s%s' $blue $cwd $normal
    
    # Git branch (fast check)
    if test -d .git; or git rev-parse --git-dir >/dev/null 2>&1
        set -l branch (git branch --show-current 2>/dev/null)
        test -n "$branch"; and printf ' %s(%s)%s' $yellow $branch $normal
    end
    
    # Virtual environments
    set -l venv_info (get_venv_info)
    test -n "$venv_info"; and printf ' %s[%s]%s' $magenta $venv_info $normal
    
    # Prompt symbol with status
    printf ' %s❯%s ' (test $last_status -eq 0; and echo $green; or echo $red) $normal
end

if status --is-interactive
    # Load machine-specific environment variables
    set -l env_file $HOME/.config/fish/env.fish
    if test -f $env_file
        source $env_file
    end
    
    # Set default editor to nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    
    # Create alias for vi -> nvim
    alias vi='nvim'
    
    # Create alias for ls -> lsd
    alias ls='lsd'
end
