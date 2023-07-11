require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

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
  s.source         = { git: 'git@github.com:343max/dev-client-mac-tools.git' }
  s.static_framework = true
  s.header_dir     = 'MacDevTools'

  s.dependency 'ExpoModulesCore'
  s.dependency 'expo-dev-menu-interface'
  s.dependency 'expo-dev-menu'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule',
  }

  s.source_files = 'ios/**/*.{h,m,swift}'
  s.private_header_files = ['ios/**/Swift.h']
end
