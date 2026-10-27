[← Project overview](README.md)

# Selected Code Excerpts

Academic robotics project by Petros Charalampidis. Only the displayed parts of DMP training and integration are included; the full simulator and robot model are outside this public version.

These are short extracts from the original project, selected for this public
portfolio. Imports, surrounding modules, helper implementations, data and
execution setup are outside the displayed context. The extracts are not
standalone programs. Source paths identify their origin in the complete project.

## DMP forcing target and basis placement

A demonstrated trajectory supplies the forcing target. Gaussian basis functions are placed in the decaying phase coordinate; weight fitting appears elsewhere.

Source excerpt: `Part_2/dmp_train.m`, lines 21–26.

```matlab
f_target = tau^2 * ddy_demo - alpha_z*( beta_z*(g - y_demo) - tau*dy_demo );

tc = linspace(0, tau, N)';
c = exp(-alpha_s * tc / tau);
dc = abs(diff(c)); dc = [dc; dc(end)];
h = 1 ./ (dc.^2);
```

## Trajectory reproduction update

This fragment sits inside the integration loop. A normalized forcing term modifies the attractor dynamics, and Euler updates advance position, velocity state and phase.

Source excerpt: `Part_2/dmp_integrate.m`, lines 24–37.

```matlab
psi = exp(-h .* (ss - c).^2);
sumpsi = sum(psi);
if sumpsi > 1e-10
    f = sum(w .* psi .* ss) / sumpsi;
else
    f = 0;
end
zdot = ( alpha_z*(beta_z*(g - yy) - zz) + f*(g - y0) ) / tau;
ydot = zz / tau;
sdot = -alpha_s * ss / tau;

yy = yy + ydot*dt;
zz = zz + zdot*dt;
ss = ss + sdot*dt;
```
