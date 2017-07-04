# ORelations

ORelations is an implementation of object-relational-mapping to provide
a coherent wrapper for SQL. Its main objective is to minimize the
code needed for complex data model relations and create a library that
is simple, uniform and semantic.

## Key Features

ORelations allows classes to extend `SQLObject` and inherit its features:

- Variety of easy associations using simple methods like
  `belongs_to`
  `has_many`
  `has_one_through`
- the `SQLObject#all` method returns and array of all of a class's instances.
- the `SQLObject#save` method will update or insert and instance of a
  class based on whether an `id` is present.
- Calling `SQLObject#finalize!` at the end of a class will create getter
  and setter methods for each of the class's attributes.

## Example Usage

```ruby
require_relative 'sql_object'

class Species < SQLObject
  belongs_to :genus
  has_one_through :family, :genus, :family

  finalize!
end
```
