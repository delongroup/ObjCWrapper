Pod::Spec.new do |spec|
  spec.name         = 'ObjCWrapper'
  spec.version      = '0.1.1'
  spec.license      =  { :type => 'BSD' }
  spec.homepage     = 'ObjCWrapper'
  spec.authors      = { 'delon chen' => 'delonchen@126.com'}
  spec.summary      = 'ObjC Runtime Wrapper Class.'
  spec.source       = { :git => '~/Work2014/ObjCWrapper' }
  spec.source_files = 'ObjCWrapper/'
  spec.requires_arc = false
  spec.ios.deployment_target = '6.0'
end
