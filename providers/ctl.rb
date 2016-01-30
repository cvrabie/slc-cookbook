# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

action :deploy do  
  converge_by("Deploying #{new_resource.service}") do
    execute "slc deploy --service #{new_resource.service} #{@url} #{new_resource.tar}" do
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
    restart_cmd = "soft-restart"
    if "#{new_resource.force}" == true 
      stop_cmd = "restart"
    end
    execute "#{@slc} ctl #{restart_cmd} #{new_resource.service}" do
      action :run
    end
  end
end

def get_current_state(service_name)
  result = Mixlib::ShellOut.new("slc status").run_command
  if result.stdout.include? "Processes:"
    "STARTED"
  elsif result.stdout.include? "Not started"
    "STOPPED"
  else
    nil
  end      
end

def load_current_resource
  # @current_resource = Chef::Resource::SlcService.new(@new_resource.name)
  # @current_resource.state = get_current_state(@new_resource.name)
  user = new_resource.user
  pass = new_resource.password
  host = new_resource.host
  port = new_resource.port
  @auth = ''
  if !user.nil? 
    if !pass.nil? 
      @auth = "#{user}:#{pass}@"
    else
      @auth = "#{user}@"
    end
  end 
  @url = "http://#{@auth}#{new_resource.host}:#{new_resource.port}"
  env = ''
  if !user.nil? || !pass.nil? || host != '127.0.0.1' || port != 8701
    env = "STRONGLOOP_PM=#{url}"
  end

  @slc = 'slc'
  if env != ''
    @slc = "#{env} slc"
  end
end