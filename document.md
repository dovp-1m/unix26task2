This document describes the process of downloading, compiling, and deploying BusyBox on a fresh Debian 13 VM.
The build toolchain (gcc and make) were installed via apt, this is the only use of a package manager in the entire project, as I understood the build tools themselves could be downloaded with a package manager and only BusyBox installation had the constraint of not being to use any package managers.

The working dir for all scripts and source files is /opt/task2/. The git repo contains only the scripts, this document and a .gitignore.

What compile.sh does:
compile.sh downloads BusyBox source code from an official source and configures it for a statically linked x86_64 build and installs the binary to _install/ directory.
BusyBox failed to build on Debian 13 because of the removed kernel headers of the traffic control applet. Fixed by disabling CONFIG_TC in .config before compiling.

What deploy.sh does:
deploy.sh copies the compiled BusyBox binary to /opt/task2/busybox-static and then creates a shell script in /bin/ for every applet that BusyBox support with the bb- prefix.
Symlinks named bb-<cmd> didn't work because BusyBox dispatches applets by matching in the exact way it was called. bb-ls doesn't match the internal applet ls. Fixed by using wrapper scripts that call busybox-static <applet> "$@".

What test.sh does:
Lists all deployed bb-* wrappers, runs sample commands and prints their exit codes, no issues here.

What hhttptest.sh does:
Fetches http://localhost:80/ using bb-wget and prints the response, no issues here either.