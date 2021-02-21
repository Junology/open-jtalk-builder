# open-jtalk-builder
Build Open JTalk (http://open-jtalk.sourceforge.net/) and associated libraries.

## How to use
```Shell
git clone https://github.com/Junology/open-jtalk-builder
cd open-jtalk-builder
bash open-jtalk-builder.sh
```

## What will happen?
The script creates the following two directories:
 - `usr`: this contains all the resulting executables, headers, and libraries;
 - `build`: this contains the sources of Open JTalk and hts_engine API (http://hts-engine.sourceforge.net/), which is needed to build Open JTalk. One can remove it after the contents of `usr` directory are generated.
