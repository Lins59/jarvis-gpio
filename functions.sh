#!/bin/bash
jv_pg_gpio_action () {
    key=-1
    order=${order:-$2}

    for pin in "${!jv_pg_gpio_pin[@]}"
    do
        device=${jv_pg_gpio_pin[pin]}
        regex="^.*${device}.*$"
        if [[ $order =~ $regex ]]; then
            key=$pin
            break
        fi
    done

    if [ $key -gt 0 ]
    then
        if [ -e "stop_$key" ]
        then
            /bin/rm "stop_$key"
        fi
        case $1 in
            on)
                /usr/bin/touch "stop_$key"
                gpio mode $key out && gpio write $key 1
                ;;
            off)
                /usr/bin/touch "stop_$key"
                gpio mode $key out && gpio write $key 0
                ;;
            blink)
                gpio mode $key out

                # Must use a detach thread to end this command
                parallel "while true; do gpio write $key 1 && sleep 2 && gpio write $key 0 && sleep 2; if [ -e \"stop_$key\" ]; then break; fi; done"
		;;
        esac
        return 0
    else
        return 1
    fi
}