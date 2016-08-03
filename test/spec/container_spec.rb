require "serverspec"
require "docker"

DOCKER_VERSION = '1.10.1'

describe 'sbt-builder image' do
  before(:all) do
    image = Docker::Image.get(ENV['IMAGE_TAG'])

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
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
end
