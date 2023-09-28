# Howard_Faster

These codes solve an income fluctuation problem using discretized value function iteration.
There are two state variables:
- **a** Endogenous state, e.g. asset holdings
- **z** Exogenous state, follows a Markov chain pi(z,z')
There is no choice variable (e.g. no endogenous labor supply)

The purpose of the codes is to show that with a simple reordering of loops in the Howard improvement, the VFI becomes significantly faster, especially when the number of points for the **z** grid is large.
- fun_vfi: implements the standard method
- fun_vfi2: implements the new method with modified Howard
The standard method follows closely Robert Kirkby's VFI toolkit, see https://www.vfitoolkit.com/
