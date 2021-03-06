require(doParallel)
R <- edhec[, 1:4]
# 设置portfolio的约束条件
pspec <- portfolio.spec(assets=colnames(R))
pspec <- add.constraint(portfolio=pspec, type="leverage",min_sum=0.99, max_sum=1.01)
pspec <- add.constraint(portfolio=pspec, type="box", min=0, max=1)

# 使用三种方式分别生成5000个投资组合,注意是在上述constraint的约束之下
rp1 <- random_portfolios(portfolio=pspec, permutations=5000,rp_method="sample")
rp2 <- random_portfolios(portfolio=pspec, permutations=5000,rp_method="simplex")
rp3 <- random_portfolios(portfolio=pspec, permutations=5000,rp_method="grid")

# show feasible portfolios in mean-StdDev space
tmp1.mean <- apply(rp1, 1, function(x) mean(R %*% x))
tmp1.StdDev <- apply(rp1, 1, function(x) StdDev(R=R, weights=x))
tmp2.mean <- apply(rp2, 1, function(x) mean(R %*% x))
tmp2.StdDev <- apply(rp2, 1, function(x) StdDev(R=R, weights=x))
tmp3.mean <- apply(rp3, 1, function(x) mean(R %*% x))
tmp3.StdDev <- apply(rp3, 1, function(x) StdDev(R=R, weights=x))
# plot feasible portfolios
plot(x=tmp1.StdDev, y=tmp1.mean, col="gray", main="Random Portfolio Methods",ylab="mean", xlab="StdDev")
points(x=tmp2.StdDev, y=tmp2.mean, col="red", pch=2)
points(x=tmp3.StdDev, y=tmp3.mean, col="lightgreen", pch=5)
legend("bottomright", legend=c("sample", "simplex", "grid"),col=c("gray", "red", "lightgreen"),pch=c(1, 2, 5), bty="n")



fev <- 0:5
par(mfrow=c(2, 3))
for(i in 1:length(fev)){
  rp <- rp_simplex(portfolio=pspec, permutations=2000, fev=fev[i])
  tmp.mean <- apply(rp, 1, function(x) mean(R %*% x))
  tmp.StdDev <- apply(rp, 1, function(x) StdDev(R=R, weights=x))
  plot(x=tmp.StdDev, y=tmp.mean, main=paste("FEV =", fev[i]),
         ylab="mean", xlab="StdDev", col=rgb(0, 0, 100, 50, maxColorValue=255))
  }
par(mfrow=c(1,1))



par(mfrow=c(1, 2))
# simplex
rp_simplex <- random_portfolios(portfolio=pspec, permutations=2000,rp_method="simplex")
tmp.mean <- apply(rp_simplex, 1, function(x) mean(R %*% x))
tmp.StdDev <- apply(rp_simplex, 1, function(x) StdDev(R=R, weights=x))
plot(x=tmp.StdDev, y=tmp.mean, main="rp_method=simplex fev=0:5",
     ylab="mean", xlab="StdDev", col=rgb(0, 0, 100, 50, maxColorValue=255))
#sample
rp_sample <- random_portfolios(portfolio=pspec, permutations=2000,rp_method="sample")
tmp.mean <- apply(rp_sample, 1, function(x) mean(R %*% x))
tmp.StdDev <- apply(rp_sample, 1, function(x) StdDev(R=R, weights=x))
plot(x=tmp.StdDev, y=tmp.mean, main="rp_method=sample",
       ylab="mean", xlab="StdDev", col=rgb(0, 0, 100, 50, maxColorValue=255))
par(mfrow=c(1,1))