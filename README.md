
#Tiny Tines
##By aaron.shortt@me.com
### About
####Prerequisites 
Have Ruby 3.0.1, a valid and support tiny-tines story file in JSON format. 

#### Known Bugs
- None, yet. 
- Weird that output() is playing up and not picking up my puts in the PrintActions specs. Have done a workaround for testing purposes
- 


###Blog

####Before:
Before kicking off work I setup my environment, Im using a fresh install of windows using WSL. I setup Ruby on the instance
and configured Rubymine, setup RuboCop and then read the rest of spec, 

Stand out requirements for me are that is _should_ remain a command line application, despite my first instinct to create a little
rails app that you upload the file to like **Big Tines**. I could host it neatly on a github deploy, but the spec is very specific.

####Starting Development
Focused on first running version addressing complex problems like dynamic interpolation, and data collection and allowing actions to flow together. I think story and 
event could be interchangeable. I think if I was taking this further event would be an encapsulating class over story 
that contains meta info about when the event ran, who started it etc. The Story class is really just a queue. 