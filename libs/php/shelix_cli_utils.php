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
╚-----------------------------------------------------------------------╝*/

/**
 * CLI utils for Shelix
 *
 *

/* Shell config ------------------------------ */
stream_set_blocking(STDIN, false);
stream_set_timeout(STDIN, 10);
system("stty -icanon && stty -echo");

// Cursor
echo "\033c";
// echo "\033c\033[999;999H\033[6n\033[1;1H";
// system("stty -echo");


/**
 * @brief
 *
 *
 */
class Nox
{
    public static $PID_FORKS = [];
    public static $W = 0;
    public static $H  = 0;
}

function consoleResize()
{
    ob_start();
    Nox::$W = (int)exec("tput cols");
    Nox::$H = (int)exec("tput lines");
    fwrite(STDERR, "RESIZED " . Nox::$W . " " . Nox::$H . "\n");
    ob_end_clean();
}

/* Register action at SIGSTOP (Ctrl + z) ---------------------------------------------- */
/**
 * @brief
 * @returns
 *
 *
 */
function sigSTOP()
{
    echo "\e[?1000l";
    system("tput cnorm && stty echo");
    fwrite(STDERR, "SIGSTOP \n");
    echo PHP_EOL;
}

/* Register action at SIGCONT (Type fg to resume) ---------------------------------------------- */
/**
 * @brief
 * @returns
 *
 *
 */
function sigCONT()
{

    fwrite(STDERR, "SIGCONT\n");
    consoleResize();
}

/* Adapt to terminal dimensions
---------------------------------------------- */
// consoleResize();
