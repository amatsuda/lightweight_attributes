# lightweight_attributes

lightweight_attributes is a tiny monkey-patch for making Active Record model objects ultimately lightweight.


## Benchmarks

Here's a result of a simple benchmark measuring memory usage, number of method calls, and execution time with and without this gem, for fetching 10,000 records from a MySQL database and iterating over each of them and reading each attribute.
The benchmark is included in this repo so everyone can try.

### Allocated Memory and Allocated Objects

lightweight_attributes halves the memory allocation and reduces the object creation to be 25%!

```
$ bundle e ruby benchmark.rb memory
****************************** ActiveModel::AttributeSet ******************************
Total allocated: 26969712 bytes (270001 objects)
Total retained:  24649712 bytes (260001 objects)

allocated memory by class
-----------------------------------
  12800000  Hash
   8000000  ActiveModel::Attribute::FromDatabase
   3600000  String
   1200000  Model
    880000  ActiveModel::LazyAttributeHash
    400000  ActiveModel::AttributeSet
     89712  Array

allocated objects by class
-----------------------------------
    100000  ActiveModel::Attribute::FromDatabase
     90000  String
     50000  Hash
     10000  ActiveModel::AttributeSet
     10000  ActiveModel::LazyAttributeHash
     10000  Model
         1  Array


****************************** LightweightAttributes ******************************
Total allocated: 14889712 bytes (70001 objects)
Total retained:  12569712 bytes (60001 objects)

allocated memory by class
-----------------------------------
  12800000  Hash
   1200000  Model
    800000  LightweightAttributes::AttributeSet
     89712  Array

allocated objects by class
-----------------------------------
     50000  Hash
     10000  LightweightAttributes::AttributeSet
     10000  Model
         1  Array

```

### Number of Method Calls

lightweight_attributes reduces method calls to be less than 40%!

```
$ bundle e ruby benchmark.rb methods
****************************** ActiveModel::AttributeSet ******************************
{"ActiveRecord::Result#each"=>1,
 "ActiveRecord::Result#hash_rows"=>1,
 "ActiveRecord::Persistence::ClassMethods#instantiate"=>10000,
 "ActiveRecord::Inheritance::ClassMethods#discriminate_class_for_record"=>10000,
 "ActiveRecord::Inheritance::ClassMethods#using_single_table_inheritance?"=>10000,
 "ActiveRecord::ModelSchema::ClassMethods#inheritance_column"=>20000,
 "Object#present?"=>10000,
 "NilClass#blank?"=>10000,
 "ActiveRecord::Persistence::ClassMethods#discriminate_class_for_record"=>10000,
 "ActiveRecord::ModelSchema::ClassMethods#attributes_builder"=>10000,
 "ActiveModel::AttributeSet::Builder#build_from_database"=>10000,
 "ActiveModel::LazyAttributeHash#initialize"=>10000,
 "ActiveModel::AttributeSet#initialize"=>10000,
 "ActiveRecord::Core::ClassMethods#allocate"=>10000,
 "ActiveRecord::AttributeMethods::ClassMethods#define_attribute_methods"=>20000,
 "ActiveRecord::Core#init_with"=>10000,
 "#<Class:ActiveRecord::LegacyYamlAdapter>#convert"=>10000,
 "ActiveRecord::ModelSchema::ClassMethods#yaml_encoder"=>10000,
 "ActiveModel::AttributeSet::YAMLEncoder#decode"=>10000,
 "ActiveRecord::Aggregations#init_internals"=>10000,
 "ActiveRecord::Associations#init_internals"=>10000,
 "ActiveRecord::Core#init_internals"=>10000,
 "ActiveRecord::Base#_run_find_callbacks"=>10000,
 "ActiveSupport::Callbacks#run_callbacks"=>20000,
 "ActiveRecord::Base#__callbacks"=>20000,
 "#<Class:ActiveRecord::Base>#__callbacks"=>20000,
 "ActiveSupport::Callbacks::CallbackChain#empty?"=>20000,
 "ActiveRecord::Base#_run_initialize_callbacks"=>10000,
 "ActiveRecord::AttributeMethods::PrimaryKey#id"=>10000,
 "ActiveRecord::Transactions#sync_with_transaction_state"=>10000,
 "ActiveRecord::Transactions#update_attributes_from_transaction_state"=>10000,
 "ActiveRecord::AttributeMethods::PrimaryKey::ClassMethods#primary_key"=>10000,
 "ActiveRecord::AttributeMethods::Read#_read_attribute"=>100000,
 "ActiveModel::AttributeSet#fetch_value"=>100000,
 "ActiveModel::AttributeSet#[]"=>100000,
 "ActiveModel::LazyAttributeHash#[]"=>100000,
 "ActiveModel::LazyAttributeHash#assign_default_value"=>100000,
 "#<Class:ActiveModel::Attribute>#from_database"=>100000,
 "ActiveModel::Attribute#initialize"=>100000,
 "ActiveModel::Attribute#value"=>100000,
 "ActiveModel::Attribute::FromDatabase#type_cast"=>100000,
 "ActiveModel::Type::Integer#deserialize"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c613"=>10000,
 "ActiveModel::Type::Value#deserialize"=>90000,
 "ActiveModel::Type::Value#cast"=>90000,
 "ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::MysqlString#cast_value"=>90000,
 "ActiveModel::Type::String#cast_value"=>90000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c623"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c633"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c643"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c653"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c663"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c673"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c683"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c693"=>10000}


****************************** LightweightAttributes ******************************
{"ActiveRecord::Result#each"=>1,
 "ActiveRecord::Result#hash_rows"=>1,
 "ActiveRecord::Persistence::ClassMethods#instantiate"=>10000,
 "ActiveRecord::Inheritance::ClassMethods#discriminate_class_for_record"=>10000,
 "ActiveRecord::Inheritance::ClassMethods#using_single_table_inheritance?"=>10000,
 "ActiveRecord::ModelSchema::ClassMethods#inheritance_column"=>20000,
 "Object#present?"=>10000,
 "NilClass#blank?"=>10000,
 "ActiveRecord::Persistence::ClassMethods#discriminate_class_for_record"=>10000,
 "ActiveRecord::ModelSchema::ClassMethods#attributes_builder"=>10000,
 "LightweightAttributes::AttributeSet::Builder#build_from_database"=>10000,
 "LightweightAttributes::AttributeSet#initialize"=>10000,
 "ActiveRecord::Core::ClassMethods#allocate"=>10000,
 "ActiveRecord::AttributeMethods::ClassMethods#define_attribute_methods"=>20000,
 "ActiveRecord::Core#init_with"=>10000,
 "#<Class:ActiveRecord::LegacyYamlAdapter>#convert"=>10000,
 "ActiveRecord::ModelSchema::ClassMethods#yaml_encoder"=>10000,
 "ActiveModel::AttributeSet::YAMLEncoder#decode"=>10000,
 "ActiveRecord::Aggregations#init_internals"=>10000,
 "ActiveRecord::Associations#init_internals"=>10000,
 "ActiveRecord::Core#init_internals"=>10000,
 "ActiveRecord::Base#_run_find_callbacks"=>10000,
 "ActiveSupport::Callbacks#run_callbacks"=>20000,
 "ActiveRecord::Base#__callbacks"=>20000,
 "#<Class:ActiveRecord::Base>#__callbacks"=>20000,
 "ActiveSupport::Callbacks::CallbackChain#empty?"=>20000,
 "ActiveRecord::Base#_run_initialize_callbacks"=>10000,
 "ActiveRecord::AttributeMethods::PrimaryKey#id"=>10000,
 "ActiveRecord::Transactions#sync_with_transaction_state"=>10000,
 "ActiveRecord::Transactions#update_attributes_from_transaction_state"=>10000,
 "ActiveRecord::AttributeMethods::PrimaryKey::ClassMethods#primary_key"=>10000,
 "ActiveRecord::AttributeMethods::Read#_read_attribute"=>100000,
 "LightweightAttributes::AttributeSet#fetch_value"=>100000,
 "ActiveModel::Type::Integer#deserialize"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c613"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c623"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c633"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c643"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c653"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c663"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c673"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c683"=>10000,
 "#<ActiveRecord::AttributeMethods::GeneratedAttributeMethods:0x00007fcb5c4e06b8>#__temp__36f6c693"=>10000}
```

### Elapsed Time

lightweight_attributes makes it 4x faster!

```
$ bundle e ruby benchmark.rb time
****************************** ActiveModel::AttributeSet ******************************
1.590478

****************************** LightweightAttributes ******************************
0.384524
```

## Installation

Just bundle `'lightweight_attributes'` gem on your Rails apps, and you're all set. No configurations!


## Usage

It just works. I said, no configurations.
This gem changes Active Record's data structure without changing any public API, so you don't need to change any single line of code in your application.
If bundling this gem introduces any incompatibility besides making things fast and less memory-consuming, that should be a bug.


## Why ActiveRecord::Base Is Slow and Heavy, and How This Gem Makes It Fast and Lightweight?

### The Active Record Object

Active Record model object is a super hero that plays multiple roles.
One is "form object". For this use case, we usually create just one object per request, so we don't have to care about performance of this object.

Another use case is "data transfer object". For this purpose, we would create hundreds of objects for rendering one HTML page. We would even create millions of model objects for APIs or batch systems.
In this case, size of each object deeply impacts the whole system performance.

### The Attribute API

As a version 4.0 feature, Active Record eqiupped a new API named "attributes API" that handles type casting between user, application, and database.
However, this new feature caused a significant performance regression.
For that purpose, each attribute per each model instance holds an instance of `Attribute` object that handles all the heavy lifting works around type casting.

Because of that data structure, ActiveRecord::Base became a super fat and heavy object. For example, when instantiating 1,000 records having 10 columns, it internally creates 10,000 instances of`Attribute` objects.
This of course causes a massive GC pressure.

### The Solution

This gem defers the creation of attribute objects in a particular use case.

For the "data transfer object" use case, what we really need is a read-only Struct like object. We don't need interactive type casting feature. We don't need dirty tracking feature. lightweight_attributes focuses on this use case. It's a set of monkey-patches that holds the set of data from DB in a single Hash object rather than an Array of Attribute objects.

This behavior is base on an assumption that AR model objects from database are "read only" in most cases. There could still be some cases where a model from database receives attribute writes (e.g. for `update` action). And for such cases, our attributes object takes "deoptimization" approach. When this Hash-based model object receives any attribute write, it metamorphses to be a normal attribute-based model object, then falls back to the original Active Record attributes API.


## Contributing

Pull requests are welcome on GitHub at https://github.com/amatsuda/lightweight_attributes.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Sponsor

This gem has been developed under total financial support from [Akatsuki Inc.](https://github.com/aktsk).
