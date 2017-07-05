# ORelations

ORelations is an implementation of object-relational-mapping providing
a coherent wrapper for SQL. Its main objective is to minimize the
code needed for complex data model relations and create a library that
is simple, uniform and semantic.

## Key Features

ORelations allows classes to inherit `SQLObject` and its features including:

- Variety of easy associations using simple methods like
  `belongs_to`
  `has_many`
  `has_one_through`
- `SQLObject#all` method that returns an array of all a class's instances.
- `SQLObject#save` method that will update or insert an instance of a
  class based on whether an `id` is present.
- searching tables by passing params to `SQLObject#where`
  (e.g. `Species.where({ name: 'catus' })`).
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
