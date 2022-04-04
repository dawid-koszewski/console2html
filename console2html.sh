#!/bin/sh

# Author: Dawid Koszewski
# Created: 2021.09.18
# Modified: 2022.01.11

# Colors: https://ethanschoonover.com/solarized/
P0=073642;  # black     (term 30)       base02
P1=DC322F;  # red       (term 31)       red
P2=859900;  # green     (term 32)       green
P3=B58900;  # yellow    (term 33)       yellow
P4=268BD2;  # blue      (term 34)       blue
P5=D33682;  # magenta   (term 35)       magenta
P6=2AA198;  # cyan      (term 36)       cyan
P7=EEE8D5;  # white     (term 37)       base2
P8=002B36;  # brblack   (term 30;1)     base03
P9=CB4B16;  # brred     (term 31;1)     orange
P10=586E75; # brgreen   (term 32;1)     base01
P11=657B83; # bryellow  (term 33;1)     base00
P12=839496; # brblue    (term 34;1)     base0
P13=6C71C4; # brmagenta (term 35;1)     violet
P14=93A1A1; # brcyan    (term 36;1)     base1
P15=FDF6E3; # brwhite   (term 37;1)     base3

printf '%s' "
<html>
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
<style type=\"text/css\">
pre { white-space: pre-wrap; }

.ef0,  .f0                      { color: #$P0; } .eb0, .b0 { background-color: #$P0; }
.ef1,  .f1                      { color: #$P1; } .eb1, .b1 { background-color: #$P1; }
.ef2,  .f2                      { color: #$P2; } .eb2, .b2 { background-color: #$P2; }
.ef3,  .f3                      { color: #$P3; } .eb3, .b3 { background-color: #$P3; }
.ef4,  .f4                      { color: #$P4; } .eb4, .b4 { background-color: #$P4; }
.ef5,  .f5                      { color: #$P5; } .eb5, .b5 { background-color: #$P5; }
.ef6,  .f6                      { color: #$P6; } .eb6, .b6 { background-color: #$P6; }
.ef7,  .f7                      { color: #$P7; } .eb7, .b7 { background-color: #$P7; }
.ef8,  .f0 > .bold, .bold > .f0 { color: #$P8; } .eb8      { background-color: #$P8; }
.ef9,  .f1 > .bold, .bold > .f1 { color: #$P9; } .eb9      { background-color: #$P9; }
.ef10, .f2 > .bold, .bold > .f2 { color: #$P10; } .eb10     { background-color: #$P10; }
.ef11, .f3 > .bold, .bold > .f3 { color: #$P11; } .eb11     { background-color: #$P11; }
.ef12, .f4 > .bold, .bold > .f4 { color: #$P12; } .eb12     { background-color: #$P12; }
.ef13, .f5 > .bold, .bold > .f5 { color: #$P13; } .eb13     { background-color: #$P13; }
.ef14, .f6 > .bold, .bold > .f6 { color: #$P14; } .eb14     { background-color: #$P14; }
.ef15, .f7 > .bold, .bold > .f7 { color: #$P15; } .eb15     { background-color: #$P15; }

.bold           { color: #$P15; }
.italic         { font-style: italic; }
.underline      { text-decoration: underline; }
.blink          { animation: animate 0.75s linear infinite; }
.reverse        { color: #$P0; background-color: #$P7; }
.line-through   { text-decoration: line-through; }

@keyframes animate {
    0%   { opacity: 0.55; }
    50%  { opacity: 1;    }
    100% { opacity: 0.55; }}

.bold > .f1 { color: #$P1; font-weight: bold; animation: animate 0.75s linear infinite; }
.bold > .italic > .f5 { color: #$P4; }
.f5 { color: #$P3; }

</style>
</head>

<body class=\"f7 eb8\">
<pre>
"

ESC='\x1b\['
NUL='\x00'

sed -r "
:do_while
    s/(${ESC})([0-9]*);([0-9]*)(m?)/\1\2m\1\3\4/ # split ansi color tags (e.g. ESC1;3;35m into ESC1mESC3mESC35m)
t do_while
" |

sed -nr "
s/${ESC}0m/${NUL}/g

# pattern style /a|b/ ! (line without any color tags)
/${ESC}[134579][0-9]?m|${NUL}/ ! {
    x
    /${ESC}[134579][0-9]?m/ {
        x
        H
        d
    }
    x
    p
    d
}

# pattern style /b/ (line with null tag/s)
/${NUL}/ {
    H
    s/.*//
    x
    s/^\n//

    s/(${ESC}1m)([^${NUL}]*)(${NUL})/<span class=\"bold\">\2\3\3/g
    s/(${ESC}3m)([^${NUL}]*)(${NUL})/<span class=\"italic\">\2\3\3/g
    s/(${ESC}4m)([^${NUL}]*)(${NUL})/<span class=\"underline\">\2\3\3/g
    s/(${ESC}5m)([^${NUL}]*)(${NUL})/<span class=\"blink\">\2\3\3/g
    s/(${ESC}7m)([^${NUL}]*)(${NUL})/<span class=\"reverse\">\2\3\3/g
    s/(${ESC}9m)([^${NUL}]*)(${NUL})/<span class=\"line-through\">\2\3\3/g
    s/${ESC}3([0-9])m([^${NUL}]*)(${NUL})/<span class=\"f\1\">\2\3\3/g
    s/${ESC}4([0-9])m([^${NUL}]*)(${NUL})/<span class=\"b\1\">\2\3\3/g

    s/(\<span\sclass=)([^${NUL}]*)${NUL}/\1\2/g # remove one excessive NUL (</span>)
    s/${NUL}/<\/span>/g
}

# pattern style /a[^b]*$/ (line with color tag without following null tag)
/${ESC}[134579][0-9]?m[^${NUL}]*$/ {
    H
    s/.*\n([^\n]*)$/\1/ # get only last line
    x
    s/(.*)\n[^\n]*$/\1/ # get everything except the last line
}

# print non blanks
/^$/ ! {
    s/^\n//
    p
}
"

printf '
</pre>
</body>
</html>\n
'
