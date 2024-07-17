#!/bin/sh

#  ci_post_clone.sh
#  Runner
#
#  Created by Cameron Matthew on 2024-07-16.
#  


# The default execution directory of this script is the ci_scripts directory.
#cd $CI_WORKSPACE # change working directory to the root of your cloned repo.
cd ..
cd .. # Should be in the project root directory

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"


# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods


cd ios
pod deintegrate
# Install CocoaPods dependencies.
pod update # run `pod install` in the `ios` directory.

flutter pub get

flutter build ios --release
exit 0
