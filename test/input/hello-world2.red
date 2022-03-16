Red [
	description: {"Hello World" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

output: "INTERNAL_OUTPUT"

hello: function [] [
	probe "debug"
	prin "debug"
	print "ging"
	probe output		; output should not leak from probe/print/prin functions
	"Hello, Universe!"
]

