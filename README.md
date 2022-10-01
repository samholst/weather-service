# README

If `config/master.key` file is need, create the file with value `dfa16bb2caccf02b8d5348e53d5b8235`.

## Tests

Run:

```
be rails test
```

## Setup

Run:

```ruby
bundle install
rails db:create
rails db:migrate
rails db:seed

rails s
```

Enter `rails c` and grab `User.first.access_keys.first.token`.

Or use this static API key `0241779ada9b54f47227` after running `rails db:seed` on local or on production.

Use any tool of your choice to send API requests. Just make sure the
request has a `x-api-key` header of the above key or any generated ones.

## Local Testing

GET:
```
localhost:3000/
```

### Send message endpiont

POST: 
```
localhost:3000/api/v1/weather/address?address=One Apple Park Way, Cupertino, CA 95014
```
