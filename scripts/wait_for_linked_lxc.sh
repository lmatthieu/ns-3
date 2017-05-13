
wait_for_container() {
	# any linked container that has to be working before anything happen
	LINK_CONTAINER=${DB_PORT}
	LINKED_CONTAINER_ADDR=$DB_PORT_5432_TCP_ADDR
	LINKED_CONTAINER_PORT=$DB_PORT_5432_TCP_PORT

	echo "waitig for other linked container"
	while ! exec 6<>/dev/tcp/${LINKED_CONTAINER_ADDR}/${LINKED_CONTAINER_PORT}; do
	    echo "$(date) - still trying to connect to container at ${LINK_CONTAINER}"
	    sleep 1
	done
}
