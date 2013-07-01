
ITMAX = 154;

% Angle controller
pid_theta_com.state = degtorad(0.0);
pid_theta_com.state_all = pid_theta_com.state;
pid_theta_com.vel = 0.0;
pid_theta_com.vel_all = pid_theta_com.vel;
pid_theta_com.gain_prop = 0.5;
pid_theta_com.gain_int = 0.0;
pid_theta_com.gain_deriv = 0.0;
pid_theta_com.error = 0.0;
pid_theta_com.cum_error = 0.0;
pid_theta_com.diff_error = 0.0;
pid_theta_com.prev_error = pid_theta_com.error;
pid_theta_com.reference = degtorad(30);
it = 0;
interval_time = 0.1;

while it < ITMAX
    it = it + 1;

    pid_theta_com = apply_angle_controller(pid_theta_com,interval_time);
   
end

time = 0:interval_time:ITMAX*interval_time;
plot(time,radtodeg(pid_theta_com.state_all));
radtodeg(pid_theta_com.state_all(end))