# suppress suspend by C-s
stty stop undef

# remove duplicated path
typeset -gxU PATH=$PATH

# history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_space
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# VCS
if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
    autoload -Uz vcs_info
    zstyle ':vcs_info:(git|svn):*' formats '%R' '%S' '%b'
    zstyle ':vcs_info:(git|svn):*' actionformats '%R' '%S' '%b|%a'
    zstyle ':vcs_info:*' formats '%R' '%S' '%s:%b'
    zstyle ':vcs_info:*' actionformats '%R' '%S' '%s:%b|%a'
    precmd_vcs_info () {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        repos=`print -nD "$vcs_info_msg_0_"`
        [[ -n "$repos" ]] && psvar[2]="$repos"
        [[ -n "$vcs_info_msg_1_" ]] && psvar[3]="$vcs_info_msg_1_"
        [[ -n "$vcs_info_msg_2_" ]] && psvar[1]="$vcs_info_msg_2_"
    }
    typeset -ga precmd_functions
    precmd_functions+=precmd_vcs_info
fi

# snatch stdout of existing process
# see http://subtech.g.hatena.ne.jp/cho45/20091118/1258554176
function snatch() {
    gdb -p $1 -batch -n -x \
        =(echo "p (int)open(\"/proc/$$/fd/1\", 1)
                p (int)dup2(\$1, 1)
                p (int)dup2(\$1, 2)")
}

# alias
alias sc='screen -h 4096'
alias wcat='wget -q -O -'

export MANPAGER='less -s'
export PAGER='v'
alias man='LANG=${LANG/en_US.UTF-8/en_US} env man'
alias diff='colordiff -u'
alias od='od -A x -t xCz'

cppwarning="-Wall -Wextra -Wcast-qual -Wwrite-strings -Wno-missing-field-initializers -Wnon-virtual-dtor -Weffc++ -Wold-style-cast -Woverloaded-virtual"
alias c++="env g++ -lstdc++ -std=c++98 -pedantic-errors $cppwarning"
alias c++now="env g++ -lstdc++ -std=c++98 -pedantic-errors"
alias g++="env g++ -lstdc++ -std=gnu++98 -pedantic $cppwarning"
alias g++now="env g++ -lstdc++ -std=gnu++98 -pedantic"

alias emacs-compile='emacs -batch -f batch-byte-compile'

# prompt
if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
    PROMPT="%(!.%F{red}.%F{green})%U%n@%6>>%m%>>%u%f:%1(j.%j.)%(!.#.>) "
    local dirs='[%F{yellow}%3(v|%32<..<%3v%<<|%60<..<%~%<<)%f]'
    local vcs='%3(v|[%26<><%F{yellow}%2v%f@%F{blue}%1v%f%<<]|)'
    RPROMPT="$dirs$vcs"
else
    # 0   to restore default color
    # 1   for brighter colors
    # 4   for underlined text
    # 5   for flashing text
    # 30  for black foreground
    # 31  for red foreground
    # 32  for green foreground
    # 33  for yellow (or brown) foreground
    # 34  for blue foreground
    # 35  for purple foreground
    # 36  for cyan foreground
    # 37  for white (or gray) foreground
    # 40  for black background
    # 41  for red background
    # 42  for green background
    # 43  for yellow (or brown) background
    # 44  for blue background
    # 45  for purple background
    # 46  for cyan background
    # 47  for white (or gray) background
    col1='0;4;32'
    col2='0;33'
    PROMPT="%{[${col1}m%}%n@%m%{[m%}:%1(j.%j.)%(!.#.>) "
    RPROMPT="[%{[${col2}m%}%~%{[m%}]"
fi
