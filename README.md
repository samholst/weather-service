# README

If `config/master.key` file is need, create the file with value `dfa16bb2caccf02b8d5348e53d5b8235`.

My intent is to name the methods used in the project as a way to self document what the method does and it's purpose.
In the circumstance it may not be clear by the method name alone, it will have a comment above the method. 

I've incorporated Grape::API due to its inherent structure, ability to self document, and create a clean way
of generating and maintaing API's.

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

## Local Viewing

There is a simple UI to retrieve information as needed. The application was designed to be consumed as an API and
not a web facing client.

GET:
```
localhost:3000/
```

### Send address endpiont

Use a tool such as Postman to receive an API response back. Don't forget to include the `x-api-key` when doing so.

POST: 
```
localhost:3000/api/v1/weather/address?address=One Apple Park Way, Cupertino, CA 95014
```
