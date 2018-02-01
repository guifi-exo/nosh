#!/bin/bash

commands=("man" "pwd" "ls" "whoami")
timestamp(){ date +'%Y-%m-%s %H:%M:%S'; }
log(){ echo -e "$(timestamp)\t$1\t$(whoami)\t$2" > /var/log/rbash.log; }
trycmd()
{
    # Provide an option to exit the shell
    if [[ "$ln" == "exit" ]] || [[ "$ln" == "q" ]]
    then
        exit

    # You can do exact string matching for some alias:
    elif [[ "$ln" == "help" ]]
    then
        echo "Type exit or q to quit."
        echo "Commands you can use:"
        echo "  help"
        echo "  echo"
        echo "${commands[@]}" | tr ' ' '\n' | awk '{print "  " $0}'

    # You can use custom regular expression matching:
    elif [[ "$ln" =~ ^echo\ .*$ ]]
    then
        ln="${ln:5}"
        echo "$ln" # Beware, these double quotes are important to prevent malicious injection

        # For example, optionally you can log this command
        log COMMAND "echo $ln"

    # Or you could even check an array of commands:
    else
        ok=false
        for cmd in "${commands[@]}"
        do
            if [[ "$cmd" == "$ln" ]]
            then
                ok=true
            fi
        done
        if $ok
        then
            $ln
        else
            log DENIED "$cmd"
        fi
    fi
}

# Optionally show a friendly welcome-message with instructions since it is a custom shell
echo "$(timestamp) Welcome, $(whoami). Type 'help' for information."

# Optionally log the login
log LOGIN "$@"

# Optionally log the logout
trap "trap=\"\";log LOGOUT;exit" EXIT

# Optionally check for '-c custom_command' arguments passed directly to shell
# Then you can also use ssh user@host custom_command, which will execute /root/rbash.sh
if [[ "$1" == "-c" ]]
then
    shift
    trycmd "$@"
else
    while echo -n "> " && read ln
    do
        trycmd "$ln"
    done
fi
