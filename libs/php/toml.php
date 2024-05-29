#!/usr/bin/env php
<?php
/*
╔-----------------------------------------------------------------------╗
║                                                                       ║
║ This file is part of the Shelix IDE.                                  ║
║ Copyright (C) 2024 NVRM webdev23 https://github.com/webdev23          ║
║                                                                       ║
║ This program is free software: you can redistribute it and/or modify  ║
║ it under the terms of the GNU General Public License as published by  ║
║ the Free Software Foundation, either version 3 of the License, or     ║
║ (at your option) any later version.                                   ║
║                                                                       ║
║ This program is distributed in the hope that it will be useful,       ║
║ but WITHOUT ANY WARRANTY; without even the implied warranty of        ║
║ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ║
║ GNU General Public License for more details.                          ║
║                                                                       ║
║ You should have received a copy of the GNU General Public License     ║
║ along with this program.  If not, see <http://www.gnu.org/licenses/>. ║
╚-----------------------------------------------------------------------╝
*/

$fileContent = file_get_contents('../config.toml');
$tokens = token_get_all('<?php ' . $fileContent);

foreach ($tokens as $token) {
    if (is_array($token)) {
        $tokenType = token_name($token[0]);
        $tokenValue = $token[1];
        echo "Token type: $tokenType, Value: $tokenValue\n";
    } else {
        echo "Token: $token\n";
    }
}
