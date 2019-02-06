#!/opt/puppetlabs/puppet/bin/ruby

require 'open3'
require_relative "../../ruby_task_helper/files/task_helper.rb"

class AdJoin < TaskHelper
  def task(
    server:         nil,
    stdin_password: nil,
    options:        nil,
    **kwargs
  )

  # interact with the system
  if stdin_password
    stdout, stderr, status = Open3.capture3("echo -n #{stdin_password} | realm join --unattended #{server} #{options}")
  else
    stdout, stderr, status = Open3.capture3("realm join --unattended #{server} #{options}")
  end
  raise "Failed to join realm: #{stderr}" unless status.success?

  # provide output
  {
    stdout: stdout,
    stderr: stderr,
    status: status
  }
  end
end

if __FILE__ == $0
  AdJoin.run
end
