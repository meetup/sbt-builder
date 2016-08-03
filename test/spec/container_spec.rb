require "serverspec"
require "docker"

DOCKER_VERSION = '1.10.1'

describe 'sbt-builder image' do
  before(:all) do
    set :os, family: :debian
    set :backend, :docker

    set :docker_image, ENV['IMAGE_TAG']
    # Have to override the Cmd for some reason....
    set :docker_container_create_options, {'Cmd' => ['/bin/sh']}
  end

  it 'has java 8 installed' do
    expect(command('java -version').stderr).to match /1.8/
  end

  it 'has git installed' do
    expect(command('git --version').stdout).to match /^git version/
  end

  it 'has docker installed' do
    expect(command('docker --version').stdout).to match /^Docker version #{DOCKER_VERSION}/
  end

  it 'has make installed' do
    expect(command('make --version').stdout).to match /^GNU Make/
  end
end
