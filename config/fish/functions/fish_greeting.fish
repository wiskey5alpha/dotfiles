# This is run every time there is a new run of the shell

function fish_greeting -d "Greeting message on shell session start up"

    echo ""
    echo -en "  _______\n"
    echo -en "  |     |    " (welcome_message) "\n"
    echo -en "  |_____|    " (show_date_info) "\n"
    echo -en "  |_____|    \n"
    echo -en "  |     |    This system:\n"
    echo -en "  |_____|    " (show_os_info) "\n"
    echo -en "  |_____|   " (show_cpu_info) "\n"
    echo -en "  |     |   " (show_mem_info) "\n"
    echo -en "  |_____|   " (show_net_info) "\n"
    echo ""
    set_color grey
    set_color normal
end


function welcome_message -d "Say welcome to user"

    echo -en "Where to today? "
    set_color FFF  # white
    echo -en (whoami) "!"
    set_color normal
end


function show_date_info -d "Prints information about date"

    set --local up_time (uptime | cut -d "," -f1 | cut -d "p" -f2 | sed 's/^ *//g')

    set --local time (echo $up_time | cut -d " " -f2)
    set --local formatted_uptime $time

    switch $time
    case "days" "day"
        set formatted_uptime "$up_time"
    case "min"
        set formatted_uptime $up_time"utes"
    case '*'
        set formatted_uptime "$formatted_uptime hours"
    end

    echo -en "Today is "
    set_color cyan
    echo -en (date +%Y.%m.%d)
    set_color normal
    echo -en ", we are up and running for "
    set_color cyan
    echo -en "$formatted_uptime"
    set_color normal
    echo -en "."
end


function show_os_info -d "Prints operating system info"

    set_color yellow
    echo -en "\tOS: "
    set_color 0F0  # green
    echo -en (uname -sm)
    set_color normal
end


function show_cpu_info -d "Prints iformation about cpu"

    set --local os_type (uname -s)
    set --local cpu_info ""
    set --local procs_n (grep -c "^processor" /proc/cpuinfo)
    set --local cores_n (grep "cpu cores" /proc/cpuinfo | head -1 | cut -d ":"  -f2 | tr -d " ")
    set --local cpu_type (grep "model name" /proc/cpuinfo | head -1 | cut -d ":" -f2)
    set cpu_info "$procs_n processors, $cores_n cores, $cpu_type"

    set_color yellow
    echo -en "\tCPU: "
    set_color 0F0  # green
    echo -en $cpu_info
    set_color normal
end


function show_mem_info -d "Prints memory information"

    set --local os_type (uname -s)
    set --local total_memory ""
    set total_memory (free -h | grep "Mem" | cut -d " " -f 11)

    set_color yellow
    echo -en "\tMemory: "
    set_color 0F0  # green
    echo -en $total_memory
    set_color normal
end


function show_net_info -d "Prints information about network"

    set --local os_type (uname -s)
    set --local ip ""
    set --local gw ""
    set ip (ip address show | grep -E "inet .* brd .* dynamic" | cut -d " " -f6)
    set gw (ip route | grep default | cut -d " " -f3)

    set_color yellow
    echo -en "\tNet: "
    set_color 0F0  # green
    echo -en "Ip address $ip, default gateway $gw"
    set_color normal
end
