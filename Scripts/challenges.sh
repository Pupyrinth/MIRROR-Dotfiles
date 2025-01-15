#!/usr/bin/env bash

# Some things taken from here https://github.com/nmdra/Dotfiles/blob/main/scripts/birthday.sh

jsonFile="/home/luna/NixOS/scripts/challengesData.json"


d="$((s / 60 / 60 / 24)) days"
h="$((s / 60 / 60 % 24)) hours"
m="$((s / 60 % 60)) minutes"

# Remove plural if < 2.
((${d/ *} == 1)) && d=${d/s}
((${h/ *} == 1)) && h=${h/s}
((${m/ *} == 1)) && m=${m/s}

# Hide empty fields.
((${d/ *} == 0)) && unset d
((${h/ *} == 0)) && unset h
((${m/ *} == 0)) && unset m

uptime=${d:+$d, }${h:+$h, }$m
uptime=${uptime%', '}
uptime=${uptime:-$s seconds}

function getInstallTime {
    if [ -z "$1" ]
    then
        installTime=$(stat -c %W /)
    else
        installTime="$1"
    fi

    echo $(echo $installTime | awk '{print strftime("%d/%m/%Y, %H:%M:%S", $1)}')
}

function getPercentageDone {
    # Define the function for calculating percentage completion
    # Ty cerealkillerjohn (The Linux Cast Discord server)
    target_date="$2"
    start_date="$1"  # Allow the start date to be passed as an argument

    current_date=$(date +"%Y-%m-%d %H:%M:%S")

    target_timestamp=$(date -d "$target_date" +"%s")
    start_timestamp=$(date -d "$start_date" +"%s")
    current_timestamp=$(date -d "$current_date" +"%s")

    if [ "$current_timestamp" -gt "$target_timestamp" ]; then
        echo -e "\033[38;5;82m100% Complete\033[0m"  # Green
    else
        total_time=$((target_timestamp - start_timestamp))
        elapsed_time=$((current_timestamp - start_timestamp))

        percentage=$(awk "BEGIN {printf \"%.2f\", $elapsed_time * 100 / $total_time}")

        # Remove decimal part if it's .00
        percentage=$(echo "$percentage" | sed 's/\.00$//')

        if [ $(awk "BEGIN {print ($percentage <= 33.49) ? 1 : 0}") -eq 1 ]; then
            echo -e "\033[38;5;196m$percentage% Complete\033[0m"  # Red
        elif [ $(awk "BEGIN {print ($percentage >= 34.50 && $percentage <= 66.49) ? 1 : 0}") -eq 1 ]; then
            echo -e "\033[38;5;208m$percentage% Complete\033[0m"  # Orange
        elif [ $(awk "BEGIN {print ($percentage >= 67.50 && $percentage <= 99.99) ? 1 : 0}") -eq 1 ]; then
            echo -e "\033[38;5;118m$percentage% Complete\033[0m"  # Chartreuse Green
        else
            echo -e "\033[38;5;82m$percentage% Complete\033[0m"   # Green
        fi
    fi
}

function getProgressDone {
    # All the Timing information
    let Minute=60
    let Hour=3600
    let Day=86400
    let Week=604800

    # Year_days=365.25 days # 4 years (1461 days cause leap year) Divided by 4
    # Month_days=30.4375 days # Year Divided by 12
    let Month=2629800
    let Year=31557600

    # Calculation of everything needed
    let current=$(date +%s)

    #let birth_install=$(stat -c %W /) # Comment out if using the custom Epoch
    #let birth_install=1722801652 # Custom Epoch for Reinstalls
    birth_install=$(date -d "$1" +"%s")

    let challenge_complete=(birth_install + Month * 2)
    let diff_left=(challenge_complete - current)
    let diff_done=(current - birth_install)

    let Years_done=(diff_done / Year)
    let Months_done=(diff_done % Year / Month)
    let Weeks_done=(diff_done % Month / Week)
    let Days_done=(diff_done % Week / Day)
    let Hours_done=(diff_done % Day / Hour)
    let Minutes_done=(diff_done % Hour / Minute)
    let Seconds_done=(diff_done % Minute)

    let Years_left=(diff_left / Year)
    let Months_left=(diff_left % Year / Month)
    let Weeks_left=(diff_left % Month / Week)
    let Days_left=(diff_left % Week / Day)
    let Hours_left=(diff_left % Day / Hour)
    let Minutes_left=(diff_left % Hour / Minute)
    let Seconds_left=(diff_left % Minute)


    if [ $Years_done -gt 0 ]
    then
        finalString="$Years_done""y "
    fi

    if [ $Months_done -gt 0 ]
    then
        finalString+="$Months_done""m "
    fi

    if [ $Weeks_done -gt 0 ]
    then
        finalString+="$Weeks_done""w "
    fi

    if [ $Days_done -gt 0 ]
    then
        finalString+="$Days_done""d "
    fi

    if [ $Hours_done -gt 0 ]
    then
        finalString+="$Hours_done""h "
    fi

    if [ $Minutes_done -gt 0 ]
    then
        finalString+="$Minutes_done""m "
    fi

    if [ $Seconds_done -gt 0 ]
    then
        finalString+="$Seconds_done""s"
    fi

    echo "$finalString"
}




## DEFINE COLORS
bold='[1m'
red='[31m'
green='[32m'
yellow='[33m'
blue='[34m'
magenta='[35m'
cyan='[36m'
white='[37m'
reset='[0m'

## USER VARIABLES -- YOU CAN CHANGE THESE
lc="${reset}${magenta}"  # labels
hn="${reset}${bold}${blue}"     # hostname
ic="${reset}${green}"           # info
c1="${reset}${white}"           # second color
c2="${reset}${yellow}"          # third color


#echo
#getInstallTime $(date -d "$(jq -r '. | to_entries[] | select(.value.current).value.startDate' $jsonFile)" +"%s")
#echo

#echo $(jq -r '. | to_entries[] | select(.value.current).value.startDate' $jsonFile)
#echo


#$(jq -r '. | to_entries[] | select(.value.current).value.startDate' $jsonFile)
#echo

cat <<EOF
${yellow} ${blue} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${reset}Challenges ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${red} ${green} ${red} ${cyan} ${reset}
EOF

# THIS NEEDS TO BE LAST

I=0
while [ ! $I -eq $(jq '.challenges | length' $jsonFile) ];
do
    title=$(jq -r .challenges[$I].title $jsonFile)
    startDate=$(jq -r .challenges[$I].startDate $jsonFile)
    endDate=$(jq -r .challenges[$I].endDate $jsonFile)
    lasted=$(jq -r .challenges[$I].lasted $jsonFile)
    procentDone=$(jq -r .challenges[$I].procentDone $jsonFile)
    reinstalls=$(jq -r .challenges[$I].reinstalls $jsonFile)
    current=$(jq -r .challenges[$I].current $jsonFile)

    cat <<EOF
$(if $current; then echo $yellow$bold"$title"$reset; else echo $green$bold"$title"$reset; fi)
    ${cyan}${reset} ${startDate}
EOF

    if [ ! -z "$endDate" ] && [ -z "$procentDone" ]
    then
        cat <<EOF
    ${cyan}${reset} ${endDate} | ${cyan}󱔢${reset} $(getPercentageDone "$startDate" "$endDate")
EOF
    fi

    if [ ! -z "$procentDone" ]
    then
        cat <<EOF
    ${cyan}${reset} ${endDate} | ${cyan}󱔢${reset} ${red}$procentDone
EOF
    fi

    if [ ! -z "$lasted" ]
    then
        cat <<EOF
    ${cyan}󱫑${reset} ${lasted}
EOF
    fi

    if [[ "$title" == *"NixOS"* ]] && $current
    then
        generations=`readlink /nix/var/nix/profiles/system | cut -d- -f2`

        if [ "$generations" -ge "1" ]
        then
            generations+=" Generations"
        else
            generations+=" Generation"
        fi

        cat <<EOF
    ${cyan}󰑓${reset} ${generations}
EOF
    fi

    if [ "$reinstalls" -gt "0"  ]
    then
        cat <<EOF
    ${cyan}${reset} ${reinstalls}
EOF
    fi

    if $current
    then
        cat <<EOF
    ${cyan}󰄨${reset} $(getProgressDone "$startDate")
EOF
    fi

    ((I++))
done

cat <<EOF
${yellow} ${blue} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${green} ${magenta} ${cyan} ${red} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${red} ${green} ${red} ${cyan} ${red} ${green} ${reset}
EOF
