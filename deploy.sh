#!/bin/bash
echo '************    clean resource   ***********'
hexo clean
echo '************    generate resource   ***********'
hexo generate
echo '************    ssh to aws instance and clean old html   ***********'
ssh -i ~/.ssh/KeyForAWS.pem ec2-user@ec2-52-25-7-216.us-west-2.compute.amazonaws.com 'rm -rf /var/www/html/*'
echo '************    copy respurce to aws instance   ***********'
scp -i ~/.ssh/KeyForAWS.pem -r ~/non-work/blog/public/* ec2-user@ec2-52-25-7-216.us-west-2.compute.amazonaws.com:/var/www/html
echo '============    Done   ==========='
