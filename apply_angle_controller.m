function pid_theta_com = apply_angle_controller(pid_theta_com,time)

pid_theta_com.error = pid_theta_com.reference - pid_theta_com.state;
pid_theta_com.cum_error = pid_theta_com.cum_error + pid_theta_com.error*time;
pid_theta_com.diff_error = (pid_theta_com.error - pid_theta_com.prev_error)*time;
pid_theta_com.vel = pid_theta_com.gain_prop*pid_theta_com.error + ...
                    pid_theta_com.gain_int*pid_theta_com.cum_error + ...
                    pid_theta_com.gain_deriv*pid_theta_com.diff_error;
pid_theta_com.prev_error = pid_theta_com.error;                    
pid_theta_com.state = pid_theta_com.state + pid_theta_com.vel*time;
pid_theta_com.vel_all = [pid_theta_com.vel_all pid_theta_com.vel];
pid_theta_com.state_all = [pid_theta_com.state_all pid_theta_com.state];