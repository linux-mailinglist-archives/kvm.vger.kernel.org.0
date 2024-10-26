Return-Path: <kvm+bounces-29747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 851929B1526
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 07:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 305A91F214E9
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 05:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4DF178CDE;
	Sat, 26 Oct 2024 05:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uRotzDxY"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3A6320F
	for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 05:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729920874; cv=none; b=J3jA35CA5843ALm9ZQWHgh2zTRCHtJGv/ylyFtksWAX8x5H/BgJyRrMoKKw/SAllkiboeGndeZZcApU4EsjNIs1EauWpBHIGLiyepp1FZ6riGPHj0fP7QhNjbpImxjbvUqWlTksL6ggc2QHWPATsezrFYz3M28kav3//QZQ0J28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729920874; c=relaxed/simple;
	bh=+gqBjpDwjKYtNctvzOJOwSt/7mwGLDiB/t/GK/jcCAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paVX7tAjn2GTVUHYHc++KYVffO1mAPmXzEzh/rIV/+dY0qOrItmRLxw1uiedCd58NqdnRSkF/aESLErze4U/ceVPsbKn7+pgD7Gw85cZ4uFeclNJL5JMS9bb0yXBYHnE17z2UpJgAL8IPT0FQCUACl99FM8+sngaARo3pBr61SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uRotzDxY; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 25 Oct 2024 22:34:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729920870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1VqnAcW2Lr3Wy+fyPS6e7OxFPoaLSfYoH8W/e5CQq/w=;
	b=uRotzDxY2ZOxA3MQsoJ6CvtuZFL9wN9G3BXCyfRTs1bHCvEDCGzBJDkL34TQiC8MIsw4AA
	eoPYjoe5fjfZ+arMREjDW4ItPBv5y93EQ/aSrzqvZNAX6zbc4jHitDCuRCClFTcVGyGTbz
	ev8wimyrZndrhZ0ewX0qLhBjjKA9jwQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, stable@vger.kernel.org,
	syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH] KVM: arm64: Mark the VM as dead for failed
 initializations
Message-ID: <Zxx_X9-MdmAFzHUO@linux.dev>
References: <20241025221220.2985227-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025221220.2985227-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Raghu,

Thanks for posting this fix.

On Fri, Oct 25, 2024 at 10:12:20PM +0000, Raghavendra Rao Ananta wrote:
> Syzbot hit the following WARN_ON() in kvm_timer_update_irq():
> 
> WARNING: CPU: 0 PID: 3281 at arch/arm64/kvm/arch_timer.c:459
> kvm_timer_update_irq+0x21c/0x394
> Call trace:
>   kvm_timer_update_irq+0x21c/0x394 arch/arm64/kvm/arch_timer.c:459
>   kvm_timer_vcpu_reset+0x158/0x684 arch/arm64/kvm/arch_timer.c:968
>   kvm_reset_vcpu+0x3b4/0x560 arch/arm64/kvm/reset.c:264
>   kvm_vcpu_set_target arch/arm64/kvm/arm.c:1553 [inline]
>   kvm_arch_vcpu_ioctl_vcpu_init arch/arm64/kvm/arm.c:1573 [inline]
>   kvm_arch_vcpu_ioctl+0x112c/0x1b3c arch/arm64/kvm/arm.c:1695
>   kvm_vcpu_ioctl+0x4ec/0xf74 virt/kvm/kvm_main.c:4658
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:907 [inline]
>   __se_sys_ioctl fs/ioctl.c:893 [inline]
>   __arm64_sys_ioctl+0x108/0x184 fs/ioctl.c:893
>   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>   invoke_syscall+0x78/0x1b8 arch/arm64/kernel/syscall.c:49
>   el0_svc_common+0xe8/0x1b0 arch/arm64/kernel/syscall.c:132
>   do_el0_svc+0x40/0x50 arch/arm64/kernel/syscall.c:151
>   el0_svc+0x54/0x14c arch/arm64/kernel/entry-common.c:712
>   el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
>   el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> 
> The sequence that led to the report is when KVM_ARM_VCPU_INIT ioctl is
> invoked after a failed first KVM_RUN. In a general sense though, since
> kvm_arch_vcpu_run_pid_change() doesn't tear down any of the past
> initiatializations, it's possible that the VM's state could be left

typo: initializations

> half-baked. Any upcoming ioctls could behave erroneously because of
> this.

You may want to highlight a bit more strongly that, despite the name,
we do a lot of late *VM* state initialization in kvm_arch_vcpu_run_pid_change().

When that goes sideways we're left with few choices besides bugging the
VM or gracefully tearing down state, potentially w/ concurrent users.

> Since these late vCPU initializations is past the point of attributing
> the failures to any ioctl, instead of tearing down each of the previous
> setups, simply mark the VM as dead, gving an opportunity for the
> userspace to close and try again.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>

I definitely recommended this to you, so blame *me* for imposing some
toil on you with the following.

> @@ -836,16 +836,16 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  
>  	ret = kvm_timer_enable(vcpu);
>  	if (ret)
> -		return ret;
> +		goto out_err;
>  
>  	ret = kvm_arm_pmu_v3_enable(vcpu);
>  	if (ret)
> -		return ret;
> +		goto out_err;
>  
>  	if (is_protected_kvm_enabled()) {
>  		ret = pkvm_create_hyp_vm(kvm);
>  		if (ret)
> -			return ret;
> +			goto out_err;
>  	}
>  
>  	if (!irqchip_in_kernel(kvm)) {
> @@ -869,6 +869,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  	mutex_unlock(&kvm->arch.config_lock);
>  
>  	return ret;
> +
> +out_err:
> +	kvm_vm_dead(kvm);
> +	return ret;
>  }

After rereading, I think we could benefit from a more distinct separation
of late VM vs. vCPU state initialization.

Bugging the VM is a big hammer, we should probably only resort to that
when the VM state is screwed up badly.

Otherwise, for screwed up vCPU state we could uninitialize the vCPU and
let userspace try again. An example of this is how we deal with VMs that
run 32 bit userspace when KVM tries to hide the feature.

WDYT?

-- 
Thanks,
Oliver

