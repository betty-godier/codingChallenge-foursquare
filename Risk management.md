#  Risk management

## Minimizing risk in the codebase by testing all scenarios (including error, invalid and unhappy paths)

By testing the representable paths of URLSession’s completion block (a private library we don’t own), regardless of the paths being valid or invalid, we made the codebase more resilient.

When using 3rd-party frameworks, it's advised to add extra tests to validate assumptions. Plus, when there is a new version of the framework, we can happily upgrade and verify if the changes broke our assumptions/expectations.

For example, the URLSession behavior for failed requests changed on iOS 14.

Since iOS 14, the URLSession replaces errors with a new error instance containing the data task in the userInfo dictionary.



| Data?       |   URLResponse?   |    Error?      | Representable state | 
|-------------|:----------------:|:--------------:|:-------------------:|
|    nil      |     nil          |      nil       |       invalid       |
|    nil      |   URLResponse    |      nil       |       invalid       |   
|    nil      | HTTPURLResponse  |      nil       |       invalid       |      
|    value    |     nil          |      nil       |       invalid       |  
|    value    |     nil          |      value     |       invalid       |
|    nil      |   URLResponse    |      value     |       invalid       |
|    nil      | HTTPURLResponse  |      value     |       invalid       |
|    value    |   URLResponse    |      value     |       invalid       |  
|    value    | HTTPURLResponse  |      value     |       invalid       | 
|    value    |   URLResponse    |      nil       |       invalid       |    
|    value    | HTTPURLResponse  |      nil       |        valid        |     
|    nil      |     nil          |      value     |        valid        | 
