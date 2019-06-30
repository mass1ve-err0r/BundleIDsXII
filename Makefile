ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = BundleIDsXII

BundleIDsXII_FILES = main.m BundleIDsAppDelegate.m BundleIDsRootViewController.m
BundleIDsXII_FRAMEWORKS = UIKit CoreGraphics
BundleIDsXII_LIBRARIES = applist
BundleIDsXII_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"BundleIDsXII\"" || true
