# About Personal Finances

Ruby project - sinatra/puma backed server to visualize your personal finances.

## Installation

```
bundle install
rake
```

The first time you rake it'll ask you for a password.
After the password is set you can just start this application with `rake`.
By default the dashboard is available at  <http://localhost:12345>

## Creating a profile

Profiles are stored in the data/ directory. The filename must end with '.yml'.
Annotated example below.

This yml template generates the following graph:

![alt text](https://s3-eu-west-1.amazonaws.com/personalfinancestool/example-output.png "Output")

```yaml
---
- balance: 0                      # Initial balance
- salary:                         # Category, isn't used. It's so you know what's what.
    amount: 2500                  # Amount
    period: monthly               # Period can be monthly, once or yearly
    modifier: plus                # Modifier can be plus or minus
    growth: 3                     # Annual (positive or negative) growth of amount (percent)
- fun:
    amount: 500
    period: monthly
    modifier: minus
    except: "May 2017,June,2018"  # Except for May 2017, June (any year) and the whole of 2018
- rent:
    amount: 750
    period: monthly
    modifier: minus
- insurance:
    amount: 200
    period: monthly
    modifier: minus
    growth: 10
- food:
    amount: 300
    period: monthly
    modifier: minus
    growth: 3
- bonus:
    amount: 3000
    modifier: plus
    period: yearly
    month: 5                      # Month of the year this event happens
    except: "2017"                # But not in 2017 :(
- new_car:
    amount: 25000
    modifier: minus
    period: once
    month: 5
    year: 2019                    # Spend a shitload of money in May 2019!
```

### Access management

When you first run rake and you didn't set a password yet, you'll be prompted to set a password. If you need to change your password type `rake passwd`. The credentials are stored in .env.private. Your username is always `admin`. Remember to restart this application if you modify your password.

### Accessing profiles

Our data/example.yml profile is available at <http://localhost:12345/example>
By default, it displays a projection of 5 years. To render a projection for 10 years you would postpend /10 to the URL: <http://localhost:12345/example/10>

### License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
