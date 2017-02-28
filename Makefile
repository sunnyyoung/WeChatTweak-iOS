THEOS_DEVICE_IP = 192.168.2.7
THEOS_DEVICE_PORT = 22
ARCHS = armv7 arm64
TARGET = iphone:latest:7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeChatTweak
WeChatTweak_FRAMEWORKS = UIKit
WeChatTweak_FILES = $(wildcard Tweaks/*.m) $(wildcard Tweaks/*.xm)

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"

after-uninstall::
	install.exec "killall -9 WeChat"

after-clean::
	rm -rf ./.theos ./obj ./packages
