using Convex, SCS, Gadfly

# Some constraints on our motion
# The object should start from the origin, and end at rest
initial_velocity = [-20; 100]
final_position = [100; 100]

T = 100 # The number of timesteps
h = 0.1 # The time between time intervals
mass = 1 # Mass of object
drag = 0.1 # Drag on object
g = [0, -9.8] # Gravity on object

# Declare the variables we need
position = Variable(2, T)
velocity = Variable(2, T)
force = Variable(2, T - 1)

# Create a problem instance
mu = 1
constraints = []

# Add constraints on our variables
for i in 1 : T - 1
  constraints += position[:, i + 1] == position[:, i] + h * velocity[:, i]
end

for i in 1 : T - 1
  acceleration = force[:, i]/mass + g - drag * velocity[:, i]
  constraints += velocity[:, i + 1] == velocity[:, i] + h * acceleration
end

# Add position constraints
constraints += position[:, 1] == 0
constraints += position[:, T] == final_position

# Add velocity constraints
constraints += velocity[:, 1] == initial_velocity
constraints += velocity[:, T] == 0

# Solve the problem
problem = minimize(sumsquares(force))
solve!(problem, SCSSolver(verbose=0))

pos = evaluate(position)
p = plot(
  layer(x=[pos[1, 1]], y=[pos[2, 1]], Geom.point, Theme(default_color=color("blue"))),
  layer(x=[pos[1, T]], y=[pos[2, T]], Geom.point, Theme(default_color=color("green"))),
  layer(x=pos[1, :], y=pos[2, :], Geom.line(preserve_order=true)),
  Theme(panel_fill=color("white"))
)
