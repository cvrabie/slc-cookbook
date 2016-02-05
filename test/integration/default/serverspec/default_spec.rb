require 'spec_helper'

describe 'slc::default' do
	it 'is listening on default controll port' do
		expect(port(8701)).to be_listening
	end

	describe command('npm list -g --depth=0') do
		its(:stdout) { should match /strongloop@/ }
	end
end
