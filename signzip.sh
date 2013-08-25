#!/bin/bash

INPUT="$1"
OUTPUT="$3"
KEY="$2"

function printUsage() {
  echo "Usage: $0 input.zip [key] [output.zip]"
}

if [ "$INPUT" == "" ];then
  printUsage
  exit 1
fi

if [ "$OUTPUT" == "" ];then
  filename=$(basename "$INPUT")
  extension="${filename##*.}"
  filename="${filename%.*}"
  OUTPUT="$(pwd)/$filename-signed.$extension"
fi

if [ "$KEY" == "" ];then
  KEY="testkey"
fi

WORKING_DIR="$(pwd)"
SCRIPT_DIR="$(dirname $(realpath $0))"

echo "Sign $INPUT as $OUTPUT ..."
java -Xmx4096m -jar $SCRIPT_DIR/signapk.jar -w $SCRIPT_DIR/$KEY.x509.pem $SCRIPT_DIR/$KEY.pk8 "$INPUT" "$OUTPUT"
return="$?"

if [ $return -eq 0 ];then
  echo "Successful!"
  exit 0
fi

exit $return

