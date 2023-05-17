# HW8

## 1.

$$
\eta(\tau,\delta)-\sum_{k=0}^{\delta}\eta(\tau-1,k)
$$

$$
= \frac{(\tau+\delta)!}{\tau! \delta!} - \sum_{k=0}^{\delta}\frac{((\tau-1)+k)!}{(\tau-1)! k!}
$$

$$
= (\frac{1}{(\tau-1)!})(\frac{(\tau+\delta)!}{\tau \delta!}-\sum_{k=0}^{\delta}\frac{((\tau-1)+k)!}{ k!})
$$

$$
= \frac{(\tau+\delta)...\tau}{\tau \cdot \delta!} - 1 - \frac{\tau}{1!}- ...-\frac{\tau...(\tau+\delta-1)}{\delta !}
$$

$$
= \frac{(\tau+\delta)...\tau}{\tau \cdot \delta!} - \sum_{k=0}^{\delta}\frac{(k+\tau-1)...\tau}{k!}
$$

Notice that,

$$
\frac{(\tau+k)...\tau}{\tau \cdot k!} - \frac{\tau...(\tau+k-1)}{k!}
$$

$$
= \frac{k \cdot(\tau + k -1)...\tau }{\tau \cdot k !} = \frac{(\tau + k -1)...\tau }{\tau \cdot (k-1) !}
$$

The above Eqn holds for $k$ from $\delta$ to 0. So $\eta(\tau,\delta)-\sum_{k=0}^{\delta}\eta(\tau-1,k)$ can be recursively proved to be zero.



## 2.


