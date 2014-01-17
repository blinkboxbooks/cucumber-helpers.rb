# Cucumber::Helpers

A collection of helpers for cucumber tests we use at blinkbox books.

## Installation

Add this line to your application's Gemfile:

    gem 'cucumber-helpers'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cucumber-helpers

## Usage

### Typed object initialisation with Tables

Occasionally you'll want to create an object with specific attributes, or test that the attributes that are present are of a particular data type. In Gherkin there is no defined way to specify the type of a named object, because Gherkin is a business language.

This helper provides a mechanism to define attributes in a business-friendly manner and step helpers to convert them to the key names your code uses.

#### Examples

Let's say you have the following gherkin:

```gherkin
Given that a user exists with the following attributes:
  | attribute            | type   | value             | description                           |
  | First Name           | String | Sherlock          | The user's first name                 |
  | Last Name            | String | Holmes            | The user's last name                  |
  | Date of Birth        | Date   | 1999-12-31        | The user's birth date                 |
  | Address: First Line  | String | 221B Baker Street | The first line of the user's address  |
  | Address: Second Line | String | London            | The second line of the user's address | 
  | Address: Postcode    | String | NW1 6XE           | The user's postcode                   |
  | Number of Pipes      | Number | 12                | The number of pipes the user owns     |
```

And the following step definition:

```ruby
# TBC
```

The default attribute mapper will generate a hash (`attribute_hash`) that looks like this:

```ruby
{
  "first_name"      => "Sherlock",
  "last_name"       => "Holmes",
  "date_of_birth"   => #<Date: 1999-12-31 ((2451544j,0s,0n),+0s,2299161j)>,
  "address"         => {
    "first_line"  => "221B Baker Street",
    "second_line" => "London",
    "postcode"    => "NW1 6XE"
  },
  "number_of_pipes" => 12
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
