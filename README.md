# BrowserPilot - Smart URL Handler for Linux

A robust Bash script that intelligently routes URLs to specific browsers based on domain patterns. Perfect for maintaining browser separation for privacy, work-life balance, or application-specific workflows.

## ✨ Features

- **Pattern-Based URL Routing**: Use regex patterns to route URLs to specific browsers
- **Multi-Browser Support**: Works with Chromium, Firefox, Chrome, Opera, and more
- **Specialized App Integration**: Direct support for Teams, Mattermost, and other web applications
- **Flatpak Ready**: Full support for containerized browser installations
- **Easy Configuration**: Simple regex patterns for custom routing rules
- **System Integration**: Seamless MIME type integration with Linux desktop environments
- **Browser Separation**: Keep work, personal, and development browsing completely separate

## 📋 Prerequisites

### Required Packages
```bash
# Most distributions have these by default
bash, xdg-utils

# For Flatpak browser support (optional)
sudo apt-get install flatpak
```

### System Requirements
- **Linux distribution** with XDG MIME support
- **Desktop environment** with .desktop file support
- **Flatpak runtime** (for containerized browser support)

## 🚀 Quick Start

### 1. Download the Script
```bash
wget https://raw.githubusercontent.com/lexo-ch/browserpilot-url-based-browser-switcher/master/browserpilot.sh
chmod +x browserpilot.sh

# Create scripts directory if it doesn't exist
mkdir -p ~/scripts
mv browserpilot.sh ~/scripts/
```

### 2. Create Desktop Entry
```bash
nano ~/.local/share/applications/browserpilot.desktop
```

Add the following content:
```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=BrowserPilot
Comment=Intelligent URL routing to appropriate browsers
Exec=/home/%i/scripts/browserpilot.sh %u
Icon=web-browser
Categories=Network;WebBrowser;
MimeType=x-scheme-handler/http;x-scheme-handler/https;
NoDisplay=true
```

### 3. Register as System Handler
```bash
# Update desktop database
update-desktop-database ~/.local/share/applications/

# Set as default URL handler
xdg-mime default browserpilot.desktop x-scheme-handler/http
xdg-mime default browserpilot.desktop x-scheme-handler/https
```

### 4. Verify Installation
```bash
# Check if BrowserPilot is set as default
xdg-mime query default x-scheme-handler/http
# Should return: browserpilot.desktop
```

## ⚙️ Configuration

### Default Browser
Edit the `DEFAULT_BROWSER` variable in the script to set your fallback browser:
```bash
DEFAULT_BROWSER="/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=brave --file-forwarding com.brave.Browser @@u $url @@"
```

### Adding Custom Routes
Add new routing rules by creating additional `elif` conditions:
```bash
elif [[ "$url" =~ (github\.com)|(gitlab\.com) ]]; then
    # Route development sites to Chromium
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=/app/bin/chromium --file-forwarding org.chromium.Chromium @@u "$url" @@
```

### Example Use Cases
- **Work-Life Separation**: Route work domains to Firefox, personal browsing to Chrome
- **Privacy-Focused**: Route sensitive sites to hardened browser instances
- **Development Workflow**: Route code repositories to Chromium with dev tools

## 🔧 Troubleshooting

### Handler Not Appearing in System Settings
If BrowserPilot doesn't appear in your system's default applications, manually edit:
```bash
nano ~/.config/mimeapps.list
```

Add under `[Default Applications]`:
```ini
x-scheme-handler/http=browserpilot.desktop
x-scheme-handler/https=browserpilot.desktop
```

### Testing the Handler
Enable debug notifications by uncommenting this line in the script:
```bash
notify-send "BrowserPilot: Opening $url"
```

## 📄 License

No license, no warranties, use however you like.

## 🏆 Acknowledgments

- Inspired by the need for better browser workflow management in Linux
- Built for the privacy-conscious and productivity-focused Linux community

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests. All contributions are welcome!

## 📞 Support

For questions or support, please open an issue on [GitHub](https://github.com/lexo-ch/browserpilot-url-based-browser-switcher/issues).
