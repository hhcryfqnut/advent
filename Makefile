.PHONY: run
run:
	which raku > /dev/null || brew install rakudo-star
	raku text-adventure.raku

.PHONY: install_raku
install_raku:
	which raku > /dev/null || brew install rakudo-star
	which raku > /dev/null || sudo apt-get install rakudo

.PHONY: podman_run
podman_run:
	-podman machine start
	podman build -t text-adventure .
	podman run -it text-adventure /bin/bash -c 'raku text-adventure.raku'

.PHONY: podman_install
podman_install:
	which podman > /dev/null || brew install podman
	which podman > /dev/null || sudo apt-get -y install podman
	-podman machine init
	-podman machine start

.PHONY: podman_start
podman_start:
	podman machine start

.PHONY: podman_stop
podman_stop:
	podman machine stop

.PHONY: podman_cleanup
podman_cleanup:
	podman container list --all
	podman kill -a
	podman rmi -fa
	podman container list --all
