# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-received

CONFIG += sailfishapp

SOURCES += src/harbour-received.cpp

OTHER_FILES += qml/harbour-received.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-received.changes.in \
    rpm/harbour-received.spec \
    rpm/harbour-received.yaml \
    translations/*.ts \
    harbour-received.desktop \
    qml/api.py \
    qml/components/AudioPlayer.qml \
    qml/components/js/utils/log.js \
    qml/components/js/Utils.js \
    qml/components/python/api.py \
    qml/components/js/Storage.js \
    todo.txt \
    qml/pages/Favorites.qml \
    qml/components/js/Favorites.js \
    qml/pages/Browse.qml \
    translations/harbour-received-sv.ts \
    qml/pages/Stations.qml \
    qml/pages/BrowseByCategory.qml \
    qml/components/MenuLabelSmal.qml \
    qml/components/SleepTimer.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-received-sv.ts

HEADERS +=

