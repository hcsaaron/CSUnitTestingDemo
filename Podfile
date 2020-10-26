
target 'CSUnitTestingDemo' do

    target 'CSUnitTestingDemoTests' do
      inherit! :search_paths
      pod 'OCMock'
    end

    target 'CSUnitTestingDemoUITests' do
      inherit! :search_paths
      pod 'OCMock'
    end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end