#! /bin/bash

PATH=$PATH:/root/.cabal/bin

cd $PANDOCKER_PATH

function set_if_exists(){
  file_name=$1
  exists_string=$2
  miss_string=$3

  if [ -z ${file_name} ]; then
    response=$miss_string
  else
    response=$exists_string
  fi

  echo response
}

function set_if_true(){
  var_name=$1
  exists_string=$2
  miss_string=$3
  
  with_var=${with_var:-true}
  if $WITH_TABLE_OF_CONTENTS; then
    echo "[INFO] Table of contents enabled"
    ADD_TOC="--toc"
  else
    echo "[INFO] Table of contents disabled"
    ADD_TOC=""
  fi
}

# Check template is enabled
ADD_TEMPLATE=`set_if_exists $TEMPLATE_PATH "--template $TEMPLATE_PATH" ""

# Check table of contents is disabled
WITH_TABLE_OF_CONTENTS=${WITH_TABLE_OF_CONTENTS:-true}
if $WITH_TABLE_OF_CONTENTS; then
  echo "[INFO] Table of contents enabled"
  ADD_TOC="--toc"
else
  echo "[INFO] Table of contents disabled"
  ADD_TOC=""
fi

# Check table of figures is disabled
WITH_TABLE_OF_FIGURES=${WITH_TABLE_OF_FIGURES:-true}
if $WITH_TABLE_OF_FIGURES; then
  echo "[INFO] Table of figures enabled"
  ADD_TOF="--tof"
else
  echo "[INFO] Table of figures disabled"
  ADD_TOF=""
fi

# Check table of tables is disabled
WITH_TABLE_OF_TABLES=${WITH_TABLE_OF_TABLES:-true}
if $WITH_TABLE_OF_TABLES; then
  echo "[INFO] Table of tables enabled"
  ADD_TOT="--tot"
else
  echo "[INFO] Table of tables disabled"
  ADD_TOT=""
fi

# Check output file
if [ -z ${OUTPUT_FILE} ]; then
  echo "[INFO] No output file described (OUTPUT_FILE). Using 'doc.pdf'"
  ADD_OUTPUT_FILE="doc.pdf"
else
  echo "[INFO] Using $OUTPUT_FILE output file"
  ADD_OUTPUT_FILE=$OUTPUT_FILE
fi

# Check source dir
if [ -z ${SOURCE_DIR} ]; then
  echo "[INFO] No source directory (SOURCE_DIR) described. Using 'src/'"
  SOURCE_DIR="src"
else
  echo "[INFO] Using $SOURCE_DIR source directory"
fi

# Check src dir exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "[ERROR] $SOURCE_DIR not found."
  echo "please check the manual at https://github.com/luanguimaraesla/pandocker"
  exit 1
fi

# Check sections.conf exists
if [ ! -f "$SOURCE_DIR/sections.conf" ]; then
  echo "[ERROR] $SOURCE_DIR/sections.conf not found."
  echo "please check the manual at https://github.com/luanguimaraesla/pandocker"
  exit 1
fi

# Check figures directory
if [ -z ${FIGURES_DIR} ]; then
  echo "[INFO] No figure directory described. Using 'images/'"
  IS_CUSTOM_FIGURES_DIR=false
else
  echo "[INFO] Using $FIGURES_FILE output file"
  cd $SOURCE_DIR
  cp $FIGURES_DIR $PANDOCKER_PATH/$FIGURES_DIR
  cd $PANDOCKER_PATH
  IS_CUSTOM_FIGURES_DIR=true 
fi

pandoc  $ADD_TEMPLATE -s \
        --filter pandoc-crossref \
        --filter pandoc-citeproc \
        -f markdown $ADD_TOT $ADD_TOF $ADD_TOC \
        -o $ADD_OUTPUT_FILE \
        `sed "s/$/.md/g;s/^/$SOURCE_DIR\//g" $SOURCE_DIR/sections.conf | xargs`;

if $IS_CUSTOM_FIGURES_DIR; then
  rm -rf $PANDOCKER_PATH/$FIGURES_DIR
fi

echo "[INFO] Finished"
echo
echo "Thank you for using Pandocker! :)"
echo
echo "If the document $ADD_OUTPUT_FILE does not exist, please check the manual"
echo "at https://github.com/luanguimaraesla/pandocker."
echo "Feel comfortable to report any problems through the github issues environment"
echo
