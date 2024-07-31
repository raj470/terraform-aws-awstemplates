aws ecr get-login-password \
    --region <region> \
| docker login \
    --username AWS \
    --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

aws ecr get-login-password \
    --region us-east-1 \
| docker login \
    --username AWS \
    --password-stdin 058264186519.dkr.ecr.us-east-1.amazonaws.com


docker tag hello-world:latest aws_account_id.dkr.ecr.region.amazonaws.com/hello-repository







# define the name of the stream you want to read
KINESIS_STREAM_NAME='__your_stream_name_goes_here__';

# define the shard iterator to use
SHARD_ITERATOR=$(aws kinesis get-shard-iterator --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON --stream-name $KINESIS_STREAM_NAME --query 'ShardIterator');

# read the records, use `jq` to grab the data of the first record, and base64 decode it 
aws kinesis get-records --shard-iterator $SHARD_ITERATOR | jq -r '.Records[0].Data' | base64 --decode

SHARD_ITERATOR=$(aws kinesis get-shard-iterator --shard-id shardId-000000000002 --shard-iterator-type TRIM_HORIZON --stream-name KenesisStream --query 'ShardIterator');

aws kinesis get-records --shard-iterator $SHARD_ITERATOR | jq -r '.Records[0].Data' | base64 --decode


SHARD_ITERATOR=$(aws kinesis get-shard-iterator \
  --endpoint https://yds.serverless.yandexcloud.net \
  --shard-id shardId-000000000002 \
  --shard-iterator-type LATEST \
  --stream-name  KenesisStream\
  --query 'ShardIterator'| tr -d \")
aws kinesis get-records \
  --endpoint https://yds.serverless.yandexcloud.net \
  --shard-iterator $SHARD_ITERATOR


let items = event.Records.map( (record) => {
            let jsonData = new Buffer(record.kinesis.data, 'base64').toString('ascii');

