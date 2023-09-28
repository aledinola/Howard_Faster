# Howard_Faster

These codes solve an income fluctuation problem using discretized value function iteration.
There are two state variables:
- a Endogenous state, e.g. asset holdings
- z Exogenous state, follows a Markov chain pi(z,z')
There is no choice variable (e.g. no endogenous labor supply)

The purpose of the codes is to show that with a simple reordering of loops in the Howard improvement, the VFI becomes significantly faster, especially when the number of points for the z grid is large.
The codes are largely based on Robert Kirkby's VFI toolkit, see https://www.vfitoolkit.com/
