#!/opt/puppetlabs/puppet/bin/ruby

require 'open3'
require_relative "../../ruby_task_helper/files/task_helper.rb"

class AdLeave < TaskHelper
  def task(
    domain:  nil,
    options: nil,
    **kwargs
  )

  # interact with the system
  stdout, stderr, status = Open3.capture3("realm leave --unattended #{domain} #{options}")
  raise "Failed: #{stderr}" unless status.success?

  # provide output
  {
    stdout: stdout,
    stderr: stderr,
    status: status
  }
  end
end

if __FILE__ == $0
  AdLeave.run
end
