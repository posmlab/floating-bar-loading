# Floating Bar Loading Dynamics
## Contents
1. [Introduction](#introduction)
2. [System Setup](#system-setup)
3. [Finding Equilibrium (or trying to)](#finding-equilibrium-numerically)
4. [Giving Up And Just Solving The ODEs](#solving-the-dynamics)
5. [Explanation of Codebase](#code-guide)

## Introduction
In the mantis shrimp raptorial appendage, force is transferred from actuators (muscles and springs) to the load (the propodus and/or dactyl) by a set of linked bars... we think. However, before we can understand how a four-bar linkage transmits force, we need to figure out how these muscles and springs act on a bar to alter its position and orientation. Here are some potentially interesting questions to explore:

1. How does the relative mechanical advantage of the flexor muscle (which is weak, but far from the pivot and nearly perpendicular to the bar) help "latch" the system?
2. How do different patterns of activation affect the loaded position?
3. What happens if you change the relative positions of the springs and muscles, place them in series, or remove one of the springs altogether?
4. How does a nonlinear spring change loading and unloading? Does the form of the nonlinearity matter?

While this seems like an initially straightforward mechanics problem (find force and torque, set them to zero, profit!), we quickly run into some issues:
1. The actuators do not put out constant forces, but rather exert a force dependent on their own extension, which itself depends in a complicated way on the position and orientation of the bar.
2. The direction of the force is not constant, since as the bar moves the orientation of the actuator is altered.
3. Depending on the angles of the actuators, there may be directions where the bar can move without requiring any additional force at all, complicating attempts to numerically find the equilibrium points.
4. The equations of motion are those of an undamped oscillator, so directly solving Newton's second law does not give a solution that asymptotically approaches equilibrium.

To try to address challenges 1 and 2, I have given up on writing the equations of motion in a single line and instead given them as a set of vector algebra calculations that MATLAB can handle. To handle challenge 3, I have focused on more local methods of root-finding (i.e. ones that follow the path of the motion rather than searching the whole state space for a minimum). The farthest I've gotten so far is to just solve the equations of motion numerically and see where they end, but frankly that's just raised more questions than answers. I haven't had time to do much digging this summer, but I hope that I've managed to unearth enough interesting things that you (Avalon and/or other future posm) can do a project you're excited about and learn lots of cool stuff!
## System Setup
For an in-depth description of our model setup and how we determine the forces and torques on the bar, see [this pdf](derivation.pdf).
## Finding Equilibrium Numerically
Once we have our net force and torque. we can (presumably) find the equilibrium point that the bar will load to by just setting all of them equal to zero. This yields a set of nonlinear equations that MATLAB should, in theory, be able to solve. However, the fsolve and fminimax functions are often extremely finicky and either fail to converge, converge to nonsense answers, or converge to a value that is highly dependent on the initial conditions. To try and deal with the strange black-box behavior of the MATLAB solvers, I wrote my own that essentially played the high-low game of evaluating the sum of squares of the net forces and torque over a 3-D mesh of values for the state vector X and recursively seeking the lowest value. However, this method ran into the problem of breaking ties when multiple points were available that had the same net force. For example, in the simple case of four vertical actuators, all attached to the center of mass, pulling on a horizontal bar (so that there is no net torque and the equilibrium state is (0,F/k,0)), there is actually a circle of allowed equilibrium points that all have zero net force. However, only one of these will actually be approached, as dictated by the full dynamics. The "high-low" style solver does not follow Newton's second law (i.e. it doesn't trace out the actual trajectory of the system). so it will somewhat randomly decide on some point on the circle. This makes it very difficult for us to discern interesting patterns in the final states. While the example I've given is a bit too simplified to be realistic, we see similar patterns in more complicated cases.
## Solving the Dynamics
Frustrated by the computational weirdness of the direct root-finding approach, I decided to just give up and try and solve for the full trajectory of the system until it reached equilibrium. For a description of the math behind this, see [this pdf](odes.pdf).
## Code Guide
In this repository are the four functions that I believe will be useful for a full-numerics approach to the floating-bar problem. In all cases where data for different actuators appear in the same array (as in a matrix of force vectors), the columns are ordered [ES, EM, FS, FM].
1. spring_exts.m- Determines the extensions of all actuators and returns them as row vector. See function for input argument descriptions
2. bar_forces.m- Determines the net force and torque on the bar for a given state. Input arguments are the same as for spring_exts, except for the row vector force_pars, which is a vector of maximum forces (for muscles) or stiffnesses (for springs).
3. odeeq.m- Returns the final state (y) and ode45 solution structure (sol) from integrating forward the equations of motion.
4. mesh_ICs.m (script)- Solves the equations of motion for an evenly-spaced 3D grid of initial conditions. Good for visualizing the points (or other structures) toward which trajectories are attracted.
