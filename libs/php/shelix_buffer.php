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
 * Shelix List Tabler
 *
 * Display and select elements with arrow keys
 *
 *
 * LICENSE: This source is provided kindly by NVRM
 *
 * @category   IDE
 * @package    SHELIX
 * @author     NVRM <webdev23@users.noreply.github.com>
 * @link       https://github.com/webdev23/shelix
 */
register_shutdown_function("shutdown");

// declare(ticks=1);
pcntl_async_signals(true);
pcntl_signal(SIGINT, "shutdown");
pcntl_signal(SIGWINCH, function () {
    Buffer::$FLAGEXIT = 0;
});


class Buffer extends Nox
{
    public static $FORCESORT = 0;
    public static $SORTYPE = [
        [0, SORT_DESC, SORT_STRING],
        [0, SORT_ASC, SORT_STRING],
        [0, SORT_ASC, SORT_NUMERIC],
        [0, SORT_DESC, SORT_NUMERIC],
        [0, SORT_ASC, SORT_STRING],
        [2, SORT_DESC, SORT_STRING],
    ];
    public static $iSORTYPE = 0;
    public static $SCROLLING = [0, 0, 0]; // Bool Up/Down, epoch
    public static $FORCEWATCH = 0;
    public static $Z = 0;
    public static $P = 0;
    public static $COUNT = 0;
    public static $ZP = [0, 0];
    public static $FLAGEXIT = 1;
    public static $SELECTION = null;
    public static $HEADERS = [];
    public static $FOOTER = "";
    // public static $SCROLLER = [2, ["▼\033[5m▲\e[0m", "▲\033[5m▼\e[0m", "▲▼"]];
    // public static $NICER = [];
    public static $FFTH = "FFT.txt"; // You should move this outta here

    public static $EXECUTESELECTION = false; // Dispatch direct execution
    public static $EXECUTIONPATH = ""; // Dispatch direct execution
    public static $LSCACHE = []; // Store original list before text transformations
    public static $ONSELECTIONEXIT = false; // We exit and print the selection to STDOUT
    public static $FORCECWD = false; // We may want to use the shell path instead

    public static $LINKS = []; // Store symlinks path so we make sure we don't execute things in there

    
    private static function listToTTY(
        $OUT,
        $FILE,
        $ls,
        $BUFFER,
        $P,
        $Z,
        $W,
        $H,
        $SELECT,
        $screenX,
        $screenY,
        $highlgt
    ) {
        $comkeys = ""; // command keys joined
        $comShort = []; // array for shorthands

        $comHG = []; // may contain indexes for multiple highlight
        foreach ($ls as $k => $v) {
            if (strpos($v, "_") !== false) {
                if (str_contains($v, " ")) {
                    $shorts = explode("_", explode(" ", $v)[1]);
                } else {
                    $shorts = explode("_", $v);
                }
            } else {
                if (str_contains($v, " ")) {
                    $shorts = str_split(explode(" ", $v)[1]);
                } else {
                    $shorts = str_split(explode("_", $v));
                }
            }

            $short = "";
            foreach ($shorts as $kk => $vv) {
                $short .= @strtolower($vv[0]);
            }
            $comShort[] = [
                "short" => $short,
                "value" => trim($v),
                "index" => $k,
            ];
        }

        $pr = $ls;
        self::$COUNT = count($ls);
        $HOTSTART = 1;
        $Z = Buffer::$Z;
        $highlight = $highlgt === 1 ? "\033[35;1m" : "\033[1;7m";

        SELEX:
        /*    if (Buffer::$FLAGEXIT === 1){
      return $Z;
    } */
        echo "\e[?1003h\e[?1015h\e[?1006h";
        $c = "";
        $info = "";
        $W = Nox::$W;
        $H = Nox::$H;
        $FOOT = 2; // Footer height (lines)

        while ($c = @fread(STDIN, 16)) {
            Buffer::$SCROLLING[2] = time();
            $OUT = "";
            $info = $KEY = $c;

            $ctrl = false;
            if (strlen($KEY) > 8) {
                $e = @explode(";", explode("<", $KEY)[1]);
                /* MOUSE MOVE */
                /* BUTTON DOWN */
                if ($e[0] === "0" && substr($e[2], -1) === "M") {
                }
                /* RIGHT CLICK BUTTON DOWN */
                if ($e[0] === "2" && substr($e[2], -1) === "M") {
                    Buffer::$SELECTION = $Z; // Return INDEX
                    return;
                }

                /* CTRL + CLICK (wow) */
                if ($e[0] === "16" && substr($e[2], -1) === "m") {
                    Buffer::$SELECTION = $Z; // Return INDEX
                    return;
                }

                /* WHEEL ROLL UP */
                if ($e[0] === "64") {
                    // Buffer::$SCROLLER[0] = 0;
                    $Z--;
                    $P--;
                    if ($P <= 0) {
                        $P = 0;
                    }
                }
                /* WHEEL ROLL DOWN */
                if ($e[0] === "65") {
                    // Buffer::$SCROLLER[0] = 1;
                    $Z++;
                    $P++;
                    if ($P > $H - $FOOT - 1) {
                        $P = $H - $FOOT - 1;
                    } // When the scroll reach the bottom
                    if ($Z > count($ls) - 1) {
                        $Z = count($ls) - 1;
                    }
                    if ($P >= $Z) {
                        $P = $Z;
                    }
                }
                /* MOUSE wHEEL BUTTON DOWN */
                if ($e[0] === "1" && substr($e[2], -1) === "M") {
                }
            }

            /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
            $c = preg_replace('/[^[:print:]\n]/u', "", $c);
            /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
             // var_dump($c);sleep(3);

            /* Up arrow */
            if ($c === "[A") {
                // Buffer::$SCROLLER[0] = 0;
                $Z--;
                $P--;
                if ($P <= 0) {
                    $P = 0;
                }
                if (Buffer::$EXECUTESELECTION) {
                    $execpath = Buffer::$EXECUTIONPATH;
                    $execparam = trim(substr(Buffer::$LSCACHE[$Z], 4));
                    exec(
                        "$execpath '$execparam'  </dev/null > /dev/null 2>&1 &"
                    );
                }
            }

            /* Down arrow */
            if ($c === "[B") {
                // Buffer::$SCROLLER[0] = 1;
                $Z++;
                $P++;
                $line = (int) @substr($e[2], 0, -1);
                if ($P > $H - $FOOT - 1) {
                    $P = $H - $FOOT - 1;
                }
                if ($Z > count($ls) - 1) {
                    $Z = count($ls) - 1;
                }
                if ($P >= $Z) {
                    $P = $Z;
                }
                if (Buffer::$EXECUTESELECTION) {
                    $execpath = Buffer::$EXECUTIONPATH;
                    $execparam = trim(substr(Buffer::$LSCACHE[$Z], 4));
                    exec(
                        "$execpath '$execparam' </dev/null > /dev/null 2>&1 &"
                    );
                }
            }


            /* Ctrl + Up arrow */
            if ($c === "[1;5A") {
                $Z = $Z - 3;
                $P = $P - 3;
                if ($P <= 0) {
                    $P = 0;
                }
            }

            /* Ctrl + Down arrow */
            if ($c === "[1;5B") {
                // Buffer::$SCROLLER[0] = 1;
                $Z = $Z + 2;
                $P = $P + 2;
                if ($P > $H - $FOOT - 1) {
                    $P = $H - $FOOT - 1;
                }
                if ($Z > count($ls) - 1) {
                    $Z = count($ls) - 1;
                }
                if ($P >= $Z) {
                    $P = $Z;
                }
                if (Buffer::$EXECUTESELECTION) {
                    $execpath = Buffer::$EXECUTIONPATH;
                    $execparam = trim(substr(Buffer::$LSCACHE[$Z], 4));
                    exec(
                        "$execpath '$execparam' </dev/null > /dev/null 2>&1 &"
                    );
                }
            }



            $HOTSTART = 1;

            /* Right arrow or ENTER */
            if ($c === "[C" || $c === "\n") {
                echo "\033c";
                Buffer::$SELECTION = $Z; // Return INDEX
                return;
            }

            /* LEFT arrow */
            if ($c === "[D") {
                echo "\033c";
                Buffer::$FLAGEXIT = 0;
                return;
            }

            
            /* Q/q or (removed)Escape:   || $c === "" */
            if ($c === "q" || $c === "Q") {
                echo "\033c";
                shutdown();
            }


            /* Attempt to exit nicely */
            if (str_contains($c, "1;2C")) {
                echo "Shelix has exited to ease ressources";
                sleep(5);
            }

            /* Filter out remaining escape sequences in the keys sequence,
             * in particular [?1;2c get sent by terminal emulators after a resizing or a loss of focus,
             * and could get mixed in the command keys  */
            if (strstr($comkeys, "[")) {
                $comkeys = "";
            }

            /* !
               Copy selection to system clipboard
            */
            if ($c === "!") {
                echo "\033cCopied to clipboard.\nReturn to shell with Ctrl + c ";
                $insfile = trim(substr(Buffer::$LSCACHE[$Z], 4));
                file_put_contents("/tmp/clip", $insfile);
                exec("xclip /tmp/clip 2>&1 /dev/null");
                shutdown();
            }

            /* Ctrl right arrow
               Insert into editor buffer
            */
            if ($c === "[1;5C") {
                if (Buffer::$FORCECWD === true) {
                    Buffer::$EXECUTIONPATH = getcwd();
                }
                $insert =
                    Buffer::$EXECUTIONPATH .
                    "/" .
                    trim(explode(" ", $ls[$Z], 2)[1]);
                if (!is_file($insert)) {
                    $insert = trim(substr(Buffer::$LSCACHE[$Z], 4));
                    exec(
                        "hx_insert \"$insert\" text </dev/null 2&1>> \$SHELIXPATH/shelix.logs 2>&1 &"
                    );
                } else {
                    exec(
                        "hx_insert \"$insert\" </dev/null 2>> \$SHELIXPATH/shelix.logs 2>&1 &"
                    );
                }
            }

            /* Ctrl + Shift + right arrow "[1;6C" <= BUG
               Ctrl + Alt + right arrow <= PASS
               Open as file
            */
            if ($c === "[1;7C") {
                if (Buffer::$FORCECWD === true) {
                    Buffer::$EXECUTIONPATH = system("cd - && echo \$PWD");
                }
                $insfile =
                    Buffer::$EXECUTIONPATH .
                    "/" .
                    trim(substr(Buffer::$LSCACHE[$Z], 4));
                    // trim(explode(" ", $ls[$Z], 2)[1]);
                // exec("open_file '$insfile' </dev/null 2>> shelix.logs 2>&1 &");
                exec("open_file \"$insfile\" </dev/null 2>> \$SHELIXPATH/shelix.logs 2>&1 &");
            }


            /* m fast */

            /* Ctrl + PageUp
               menu up fast
            */
            if ($c === "[5;5~") {
                // Buffer::$SCROLLER[0] = 0;
                $Z = $Z - 5;
                $P = $P - 5;
                if ($P <= 0) {
                    $P = 0;
                }
            }

            /* Ctrl + PageDown
               menu down fast
            */
            if ($c === "[6;5~") {
                // Buffer::$SCROLLER[0] = 1;
                $Z = $Z + 5;
                $P = $P + 5;
                if ($P > $H - $FOOT - 1) {
                    $P = $H - $FOOT - 1;
                }
                if ($Z > count($ls) - 1) {
                    $Z = count($ls) - 1;
                }
                if ($P >= $Z) {
                    $P = $Z;
                }
            }

            /* PageUp
               menu up
            */
            if ($c === "[5~") {
                // Buffer::$SCROLLER[0] = 0;
                $Z--;
                $P--;
                if ($P <= 0) {
                    $P = 0;
                }
            }

            /* PageDown
               menu down
            */
            if ($c === "[6~") {
                // Buffer::$SCROLLER[0] = 1;
                $Z++;
                $P++;
                if ($P > $H - $FOOT - 1) {
                    $P = $H - $FOOT - 1;
                }
                if ($Z > count($ls) - 1) {
                    $Z = count($ls) - 1;
                }
                if ($P >= $Z) {
                    $P = $Z;
                }
            }

            /* Call elements with keyboard keys */
            $comkeys .= $c;
            $unik = 0;
            $com = "";
            foreach ($comShort as $k => $v) {
                if (substr($v["short"], 0, strlen($comkeys)) === $comkeys) {
                    $unik++;
                    $com = $v["index"];
                    $comHG[] = $v["index"];
                }
            }

            /* Uncomment to display the escape sequences in the log
             * Start with shelix 2> shelix.logs
             * Use to implement more keybindings
             * Funny things are posible in there such as catching Ctr + Shift + F-keys
             * And even implementing drag and drop, of elements or of external files
             */
            // fwrite(STDERR, json_encode($comkeys) . " <--\n");

            if ($unik === 1) {
                $comkeys = "";
                $comHG = [];
                echo "\033[c";
                Buffer::$SELECTION = $com; // Return INDEX
                return;
            }
        }

        if ($Z <= 0) {
            $Z = 0;
        }
        if ($c != "" || $HOTSTART === 1) {
            $sel = $FILE = @$ls[$Z];
            if ($H > 4) {
                $HEAD = $OUT;

                $OUT .= str_repeat(" ", Nox::$W);
            } else {
                $OUT .= "";
            }
            $sel = @$pr[$Z];
            $copy = $pr;

            for ($i = $Z - $P; $i < $Z - $P + $H - $FOOT; $i++) {
                if ($i >= 0 && $i < $i + $H && $i < count($copy)) {
                    if ($Z === $i || in_array($i, $comHG)) {
                        $OUT .= "\n";
                        $OUT .= "▶ \033[1;4;7m" . $copy[$i] . "\e[0m";
                    } else {
                        $OUT .= "\n";
                        $OUT .= "  " . $copy[$i] . "\e[0m";
                    }
                }
            }
            $HOTSTART = 0;

            $footer =
                strlen(join(Buffer::$HEADERS)) > $W
                    ? "..." . substr(join(Buffer::$HEADERS), -($W - 3))
                    : join(Buffer::$HEADERS);
            echo "\033[$screenY;$screenX" .
                "H" .
                $OUT . 
                "\033[$H;0H" .
                $footer.
                "\033[" .
                ($P + 2) .
                ";0H";
        }

        $ctrl = false; // Ctrl key

        usleep(10000);

        if (Buffer::$FLAGEXIT === 1) {
            goto SELEX;
        }
    }

    /**
     * @brief
     * @param $arrayInput
     * @param $cols
     * @param $lines
     * @param $screenX
     * @param $screenY
     * @returns
     *
     *
     */
    public function __construct($arrayInput, $cols, $lines, $screenX, $screenY)
    {
        $highlgt = 0;
        Buffer::$SELECTION = "";
        $SELECT = "";
        $OUT = "";
        $BUFFER = "";
        $FILE = "";
        SCAN:
        $ls = [];
        $Z = Buffer::$Z;
        $P = Buffer::$P;
        $H = $lines;
        $W = $cols;
        Buffer::$LSCACHE = $texts = $arrayInput;
        /* Sorting ----------------------------------------------------------------- */
        if (Buffer::$FORCESORT === 1) {
            Buffer::$iSORTYPE >= count(Buffer::$SORTYPE)
                ? (Buffer::$iSORTYPE = 0)
                : Buffer::$iSORTYPE;
            $STEMP = [];
            foreach ($texts as $n) {
                $STEMP[] = [$n, $n, $n];
            }
            array_multisort(
                array_column($STEMP, Buffer::$SORTYPE[Buffer::$iSORTYPE][0]),
                Buffer::$SORTYPE[Buffer::$iSORTYPE][1],
                Buffer::$SORTYPE[Buffer::$iSORTYPE][2],
                $STEMP
            );
            Buffer::$FORCESORT = 0;
            $texts = [];
            foreach ($STEMP as $o) {
                $texts[] = $o[2];
            }
            $Z = 0;
            $P = 0;
            echo "\033c";
        }

        foreach ($texts as $text) {
            $text = $text . str_repeat(" ", abs(Nox::$W));
            $ls[] =
                strlen(substr($text, 0, Nox::$W - 2)) < $W - 2
                    ? $text
                    : substr($text, 0, Nox::$W - 2);
        }

        $OUT = "";

        Buffer::listToTTY(
            $OUT,
            $FILE,
            $ls,
            $BUFFER,
            $P,
            $Z,
            $W,
            $H,
            $SELECT,
            $screenX,
            $screenY,
            $highlgt
        );
        if (Buffer::$FORCESORT === 1) {
            goto SCAN;
        }
        Buffer::$Z = $Z;
        Buffer::$P = $P;
        Buffer::$FLAGEXIT = 1;
        return Buffer::$SELECTION;
    }

    /**
     * @brief
     * @returns
     *
     *
     */
    public function __toString()
    {
        return self::$OUT;
    }
}

