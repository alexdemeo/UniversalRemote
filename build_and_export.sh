#!/bin/sh

#  build_and_export.sh
#  MyRemote
#
#  Created by Alex DeMeo on 7/25/20.
#  Copyright © 2020 Alex DeMeo. All rights reserved.

ARCHIVE_PATH="build/MyRemote.xcarchive"
EXPORT_PATH="/Applications"

mkdir -p "build"
#rm -rf "/Applications/MyRemote.app"

#xcodebuild clean build -project MyRemote.xcodeproj
xcodebuild -scheme MyRemote -archivePath $ARCHIVE_PATH -project MyRemote.xcodeproj archive
xcodebuild -exportArchive -archivePath $ARCHIVE_PATH -exportPath $EXPORT_PATH -exportOptionsPlist "exportOptions.plist"

echo "Done"
