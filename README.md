# melbourne_weather_notice

## 概要

毎朝8時（日本時間10時）に今日のメルボルン天気が送信されるLINE。

使用サービス

- OpenWeather
- 公式LINE
- AWS Lambda, CloudWatch Events, ECR

OpenWeatherの One Call API 3.0を使用して天気情報を取得し、Lambdaで公式ラインを送信

![line_oa_chat_230122_234024_group_0](https://user-images.githubusercontent.com/56143537/213916367-f27f5753-b03e-4ed8-84ea-242aa19e1e41.png)

## 環境構築

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
