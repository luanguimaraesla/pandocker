#! /bin/bash

PATH=$PATH:/root/.local/bin

cd $PANDOCKER_PATH

# Check template is enabled
if [ -z ${TEMPLATE_PATH} ]; then
  echo "Using default template"
  ADD_TEMPLATE=""
else
  echo "Using $TEMPLATE_PATH"
  ADD_TEMPLATE="--template $TEMPLATE_PATH"
fi

# Check table of contents is disabled
WITH_TABLE_OF_CONTENTS=${WITH_TABLE_OF_CONTENTS:-true}
if $WITH_TABLE_OF_CONTENTS; then
  echo "Table of contents enabled"
  ADD_TOC="--toc"
else
  echo "Table of contents disabled"
  ADD_TOC=""
fi

# Check output file
if [ -z ${OUTPUT_FILE} ]; then
  echo "No output file described (OUTPUT_FILE). Using 'doc.pdf'"
  ADD_OUTPUT_FILE="doc.pdf"
else
  echo "Using $OUTPUT_FILE output file"
  ADD_OUTPUT_FILE=$OUTPUT_FILE
fi

# Check source dir
if [ -z ${SOURCE_DIR} ]; then
  echo "No source directory (SOURCE_DIR) described. Using 'src/'"
  SOURCE_DIR="src"
else
  echo "Using $SOURCE_DIR source directory"
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

pandoc  $ADD_TEMPLATE -s \
        --filter pandoc-crossref \
        --filter pandoc-citeproc \
        -f markdown --toc -o $ADD_OUTPUT_FILE \
        `sed 's/$/.md/g;s/^/src\//g' $SOURCE_DIR/sections.conf | xargs`;

echo "Finished"
echo
echo "If the document $ADD_OUTPUT_FILE does not exist, please check the manual"
echo "at https://github.com/luanguimaraesla/pandocker."
echo "Feel comfortable to report any problems through the github issues environment"
echo
