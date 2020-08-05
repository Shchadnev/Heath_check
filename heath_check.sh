#!/bin/bash

datetime=$(date)

site_url = $my_site_url
slack_web_hook_url = $my_slack_web_hook_url
code=$(curl -o /dev/null -s -w "%{http_code}\n"   $site_url)

echo "$(date) check my site availability"

# Print your site http code
echo "$code"

if [[ $code != "200" ]]
 then
  echo "$datetime my site is down!"
  echo "Restarting Server"
  #sendind message to slack chanel
  curl -X POST -H 'Content-type: application/json' --data '{"text":" My site down detected. Restarting service. :hourglass_flowing_sand:"}' $slack_web_hook_url
  systemctl restart my_site.service

  sleep 30

  newcode=$(curl -o /dev/null -s -w "%{http_code}\n" $site_url)

  if [[ $newcode = "200" ]]
   then
    echo "$(date) My site sucssefuly UP!"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"My site successfuly UP! :heavy_check_mark:"}' $slack_web_hook_url
    exit
   else
    echo "$(date) My site restarting fail."
    curl -X POST -H 'Content-type: application/json' --data '{"text":"My site restart fail = ( "}' $slack_web_hook_url
    exit
  fi
fi
