#!/bin/sh

# Swift Package Manager [has some strict requirements](https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md#creating-c-language-targets) to source files layout.
# We can gain SPM support with minimal project structure changes by applying an autogenerated layout based on symbolic links technics. 
# SPM related files located under `spm` folder at project's root.
# You should **NEVER** modify it manually nor inlude to Xcode's project.

#  ### Generate SPM layout

#  1. From **project's root** run:

#     `bash scripts/generate_spm_sources_layout.sh`

#  2. Commit Changes

#  Repeate those steps each time you delete/add project's files. **Make sure** to have this CI step which will check that `generate_spm_sources_layout.sh` is not broken.

set -e

###IGListDiffKit
SPM_IG_LIST_DIFF_KIT_PUBLIC_HEADERS_PATH="spm/Sources/IGListDiffKit/include"
SPM_IG_LIST_DIFF_KIT_SOURCES_PATH="spm/Sources/IGListDiffKit"

function generate_ig_list_diff_kit_spm_public_headers() {
    echo "Generate symbolic links for all public headers. *.h"
    echo "Generated under ${SPM_IG_LIST_DIFF_KIT_PUBLIC_HEADERS_PATH}"

    public_headers_list=$(
        find "Source/IGListDiffKit" \
        -type f -name "*.[h]" \
        -not -path "spm/*" \
        -not -path "Source/IGListDiffKit/Internal/*" \
        -not -path "Examples/*" | sed "s| \([^/]\)|:\1|g"
    )

    SRC_ROOT=$(pwd)
    cd $SPM_IG_LIST_DIFF_KIT_PUBLIC_HEADERS_PATH
    for public_file in $public_headers_list; do
        file_to_link=$(echo $public_file | sed "s|:| |g")
        ln -s ../../../../$file_to_link

    done

    cd $SRC_ROOT
    echo "      Done"
    echo ""
}

function generate_ig_list_diff_kit_spm_private_headers() {
    echo "Generate symbolic links for all private headers *.h"
    echo "Generated under ${SPM_IG_LIST_DIFF_KIT_SOURCES_PATH}"

    private_headers_list=$(
        find "Source/IGListDiffKit/Internal" \
        -type f -name "*.h" \
        -not -path "spm/*" | sed "s| \([^/]\)|:\1|g")

    SRC_ROOT=$(pwd)
    cd $SPM_IG_LIST_DIFF_KIT_SOURCES_PATH

    for private_file in $private_headers_list; do
        file_to_link=$(echo $private_file | sed "s|:| |g")

        ln -s ../../../$file_to_link

    done

    cd $SRC_ROOT

    echo "      Done"
    echo ""
}

function generate_ig_list_diff_kit_spm_sources() {
    echo "Generate symbolic links for all public implementations. *.m & *.mm"
    echo "Generated under ${SPM_IG_LIST_DIFF_KIT_SOURCES_PATH}"

    sources_list=$(
        find "Source/IGListDiffKit" \
        -type f -name "*.[m]" -o -name "*.mm" \
        -not -path "spm/*" | sed "s| \([^/]\)|:\1|g")

    SRC_ROOT=$(pwd)
    cd $SPM_IG_LIST_DIFF_KIT_SOURCES_PATH

    for source_file in $sources_list; do
        file_to_link=$(echo $source_file | sed "s|:| |g")

        ln -s ../../../$file_to_link

    done

    cd $SRC_ROOT

    echo "      Done"
    echo ""
}

function generate_ig_list_diff_kit() {
    generate_ig_list_diff_kit_spm_public_headers

    generate_ig_list_diff_kit_spm_private_headers

    generate_ig_list_diff_kit_spm_sources
}

#### IGListKit
SPM_IG_LIST_KIT_PUBLIC_HEADERS_PATH="spm/Sources/IGListKit/include"
SPM_IG_LIST_KIT_SOURCES_PATH="spm/Sources/IGListKit"

function generate_ig_list_kit_spm_public_headers() {
    echo "Generate symbolic links for all public headers. *.h"
    echo "Generated under ${SPM_IG_LIST_KIT_PUBLIC_HEADERS_PATH}"

    public_headers_list=$(
        find "Source/IGListKit" \
        -name "*.[h]" \
        -type f -not -path "spm/*" \
        -not -path "Source/IGListKit/Internal/*" \
        -not -path "Examples/*" | sed "s| \([^/]\)|:\1|g"
    )

    SRC_ROOT=$(pwd)
    cd $SPM_IG_LIST_KIT_PUBLIC_HEADERS_PATH

    for public_file in $public_headers_list; do
        file_to_link=$(echo $public_file | sed "s|:| |g")
        ln -s ../../../../$file_to_link

    done

    cd $SRC_ROOT
    echo "      Done"
    echo ""
}

function generate_ig_list_kit_spm_private_headers() {
    echo "Generate symbolic links for all private headers/implementations *.h && *.m"
    echo "Generated under ${SPM_IG_LIST_KIT_SOURCES_PATH}"

    shared_ig_diff_kit_sorces_list=$(find "Source/IGListDiffKit/Internal" \
        -name "*.[hm]" -o -name "*.mm" \
        -type f -not -path "spm/*" \
        -not -path "Examples/*" | sed "s| \([^/]\)|:\1|g")

    private_headers_list=$(find "Source/IGListKit/Internal" \
        -name "*.h" \
        -type f -not -path "spm/*" \
        -not -path "Examples/*" | sed "s| \([^/]\)|:\1|g")

    SRC_ROOT=$(pwd)
    cd $SPM_IG_LIST_KIT_SOURCES_PATH

    for shared_file in $shared_ig_diff_kit_sorces_list; do
        file_to_link=$(echo $shared_file | sed "s|:| |g")
        ln -s ../../../$file_to_link

    done

    for private_file in $private_headers_list; do
        file_to_link=$(echo $private_file | sed "s|:| |g")

        ln -s ../../../$file_to_link

    done

    cd $SRC_ROOT

    echo "      Done"
    echo ""
}

function generate_ig_list_kit_spm_sources() {
    echo "Generate symbolic links for all public implementations. *.m"
    echo "Generated under ${SPM_IG_LIST_KIT_SOURCES_PATH}"

    sources_list=$(
        find "Source/IGListKit" \
        -name "*.m" -o -name "*.mm" \
        -type f -not -path "spm/*" \
        -not -path "Examples/*" | sed "s| \([^/]\)|:\1|g")

    SRC_ROOT=$(pwd)
    cd $SPM_IG_LIST_KIT_SOURCES_PATH

    for source_file in $sources_list; do
        file_to_link=$(echo $source_file | sed "s|:| |g")

        ln -s ../../../$file_to_link

    done

    cd $SRC_ROOT

    echo "      Done"
    echo ""
}

function generate_ig_list_kit() {
    generate_ig_list_kit_spm_public_headers

    generate_ig_list_kit_spm_private_headers

    generate_ig_list_kit_spm_sources
}

# Delete all symbolik links from `spm` folder
function cleanup() {
    rm -rf $SPM_IG_LIST_DIFF_KIT_PUBLIC_HEADERS_PATH/*.*
    rm -rf $SPM_IG_LIST_DIFF_KIT_SOURCES_PATH/*.*
    #IGListKit
    rm -rf $SPM_IG_LIST_KIT_PUBLIC_HEADERS_PATH/*.*
    rm -rf $SPM_IG_LIST_KIT_SOURCES_PATH/*.*
}

########## SPM generator pipeline #############
#1
cleanup
#2
generate_ig_list_diff_kit
# #3
generate_ig_list_kit
