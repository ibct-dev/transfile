#!/bin/bash
rm *.gz *.tar
tar -cvf dist.tar ../did-lit-api/dist
tar -cvf node_modules.tar ../did-lit-api/node_modules

# 압축할 원본 파일
input_file="node_modules.tar"

# 60MB 단위로 분할
split -b 200m "$input_file" "chunk_"

# 분할된 파일들을 gzip으로 압축
for chunk in chunk_*; do
  gzip "$chunk"
done

rm node_modules.tar

git add .
git commit -m "deploy did-lit-api"
git push
