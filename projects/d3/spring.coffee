class Component
  constructor: (@name, @children) ->

p1 = new Component 'ApplicationContext'

root = new Component 'BeanFactory', [p1, p2, p3]

console.log JSON.stringify spring, null, '\t'
