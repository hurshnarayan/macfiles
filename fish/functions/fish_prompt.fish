function fish_prompt
    set -l last_status $status

    # Colors
    set -l normal (set_color normal)
    set -l blue (set_color blue)
    set -l white (set_color white)
    set -l red (set_color red)
    set -l green (set_color green)
    set -l cyan (set_color cyan)
    set -l magenta (set_color magenta)
    set -l yellow (set_color yellow)

    # Username and hostname dynamic takes the actual result form whoami to set hostname
    # set -l user_host $blue"["$white(whoami)$red"@"$white(prompt_hostname)$blue"] "$normal
    # Username and hostname (hardcoded) sets "harsh" as hostname hardcoded as it's shorter
    set -l user_host $blue"["$white"harsh"$red"@"$white(prompt_hostname)$blue"] "$normal

    # Status-based arrow
    set -l arrow
    if test $last_status -eq 0
        set arrow (set_color --bold green)"➜ "$normal
    else
        set arrow (set_color --bold red)"➜ "$normal
    end

    # Current directory (basename only)
    set -l cwd $cyan(basename (prompt_pwd))$normal

    # Git information
    set -l git_info ""
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
        set -l branch_icon (printf '\ue725')

        set -l git_status ""

        # Check for untracked files (!)
        if git status --porcelain 2>/dev/null | grep '^??' >/dev/null
            set git_status $git_status"!"
        end

        # Check for unstaged changes (U)
        if not git diff --quiet 2>/dev/null
            set git_status $git_status"U"
        end

        # Check for staged changes (S)
        if not git diff --cached --quiet 2>/dev/null
            set git_status $git_status"S"
        end

        # Build git info string with branch icon
        if test -n "$branch"
            set git_info " "$blue"("$red$git_status$yellow$magenta" "$branch_icon" "$branch$blue")"$normal
        end
    end

    # Build final prompt
    echo -n -s $user_host $arrow $cwd $git_info " "
end
