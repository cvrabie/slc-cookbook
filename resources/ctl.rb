actions :deploy, :remove, :start, :stop, :restart
default_action :start

attribute :service, :kind_of => String, :name_attribute => true
attribute :pm_host, :kind_of => String, :default => '127.0.0.1'
attribute :pm_port, :kind_of => Integer, :default => 8701
attribute :pm_user, :kind_of => [String, NilClass], :default => nil
attribute :pm_password, :kind_of => [String, NilClass], :default => nil
attribute :tar, :kind_of => [String, NilClass], :default => nil
attribute :git, :kind_of => [String, NilClass], :default => nil
attribute :branch, :kind_of => String, :default => 'deploy'
attribute :force, :kind_of => [TrueClass,FalseClass], :default => FalseClass

attr_accessor :state
