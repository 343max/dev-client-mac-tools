require 'json'

package = JSON.parse(File.read(File.join(__dir__, '..', 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'MacDevTools'
  s.version        = package['version']
  s.summary        = package['description']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.platform       = :ios, '13.0'
  s.swift_version  = '5.4'
  s.source         = { git: 'git@gitlab.com:metrofs/platform/frontend/mfs-app.git' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'
  s.dependency 'expo-dev-menu-interface'
  s.dependency 'expo-dev-menu'

  # Swift/Objective-C compatibility
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }
  
  s.source_files = '**/*.{h,m,swift}'
end
