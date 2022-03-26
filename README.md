# Let's Learn Raku...

* with 0 Perl knowledge
* and by making a text adventure

My goal is that the commits completely document my journey --each stumble and Raku discovery-- with ample comments.

### Running the Code

```bash
raku text-adventure.raku
```

See `Makefile` for handy shortcuts:

Installing raku and running `text-adventure.raku` locally:
```bash
make install_raku # does not reinstall if raku is already present
make run
#   ... test out the game ...
#   exit
#   make changes to text-adventure.raku
make run
#   repeat...
```

Running `text-adventure.raku` in a container:
```bash
make podman_install # does not reinstall if podman is already present
make podman_run
#   ... test out the game ...
#   exit
#   make changes to text-adventure.raku
make podman_run
#   repeat...
```
