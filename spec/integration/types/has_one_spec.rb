require 'spec_helper'

describe CustomFields::Types::HasOne do

  before(:each) do
    create_client
    create_project

    @task = @project.tasks.build :title => 'Managing team'
    @another_task = @project.tasks.build :title => 'Cleaning'
  end

  it 'attaches a location to a task' do
    @task.location = @location_1
    @task.save && @task = Mongoid.reload_document(@task)


    @task.location.should_not be_nil
    @task.location.name.should == 'office'
    @task.location.country.should == 'US'
  end

  # ___ helpers ___

  def create_client
    @client = Client.new(:name => 'NoCoffee')
    @client.location_custom_fields.build :label => 'Country', :_alias => 'country', :kind => 'String'

    @client.save!

    @location_1 = @client.locations.build :name => 'office', :country => 'US'
    @location_2 = @client.locations.build :name => 'dev lab', :country => 'FR'

    @client.save!
  end

  def create_project
    @project = Project.new(:name => 'Locomotive')
    @project.task_custom_fields.build :label => 'Task Location', :_alias => 'location', :kind => 'has_one', :target => @client.location_klass.to_s
    @project.save!
  end

end