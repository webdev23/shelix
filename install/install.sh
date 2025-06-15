# ╔-----------------------------------------------------------------------╗
# ║                                                                       ║
# ║ This file is part of the Shelix IDE.                                  ║
# ║ Copyright (C) 2024 NVRM webdev23 https://github.com/webdev23          ║
# ║                                                                       ║
# ║ This program is free software: you can redistribute it and/or modify  ║
# ║ it under the terms of the GNU General Public License as published by  ║
# ║ the Free Software Foundation, either version 3 of the License, or     ║
# ║ (at your option) any later version.                                   ║
# ║                                                                       ║
# ║ This program is distributed in the hope that it will be useful,       ║
# ║ but WITHOUT ANY WARRANTY; without even the implied warranty of        ║
# ║ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ║
# ║ GNU General Public License for more details.                          ║
# ║                                                                       ║
# ║ You should have received a copy of the GNU General Public License     ║
# ║ along with this program.  If not, see <http://www.gnu.org/licenses/>. ║
# ╚-----------------------------------------------------------------------╝


# Create symbolic links to add shelix to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf /media/nvrm/dev/DEVS/SHELIX/shelix.sh ~/.local/bin/shelix
# Place the shelix.desktop file somewhere it can be found by the OS
cp -f /media/nvrm/dev/DEVS/SHELIX/shelix.desktop ~/.local/share/applications/
# Add the shelix.desktop file
cp -f /media/nvrm/dev/DEVS/SHELIX/shelix-open.desktop ~/.local/share/applications/
# Update the paths to the shelix and its icon in the shelix.desktop file(s)
sed -i "s|Icon=shelix|Icon=/media/nvrm/dev/DEVS/SHELIX/shelix.png|g" ~/.local/share/applications/shelix*.desktop
sed -i "s|Exec=shelix|Exec=/media/nvrm/dev/DEVS/SHELIX/shelix|g" ~/.local/share/applications/shelix*.desktop
