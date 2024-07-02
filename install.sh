#!/bin/bash
# Install and configures battery-level-notification.
pkgname=battery-level-notification
install -Dm644 LICENSE /usr/share/licenses/${pkgname}/LICENSE
install -Dm755 src/${pkgname} /usr/bin/${pkgname}
install -Dm644 src/${pkgname}@.service /usr/lib/systemd/user/${pkgname}@.service

if [ "$?" == "0" ]; then
    echo "Service installed succesfully."
else
    echo "There was a problem. Service not installed."
fi