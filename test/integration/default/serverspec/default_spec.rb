require 'spec_helper'

describe 'slc::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'is listening on default controll port' do
    expect(port(8701)).to be_listening
  end

  # it "has a running service of sl-pm" do
  #   expect(service("sl-pm")).to be_running
  # end
end
