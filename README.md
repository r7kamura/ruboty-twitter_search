# Ruboty::TwitterSearch [![Build Status](https://travis-ci.org/r7kamura/ruboty-twitter_search.svg)](https://travis-ci.org/r7kamura/ruboty-twitter_search)
[Ruboty](https://github.com/r7kamura/ruboty-twitter_search) plug-in to search twitter.

## Usage
```
@ruboty search twitter by <query>
```

### Example
```
$ bundle exec ruboty --dotenv
Type `exit` or `quit` to end the session.
> @ruboty search twitter by sushi
https://twitter.com/meshiumaa/status/573806861956214786
https://twitter.com/yijinglai/status/573806872169291777
https://twitter.com/bone_sushi/status/573806877340893184
https://twitter.com/namaakubi_/status/573806888015388672
https://twitter.com/NIGIRE_sushi/status/573806891211452416
https://twitter.com/Rymdensbarn/status/573806901722488832
https://twitter.com/SmaltimoreMD/status/573806917316968448
https://twitter.com/ornat/status/573806982852968448
https://twitter.com/kelZoom/status/573806985805754368
https://twitter.com/DT_Hanmer/status/573807032286973952
> @ruboty search twitter by sushi
https://twitter.com/Sushi_sweetegg/status/573807039224279040
> @ruboty search twitter by sushi
>
```

## ENV
```
TWITTER_ACCESS_TOKEN        - Twitter access token
TWITTER_ACCESS_TOKEN_SECRET - Twitter access token secret
TWITTER_CONSUMER_KEY        - Twitter consumer key (a.k.a. API key)
TWITTER_CONSUMER_SECRET     - Twitter consumer secret (a.k.a. API secret)
TWITTER_DISABLE_SINCE_ID    - Pass 1 to disable using since_id parameter (optional)
```
