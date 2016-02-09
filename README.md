# Integrating Models Sinatra Walkthrough

## Overview
In previous lessons, we've applied logic to data provided by the user directly in our application controller. While this works, it does not follow the principle of 'separation of concerns' - our files should do one thing and one thing only. In this code-along lesson, we'll learn how to move the logic to a model in a Sinatra application. By doing this, we'll create our first full Model-View-Controller application in Sinatra. We'll use input from a form to create an instance of a model, and then send that instance back to a view to be displayed to the user. As an example, we're going to create a web application that analyzes a block of text from the user - showing the number of words, most common letters, and least common letters used.

## Objectives
+ Create a model in Sinatra
+ Link to created models from the application controller
+ Create instances of a model in the application controller
+ Display data from instances of a model in a view

## Setup

To code along, fork and clone this lab. Run `bundle install` to make sure all of your dependencies are installed. 

### Starter Code
Let's take a closer look at the starter code. Run `shotgun` to make sure that your application can run.

#### Routes
+ The controller has two routes:
	+  `get '/' do`, which renders the `index.erb` page.
	+  `post '/results' do`, which receives the form data through params and renders the results page.

## Creating a Model

We could analyze all of the data from `params[:user_text]` in our application controller, but our route would get messy very quickly. Instead, let's create a new class inside of our `models` directory that will take care of the analysis of the text. In your `models` directory, create a new file called `textanalyzer.rb`.

We're not going to go deeply into creating models in this lesson, as you've covered it in depth in our unit on object oriented programming. Instead, paste the following code in to your `textanalyzer.rb` file:

```ruby

class TextAnalyzer

  def initialize(text)
    @text = text
  end

  def count_of_words
    words = @text.split(" ")
    words.count
  end

  def count_of_vowels
    @text.scan(/[aeoui]/).count
  end

  def count_of_consonants
    @text.scan(/[bcdfghjklmnpqrstvwxyz]/).count
  end

def most_used_letter
    s1 = @text.downcase.gsub(/[^a-z]/, '') #gets rid of spaces
    arr = s1.split('')
    arr1 = arr.uniq
    arr2 = {}
    arr1.map do |c| 
     arr2[c] =  arr.count(c)
    end
    biggest = { 
      :most_used_letter  => arr2.keys.first,
      :letter_count => arr2.values.first 
    }
    arr2.each do |key, value|
      if value > biggest.values[1]
        biggest = {
          :most_used_letter => "",
          :letter_count => ""
        }
        biggest[:most_used_letter] = key
        biggest[:letter_count] = value
      end
    end
    biggest
  end

end


```
The model above has an initializer which takes in a string `text` and saves it to an instance variable `@text`. This instance variable is then used in the four instance methods, which provide information on the block of text in question. If we wanted to use this class on its own, we could do the following:

```
my_text = TextAnalyzer.new("The rain in Spain stays mainly on the plain.")
my_text.count_of_words #=> 9
my_text.count_of_vowels #=> 13
my_text.count_of_consonants #=> 20
my_text.most_used_letter #=> ["n", 6]

```
In general our models are agnostic about the rest of our application - we could drop this class into a Command Line or Ruby on Rails app and it would function in the exact same way.


## Using a Model in the Controller
In order to use the model we've created in our controller we need to connect the two. To do this, we'll use the `require_relative` keyword to bring in the code from the model we've created. At the top of `app.rb`, add `require_relative "models/textanalyzer.rb"`. This now gives us the ability to create new instances of the TextAnalyzer class from within our controller.

Now, let's take the data from `params[user_text]` (in the `post '/' do` route) and feed it into a new instance of the`TextAnalyzer` class:

```ruby
post '/' do
  text_from_user = params[:user_text]
  @analyzed_text = TextAnalyzer.new(text_from_user)
  erb :results
end
```
We can shorten this to:

```
post '/' do
  @analyzed_text = TextAnalyzer.new(params[:user_text])
  erb :results
end
```
We now have the instance of `TextAnalyzer` saved to an instance variable called `@analyzed_text`. This means that we can call it and its methods from the results.erb view that is being rendered, using erb tags!

## Using Instance Variables in ERB

We've practiced this before. In our `results.erb` file, use erb tags to display the data stored in the `@analyzed_text` variable. Your end result should look something like this:

<img src="https://s3.amazonaws.com/learn-verified/text-analyzer.png">

## Full MVC
Congratulations! You've now created your first Sinatra app that uses a model, views, and a controller! You are taking user input in a form, sending it via params to the 'post' route where a new instance of the model is created using the data from the form. This instance is passed back to the view, where it is rendered using erb tags. Pat yourself on the back, this is a big milestone in your developer journey!
