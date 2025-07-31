#!/bin/bash
#==============================================================================
# BrowserPilot - Intelligent Browser Routing System
#==============================================================================
# BrowserPilot provides intelligent URL routing to specific browsers based on
# domain patterns using regular expressions. It serves as a system-wide URL
# handler that intercepts browser requests and directs them to the most
# appropriate application.
#
# Features:
# - Pattern-based URL routing using regex matching
# - Support for multiple browser engines (Chromium, Firefox, Chrome, Opera)
# - Specialized application handling (Teams, Mattermost)
# - Flatpak containerized browser support
# - Configurable default browser fallback
# - System integration via MIME type associations
#
# Configuration:
# - Modify regex patterns in the routing section for custom URL handling
# - Update browser commands to match your system's installation paths
# - Adjust DEFAULT_BROWSER variable for fallback behavior
#
# System Requirements:
# - Linux distribution with XDG MIME support
# - Flatpak runtime (for containerized browser support)
# - Desktop environment with .desktop file support
#
# Author: LEXO
# Version: 1.0
# Date: 2025-07-31
# License: [Add your license here]
# Repository: [Add repository URL if applicable]
#==============================================================================

#==============================================================================
# INSTALLATION GUIDE
#==============================================================================
# STEP 1: Make Script Executable
#   $ chmod +x ~/scripts/browserpilot.sh
#
# STEP 2: Create Desktop Entry
#   $ nano ~/.local/share/applications/browserpilot.desktop
#
#   Add the following content (replace %USERNAME% with your actual username):
#   [Desktop Entry]
#   Version=1.0
#   Type=Application
#   Name=BrowserPilot
#   Comment=Intelligent URL routing to appropriate browsers
#   Exec=/home/%USERNAME%/scripts/browserpilot.sh %u
#   Icon=web-browser
#   Categories=Network;WebBrowser;
#   MimeType=x-scheme-handler/http;x-scheme-handler/https;
#   NoDisplay=true
#
# STEP 3: Update Desktop Database
#   $ update-desktop-database ~/.local/share/applications/
#
# STEP 4: Set as Default URL Handler
#   Option A - GUI Method:
#     Navigate to Settings > Default Applications > Web Browser
#     Select "BrowserPilot" from the list
#
#   Option B - CLI Method:
#     $ xdg-mime default browserpilot.desktop x-scheme-handler/http
#     $ xdg-mime default browserpilot.desktop x-scheme-handler/https
#
# STEP 5: Verify Installation (Optional)
#   $ xdg-mime query default x-scheme-handler/http
#   Expected output: browserpilot.desktop
#==============================================================================

#==============================================================================
# TROUBLESHOOTING
#==============================================================================
# Issue: BrowserPilot doesn't appear in system settings
# Solution: Manually edit MIME associations
#   $ nano ~/.config/mimeapps.list
#
#   Add under [Default Applications]:
#   x-scheme-handler/http=browserpilot.desktop
#   x-scheme-handler/https=browserpilot.desktop
#
# Issue: URLs not opening correctly
# Solution: Enable debug mode (uncomment line in Configuration section)
#==============================================================================

#==============================================================================
# CONFIGURATION
#==============================================================================

# Capture URL from system (passed as first argument)
url="$1"

# Debug mode - uncomment to enable desktop notifications for troubleshooting
# notify-send "BrowserPilot" "Routing: $url"

#==============================================================================
# URL ROUTING RULES
#==============================================================================
# Add or modify patterns below to customize browser routing behavior
# Pattern format: [[ "$url" =~ (domain1\.com)|(domain2\.org) ]]
# Use pipe (|) to separate multiple domains for the same browser

# Default browser command - modify to match your preferred browser
# Supports: Flatpak apps, system binaries, AppImages, or custom commands
DEFAULT_BROWSER="/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=brave --file-forwarding com.brave.Browser @@u $url @@"

if [[ "$url" =~ (chromium\.example) ]]; then
    # Route Chromium-specific domains to Chromium browser
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=/app/bin/chromium --file-forwarding org.chromium.Chromium @@u "$url" @@

elif [[ "$url" =~ (firefox\.example) ]]; then
    # Route Firefox-specific domains to Firefox browser
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=firefox --file-forwarding org.mozilla.firefox @@u "$url" @@

elif [[ "$url" =~ (google\.com)|(gmail\.com) ]]; then
    # Route Google services to Chrome for optimal compatibility
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=/app/bin/chrome --file-forwarding com.google.Chrome @@u "$url" @@

elif [[ "$url" =~ (opera\.example) ]]; then
    # Route Opera-specific domains to Opera browser
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=opera --file-forwarding com.opera.Opera @@u "$url" @@

elif [[ "$url" =~ teams\.microsoft\.com ]]; then
    # Route Microsoft Teams to dedicated Teams application
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=teams-for-linux --file-forwarding com.github.IsmaelMartinez.teams_for_linux @@u "$url" @@

elif [[ "$url" =~ (mattermost\.example\.com) ]]; then
    # Route Mattermost to dedicated desktop client with WebRTC support
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=mattermost-flatpak --file-forwarding com.mattermost.Desktop --enable-features=WebRTCPipeWireCapturer @@u "$url" @@

else
    # Fallback to default browser for unmatched URLs
    $DEFAULT_BROWSER
fi