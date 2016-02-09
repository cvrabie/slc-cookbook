# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

action :deploy do  
  service = new_resource.service
  tar = new_resource.tar
  git = new_resource.git
  converge_by("Deploying #{service} to SLC PM") do
    if tar.nil? && git.nil?
      raise "No tar or git repo specified for SLC service #{service}"
    end
    if !tar.nil? && !git.nil? 
      raise "You can't specify both a tar and a git repo for SLC service #{service}"
    end
    source = git.nil? ? tar : git
    branch = (git.nil? || new_resource.branch.nil?) ? '' : "--branch #{new_resource.branch}"
    execute "slc deploy #{branch} --service #{service} #{@url} #{new_resource.tar}" do
      action :run
      retries 3
    end
  end
end

action :remove do  
  converge_by("Disabling #{new_resource.service}") do
    execute "#{@slc} ctl remove #{new_resource.service}" do
      action :run
    end
  end
end

action :start do  
  converge_by("Starting #{new_resource.service}") do
    execute "#{@slc} ctl start #{new_resource.service}" do
      action :run
    end
  end
end

action :stop do
  converge_by("Stopping #{new_resource.service}") do
    stop_cmd = "soft-stop"
    if "#{new_resource.force}" == true 
      stop_cmd = "stop"
    end
    execute "#{@slc} ctl #{stop_cmd} #{new_resource.service}" do
      action :run
    end
  end
end

action :restart do
  converge_by("Restart #{new_resource.service}") do
    state = get_current_state(new_resource.service)
    restart_cmd = ''
    if(state == 'STARTED')
      if "#{new_resource.force}" == true 
        restart_cmd = 'restart'
      else
        restart_cmd = 'soft-restart'
      end
    else
      restart_cmd = 'start'
    end
    execute "#{@slc} ctl #{restart_cmd} #{new_resource.service}" 
  end
end

action :status do
  converge_by("Getting status of #{new_resource.service}") do
    state = get_current_state(new_resource.service)
    Chef::Log.info("**** #{new_resource.service} is #{state}")
  end
end

def get_current_state(service_name)
  result = Mixlib::ShellOut.new("slc status #{service_name}").run_command
  if result.stdout.include? "Processes:"
    "STARTED"
  elsif result.stdout.include? "Not started"
    "STOPPED"
  else
    nil
  end      
end

def load_current_resource
  pm_user = new_resource.pm_user
  pm_pass = new_resource.pm_password
  pm_host = new_resource.pm_host
  pm_port = new_resource.pm_port

  @auth = ''
  
  if !pm_user.nil? 
    if !pm_pass.nil? 
      @auth = "#{pm_user}:#{pm_pass}@"
    else
      @auth = "#{pm_user}@"
    end
  end 
  
  @url = "http://#{@auth}#{new_resource.pm_host}:#{new_resource.pm_port}"
  
  env = ''
  if !pm_user.nil? || !pm_pass.nil? || pm_host != '127.0.0.1' || pm_port != 8701
    env = "STRONGLOOP_PM=#{@url}"
  end

  node_bin_folder = ''
  if !ENV['NODE_HOME'].nil? && !ENV['NODE_HOME'].empty? 
    node_bin_folder = "#{ENV['NODE_HOME']}/bin/"
  end

  @slc = '#{node_bin_folder}slc'
  if env != ''
    @slc = "#{env} #{node_bin_folder}slc"
  end
end