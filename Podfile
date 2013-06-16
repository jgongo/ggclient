# Golden Gekko assignment iOS client

# Reskit/Testing is not included in the :test target because doing so causes some
# nasty problems regarding duplicate symbols in libPods and libPods-test. This is the
# recommended configuration according to Blake Watters (creator of RestKit):
#   https://groups.google.com/forum/?fromgroups=#!topic/restkit/DrFGMwmJN-s

xcodeproj 'GGClient/GGClient.xcodeproj'
platform :ios, '6.0'
inhibit_all_warnings!

# Networking
pod 'RestKit/Core',    '0.20.2'
pod 'RestKit/Testing', '0.20.2'

# Infrastructure
pod 'Typhoon',         '1.2.0'

# Debugging / testing
pod 'CocoaLumberjack', '1.6.2'
pod 'NSLogger-CocoaLumberjack-connector', '1.3'

# UI
pod 'TSMessages',      '0.9.3'

target :test, :exclusive => true do
    link_with 'GGClientTests'
    pod 'Kiwi',           '2.0.6'
    pod 'RKKiwiMatchers', '0.20.0'
    pod 'OHHTTPStubs',    '1.1.1'
end
