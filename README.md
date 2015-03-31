# Ruboty::TwitterSearch [![Build Status](https://travis-ci.org/r7kamura/ruboty-twitter_search.svg)](https://travis-ci.org/r7kamura/ruboty-twitter_search) [![Code Climate](https://codeclimate.com/github/r7kamura/ruboty-twitter_search/badges/gpa.svg)](https://codeclimate.com/github/r7kamura/ruboty-twitter_search) [![Test Coverage](https://codeclimate.com/github/r7kamura/ruboty-twitter_search/badges/coverage.svg)](https://codeclimate.com/github/r7kamura/ruboty-twitter_search)
[Ruboty](https://github.com/r7kamura/ruboty-twitter_search) plug-in to search twitter.

## Usage
Search with given query and show tweet URLs.  
(Note: `since_id` will be stored in ruboty's brain to same query by default)

```
@ruboty search twitter by <query>
```

### Example
```
@ruboty search twitter by sushi
@ruboty search twitter by sushi fav:10
@ruboty search twitter by sushi retweet:20
@ruboty search twitter by sushi result_type:popular
@ruboty search twitter by sushi result_type:mixed
```

## ENV
```
TWITTER_ACCESS_TOKEN        - Twitter access token
TWITTER_ACCESS_TOKEN_SECRET - Twitter access token secret
TWITTER_CONSUMER_KEY        - Twitter consumer key (a.k.a. API key)
TWITTER_CONSUMER_SECRET     - Twitter consumer secret (a.k.a. API secret)
TWITTER_DISABLE_SINCE_ID    - Pass 1 to disable using since_id parameter (optional)
```
