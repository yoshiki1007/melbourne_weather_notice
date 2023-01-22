# melbourne_weather_notice

image 作成

```zsh
docker build -t melbourne_weather_notice .
```

タグをつけて image 作成

```zsh
docker tag melbourne_weather_notice:latest ${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com/melbourne_weather_notice:latest
```

ECR ログイン

```zsh
aws ecr get-login-password  --profile ${AWSPROFILE} | docker login --username AWS --password-stdin ${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com
```

ECR プッシュ

```zsh
docker push ${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com/melbourne_weather_notice:latest
```

Lambda 実行

```zsh
aws lambda invoke --function-name melbourne_weather_notice_docker output ; cat output
```
