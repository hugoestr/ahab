title: What I learned about Elixir by writing a static site generator 
summary: A collection of things that I learned by doing this exercise 
tags: elixir
published: date_stub
---

As part of my journey in learning Elixir, I decided to write a small proof-of-concept static content generator. These kinds of projects can be very small and easy to do when you are short of time. 

This is a quick list of what I have learned while working on this short project.

## The requirements

The requirements are simple. The application should give me the ability to setup the site structure, create drafts, and publish them. That is all what I wanted to build to begin with.

I wanted to have a command line interface that would do these tasks.

## Mix tasks

One of my favorite ruby features is rake. I have never used it as a make, but I have used it to create command line tasks. What I like the most is how easy it is to write these tasks.

Elixir has mix. Writing mix tasks is also easy, yet more verbose than writing them in Ruby. 

[Example ruby] [Example Elixir]

## How to run OS commands

In my experience being able to use OS commands from a language is useful for writing practical applications. 

Here Elixir gives us two options:

For simple os commands

System.cmd command, arguments

When you need to do something more elaborate on the shell that needs pipes and redirections

:os.cmd char_list_command

The idiom that I found useful is

"type NUL > newfile.txt" |> String.to_charlist |> :os.cmd


## Working with other libraries

A lot of early learning projects tends to be more of an exploration of the default libraries. Yet an important part of effectively using a language is to know the ecosystem of libraries that are available to the language so that they can be used when appropriate.

During this project I have learned to use yamerl and timex. 

Here I have ran into the problems of incompatible libraries working on different versions of the erlang vm, the beam. This is one of those problems that one must see them and remember them for the future. 

## Working directly with Erlang libraries

When reading books about Elixir, they often talk about how nice it is to be able to reach down and use erlang libraries directly. Although it is a cool idea to keep in mind, nothing matches actually having the experience of needed this. 

While working on the project I wanted to use yaml_elixir. Yet the published verison wouldn''t compile. To troubleshoot the problem, I had to work directly with the base library. 

Another praise for Elixir here: the interop is so simple that it is almost invisible. There was no pain using; there was no need to check books or search for blogs to tell me exactly how you are meant to do it.

## Adding documentation

Documentation is needed. Unfortunately it is often better not to have documentation than to have bad documentation. For years I have followed the philosophy that code should be self-documented. I still believe this. But my exposure to a course on programming where they stress the importance of documentation as a tool for function design and looking at how useful and easy to use Elixir documentation is changing my mine on this topic.

I can''t go into detail on this the position of the book, but the most important part is that documentation helps us clear our intent. This may sound familiar to those who know about TDD/BDD. And that is because tests are part of documentation.

Adding documentation in Elixir is easy. You use @moduledoc or @doc to add the documentation text. And Elixir''s documentation also has a page giving you guidelines on [https://hexdocs.pm/elixir/master/writing-documentation.html](Elixir''s writting documentation guide).

 
