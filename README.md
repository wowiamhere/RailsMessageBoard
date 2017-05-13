![rails-pic][rails-pic]  

# [Ruby] On [Rails] Message Board  


<small>Follow at: **<a href="http://zencodemaster.com/coding-post/3" target="_blank">ZenCodeMaster.com**</a></small>

[Rails] is a very popular [MVC] framework.  

![mvc-pic][mvc-pic]

We are going to use it to let a user:  

- connect to a db
- create an account
- display other users
- display other users messages (root view)
- display single message with comments
- create a message (if logged in)
- create a comment to a message (if logged in)

We will be styling our message board with [Bootstrap].  

Lets begin.  

I am assumming that you have all the requirements installed:  

- ruby
- rails
- postgres  
(if using other databases, *configure config/database.yml accordingly*)


## 1. Crate a rails application via `rails new`  

Create a folder for the application and call it... anything you want;I'll use `railsmessageboard`  

```
rails new railsMessageBoard
```  

Initiate a [Git] repository  

```
git init
```  

then commit and do your first push.  








[Ruby]: https://www.ruby-lang.org/en/
[Rails]: http://rubyonrails.org/
[MVC]: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller`
[Bootstrap]: http://getbootstrap.com/getting-started/
[Git]: https://git-scm.com/

[rails-pic]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/rail.png
[mvc-pic]: https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/MVC-Process.svg/300px-MVC-Process.svg.png
[bootstrap-pic]: https://s3-us-west-2.amazonaws.com/zencodemaster/tutorials/railsmessageboard/bootstrap.png