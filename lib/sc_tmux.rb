require "sc_tmux/version"

module ScTmux
  class Sc
    include Methadone::Main
    include Methadone::CLILogging
    include Methadone::SH
    version(ScTmux::VERSION)

    main do |host|
      if options[:grab]
        grab
      elsif options[:fix]
        fix
      elsif options[:create]
        create
      elsif options[:attach]
        attach
      elsif options[:setup]
        setup
      elsif host
        ssh(host)
      else
        help_now!("We expect a HOST if no options are passed")
      end

    end

    description "Reattach tmux windows to ssh-agent"
    # Defaults
    options[:agent_file] = "#{ENV['HOME']}/.sc_agent_info-#{%x[hostname -s].chomp}"
    options[:name] = "prod"

    arg :host, :optional, "Hostname for ssh connections"
    on("-g", "--grab", "Grab current SSH Env vars")
    on("-c", "--create", "Create new tmux session")
    on("-a", "--attach", "Attach to existing tmux session")
    on("-f", "--fix", "Output vars suitable for eval to fixup current shell")
    on("-s", "--setup", "Show pasties for final setup")
    on("--agent_file FILENAME", "Alternate file to store agent file")
    on("-n NAME", "--name", "Socket name to use for tmux")

    def self.setup
      puts "Add the following alias to wherever you keep aliases:"
      puts "alias fixssh='eval $(sc -f)'"
    end

    def self.grab
      File.unlink(options[:agent_file]) if File.exist?(options[:agent_file])
      f = File.new(options[:agent_file], "w")

      %w(SSH_CLIENT SSH_TTY SSH_AUTH_SOCK SSH_CONNECTION).each do |var|
        f.write("#{var}=\"#{ENV[var]}\"\n")
      end
      f.close
    end

    def self.fix
      puts File.read(options[:agent_file])
    end

    def self.ssh(host)
      which_ssh = `which ssh`.chomp
      display_host = /(.+@)?(([0-9]+\.){3}[0-9]+|([^.]+))/.match(host)[2]
      sh("tmux new-window -n #{display_host} \"echo 'Using: #{which_ssh}' ; . #{options[:agent_file]} ; ssh -A #{host}\"")
    end

    def self.create
      grab
      sh("tmux -L #{options[:name]}")
    end

    def self.attach
      grab
      sh("tmux -L #{options[:name]} attach")
    end

    go!
  end
end
