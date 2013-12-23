# ScTmux

### Problem
When I run tmux on a remote host I lose access to my ssh-agent if I
detach and attach again. Existing windows have old ssh-agent environment
values. I also like to have my tmux windows named by the host I'm
connecting to. This gem resolves those two problems.

### Solution
This script started as a set of bash scripts which made it easier to
refresh ssh-agent info on existing tmux windows. These are now
implemented as a gem which installs an 'sc' binary.

sc has a number of features:

- Collect ssh-agent vars to a file for use in other operations
- make current ssh-agent vars available to eval in a new shell
- Set the title on new tmux windows when you ssh to a host (requires you
  use 'sc' instead of 'ssh')
- create new tmux sessions or attach to existing ones, runs sc -g
  automatically when re-attaching

## Installation

Installation is simple:

    $ gem install sc_tmux

## Usage
sc is run both with arguments to interact with tmux & your shell as well
as run as an ssh replacement. 

### SSH Replacement
When run as an ssh replacement it simply
pulls the current ssh-agent vars into the shell (`sc -f`), outputs the
result of `which ssh` to show which ssh binary is being run and then
opens a new tmux window named after the hostname you specify to ssh to
the host. 

Example:

    $ sc somehost

or

    $ sc username@somehost

### Options

`-g` Grab SSH

This stores the current ssh-agent vars to a file for later use. This
happens automatically if you use the `--attach` option. You may also run
it just before re-attaching to your tmux session. 

For example, I use tmuxinator, so I have the following alias:
`alias mux='sc -g && mux'`

`-f` Fix SSH

This will output the current values stored by the `-g` option.
Unfortunately it's really only useful when used inside an alias because
you need to eval the contents of the file - thus I usually add the
following alias:

`alias fixssh='eval $(sc -f)'`

Then when you want to 'fix' ssh inside a pre-existing tmux window you
just type `fixssh`.

`-s` Setup

This is just a convenience method that outputs the fix alias above so
you can easily add it to your setup.

`-a` Attach

This will first store the current ssh-agent vars and then will attempt
to attach to an existing tmux session. This assumes a tmux session
exists with the same name as is passed by the `-n` parameter ('prod' by
default)

`-c` Create

This will create a new tmux session using the configured session name if
one doesn't already exist.  

`-n` Socket Name

This will use the specified socket name when starting tmux - this allows
you to have multiple tmux sessions attached to different sockets.

`--agent_file` Agent file

This is the name of the file used to store the ssh-agent var values. By
default this filename is based on your hostname (to be compatible w/
shared home directories) and is listed in the help output. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add your tests, then add your new awesomeness
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
