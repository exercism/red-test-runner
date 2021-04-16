Red [
	description: {"Hello World" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

greet-the-world: function [] [
	print "debugging"
	append output "RUNNER NOT ISOLATED"		; should generate error, access to 
											; isolated test-runner context should be impossible
	"Hello, Universe!"
]
