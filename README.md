# packer-hcl

### AMI 등록 취소
# aws --profile default ec2 deregister-image --image-id  ami-095c4bc4c6c1c5653


### 스냅샷 조회(스냅샷 ID 조회)
### aws --profile default ec2 describe-snapshots --owner-ids self --query 'Snapshots[]'
# aws --profile default ec2 describe-snapshots --owner-ids self --filters Name=description,Values=* ami-095c4bc4c6c1c5653 --query 'Snapshots[*].{ID:SnapshotId}' --output text
### 스냅샷 삭제
# aws --profile default ec2 delete-snapshot --snapshot-id snap-1234567890abcdef0



# packer validate aws.pkr.hcl

# packer build -var="ami_dist=amazon2" aws.pkr.hcl
# packer build -var="ami_dist=ubuntu" aws.pkr.hcl
# -- packer build -var="ami_dist=ubuntu" -var-file=".pkrvars.hcl" aws.pkr.hcl
