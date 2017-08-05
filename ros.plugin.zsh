function ros_info() {
    if [ -n "$ROS_MASTER_URI" ] \
        && [ "$ROS_MASTER_URI" != "http://$ROS_IP:11311" ] \
        && [ "$ROS_MASTER_URI" != "http://localhost:11311" ]; then
        echo "%K{red} $ROS_MASTER_URI %k"
    fi
}
function rosmasteruri() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 [master_ip] [interface]";
        return 2
    fi

    unset ROS_HOSTNAME;
    export ROS_MASTER_URI=http://"$1":11311;
    export ROS_IP=`getip $2`

    echo unset ROS_HOSTNAME;
    echo ROS_MASTER_URI=$ROS_MASTER_URI
    echo ROS_IP=$ROS_IP
}
compdef "_arguments '2:Network Interface:_net_interfaces'" rosmasteruri

function getip() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 [interface]";
        return 2
    fi

    if [[ "$OSTYPE" =~ ^darwin ]]; then
        echo `ipconfig getifaddr "$1"`
    else
        echo `ifconfig "$1" | awk '/inet/ { print $2 } ' | sed -e s/addr://`
    fi
}
compdef "_arguments '1:Network Interface:_net_interfaces'" getip

# indicator for current ros master
if [ -n "$RPS1" ]; then
    # decoupling workaround
    RPROMPT=$RPS1
fi
if [[ ! $RPROMPT =~ '$(ros_info)' ]]; then
    RPROMPT=$RPROMPT'$(ros_info)'
fi