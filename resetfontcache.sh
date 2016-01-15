#!/bin/sh

# Richard Charbonneau 2016

# Removes all user-based and system font caches

atsutil databases -remove

# Stops the Apple Type Services service

atsutil server -shutdown

# Starts the Apple Type Services service

atsutil server -ping