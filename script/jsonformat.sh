#!/bin/bash
# Magic string is extracted here
declare -r SPACING="      "
declare -r DAY_TAG="              \"day\":"
declare -r HOUR_TAG="              \"hour\":"
declare -r VALUE_TAG="              \"value\":"

resp=$(curl https://api.github.com/repos/tungnk1993/scrapy/stats/punch_card)
nextPref="$SPACING"

# Replace all [ to { and ] to }
resp=${resp//\[/\{}
resp=${resp//\]/\}}

# Restore beginning and ending []
resp=${resp/#\{/\[}
resp=${resp/%\}/\]}

answer=""

for val in $resp
    do
        # Hack to prevent space from appearing in front of [, or ]
        if [[ $val == "[" || $val == "]" ]]
        then
            echo "$val"
        else
            echo "$nextPref $val"
        fi

        if [[ $val == "{" && $nextPref == "" ]]
        then
            nextPref="$SPACING"
        elif [[ $val == "{" && $nextPref == "$SPACING" ]]
        then
                nextPref="$DAY_TAG"
        elif [[ $nextPref == "$DAY_TAG" ]]
        then
            nextPref="$HOUR_TAG"
        elif [[ $nextPref == "$HOUR_TAG" ]]
        then
            nextPref="$VALUE_TAG"
        elif [[ $nextPref == "$VALUE_TAG" ]]
        then
            nextPref="$SPACING"
        fi
done

echo "$answer"