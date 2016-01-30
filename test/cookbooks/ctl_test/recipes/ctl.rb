execute 'wget https://s3-eu-west-1.amazonaws.com/cvrabie/loopback-getting-started-master.tgz' do
	cwd '/tmp'
end

slc_ctl 'test-app' do
	action :deploy
	tar '/tmp/loopback-getting-started-master.tgz'
end