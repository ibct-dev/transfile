#!/bin/bash

# 병합된 결과를 저장할 파일
output_file="node_modules.tar"

# 병합할 파일들 (순서를 보장)
files_to_merge=$(ls -v chunk_*.gz)

# 압축 해제 및 병합
> "$output_file"  # 기존 파일 초기화

for chunk in $files_to_merge; do
  # gzip 압축 해제
  gunzip -c "$chunk" >> "$output_file"
done

echo "원본 파일이 복원되었습니다: $output_file"

cd ../
tar -xvf transfile/node_modules.tar
tar -xvf transfile/dist.tar


echo "설치가 완료되었습니다."

cd transfile
rm node_modules.tar
