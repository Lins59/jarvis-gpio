#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file
# To avoid conflicts, name your function like this
# pg_XX_myfunction () { }
# pg for PluGin
# XX is a short code for your plugin, ex: ww for Weather Wunderground
# You can use translations provided in the language folders functions.sh
jv_pg_gpio_action () {
    key=-1
    for pin in "${!jv_pg_gpio_pin[@]}"
    do 
        if [ "$order" == *${jv_pg_gpio_pin[$pin]}* ]; then
            key=$pin
            break
        fi
    done
    if [ $key -gt 0 ]; then
        /usr/bin/touch "stop_$key"
        case $1 in
            on)
                gpio mode $key out && gpio write $key 1
                ;;
            off)
                gpio mode $key out && gpio write $key 0
                ;;
            blink)
                while true
                do
                    gpio mode $key out && gpio write $key 1
                    sleep(1)
                    gpio mode $key out && gpio write $key 1
                    sleep(1)
                    
                    if [ -e "stop_$key" ]; then
                        break
                        ;;
                    fi
                done
                ;;
        esac
        /bin/rm "stop_$key"
        return 1
    else
        return 0
    fi

}
