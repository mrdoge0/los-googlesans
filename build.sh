#!/usr/bin/env bash
# los-googlesans builder

# Check if there's a "work" folder already existing
if [ -d "./work" ]; then
  echo "Please run ./clean.sh and try again."
  exit 1
fi

# Clone Magisk Module Template Extended to "work"
echo "Cloning MMT Extended to './work'..."
git clone https://github.com/Zackptg5/MMT-Extended.git -b master ./work
GIT_1_EXIT=$?
if [ $GIT_1_EXIT -ne 0 ]; then
  exit $GIT_1_EXIT
fi

# Clean the work from template shit
echo "Cleaning the work dir..."
rm -rvf "./work/.git" || exit 1
rm -rvf "./work/system" || exit 1
rm -rvf "./work/zygisk" || exit 1
rm -vf "./work/.gitattributes" || exit 1
rm -vf "./work/.gitignore" || exit 1
rm -vf "./work/README.md" || exit 1
rm -vf "./work/module.prop" || exit 1
rm -vf "./work/update.json" || exit 1
rm -vf "./work/install.zip" || exit 1
rm -vf "./work/changelog.md" || exit 1
mv -v "./work/LICENSE" "./work/LICENSE_MMTEX" || exit 1

# Copy over system dump
echo "Copying fonts dump..."
cp -rv "./system_dump" "./work/system"
CP_1_EXIT=$?
if [ $CP_1_EXIT -ne 0 ]; then
  exit $CP_1_EXIT
fi
mkdir -p "./work/system/product/overlay" || exit 1

# Build the overlay
echo "Entering directory 'FontGoogleSansOverlay'..."; cd "./FontGoogleSansOverlay"
echo "Building overlay resources..."
aapt2 compile -o compiled_res.zip res/*/*
AAPT2_1_EXIT=$?
if [ $AAPT2_1_EXIT -ne 0 ]; then
  exit $AAPT2_1_EXIT
fi
echo "Linking overlay package..."
aapt2 link -o "../work/system/product/overlay/FontGoogleSansOverlay.apk" --manifest AndroidManifest.xml -R compiled_res.zip --auto-add-overlay -I "$HOME/Android/platforms/android-35/android.jar" 
AAPT2_2_EXIT=$?
if [ $AAPT2_2_EXIT -ne 0 ]; then
  exit $AAPT2_2_EXIT
fi
echo "Leaving directory 'FontGoogleSansOverlay'..."; cd .. || exit 1

# Generate out if not generated
if [ ! -d "./out" ]; then
  echo "Creating folder 'out'"
  mkdir "./out" || exit 1
fi

# Package!
echo "Copying 'module.prop'..."
cp -v "./module.prop" "./work/module.prop" || exit 1
echo "Entering directory 'work'..."; cd "./work" || exit 1
echo "Packaging..."
zip -r0 "../out/$(date -u +"%Y%m%d_%H%M").zip" *
ZIP_1_EXIT=$?
if [ $ZIP_1_EXIT -ne 0 ]; then
  exit $ZIP_1_EXIT
fi
echo "Leaving directory 'work'..."; cd .. || exit 1

# Clean
echo "Running the clean.sh script..."
chmod +x ./clean.sh || echo "Build successful, but couldn't run clean script."; exit 0
./clean.sh
CLEANSH_1_EXIT=$?
if [ $CLEANSH_1_EXIT -ne 0 ]; then
  echo "Build successful, but couldn't run clean script."
  exit $CLEANSH_1_EXIT
fi
echo "SUCCESS!!!"
exit 0
