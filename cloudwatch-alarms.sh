#!/bin/bash

#Creator : Blesson Jacob
#Version : 1.0
#Description : Alarm for cloudfront


DISTRIBUTION_ID=$1
SERVICE=cloudfront

aws cloudwatch put-metric-alarm --alarm-name $DISTRIBUTION_ID-$SERVICE-5xxErrorRate --alarm-description "Alarm when the 5xxErrorRate error rate exceeds 0" --metric-name 5xxErrorRate --namespace AWS/CloudFront --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold --dimensions "Name=DistributionId,Value=$DISTRIBUTION_ID" --evaluation-periods 2 --alarm-actions arn:aws:sns:us-east-1:953191494045:new --unit Percent
