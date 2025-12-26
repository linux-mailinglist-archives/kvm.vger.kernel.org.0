Return-Path: <kvm+bounces-66704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEDFCDE639
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 07:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0DAAC3007C8D
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 06:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A2F28851F;
	Fri, 26 Dec 2025 06:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pCwrccDr"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBCDB652;
	Fri, 26 Dec 2025 06:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766731911; cv=none; b=YtInDE4oQ68+LHyqHeqn8gLrFEjp5JGul33tTiJHuJONAcPvf5QJapuKpD2R9mnsLvjN203BdncGZcf1olLF5TJALidYvZRRsWOaDQi2P/k7b7oOEpilKmix0fFgaI9q3QTB+rwm4CMalfQhJ7Osa7kXrIoTdpIi1hikA2mS3AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766731911; c=relaxed/simple;
	bh=4WihWL+bInC+cAJOjCn/osSgBmLo8EdsB0pnCpyEZp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PD+PPlpblwnteprzYQDFkAzMouqZ3SAEHI4Y5zHBwSdhHeFoiOiksyaWRCSXUUCUMNG5QnzJo/zc523YJCZnJFvip/hhxjpVi4KZxQtYBJr2LQkPP3kEUEj3FNBJcaDfTw3L1E+HUrV+0Uz4ZrWUXwz6pDVx1GW7F5dEK6538Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pCwrccDr; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766731898; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=0x/FfIujGwHcIqEZKKhM/7sF5/cqnIaX1YYYstX2tG4=;
	b=pCwrccDrezWWnnnf8HDJHwDZ+bLQ3nf2wPpOlNZhR+H4E3gnSx7M5/tLOevhWXPMbwB5uJGu8tI6AKk7zSp2of8w2SDf0BLwN8Llu5BKyqgg04dkjQeclAzZ2gkMJ9v3c1odxRp2MfY4hvg036ZszbJoclF2sYRW42ng+i444MQ=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WvgmF6o_1766731897 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:51:38 +0800
Date: Fri, 26 Dec 2025 14:51:37 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] x86, fpu: introduce fpu_load_guest_fpstate()
Message-ID: <ub4djdh4iqy5mhl4ea6gpalu2tpv5ymnw63wdkwehldzh477eq@frxtjt3umsqh>
References: <20251224001249.1041934-1-pbonzini@redhat.com>
 <20251224001249.1041934-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224001249.1041934-2-pbonzini@redhat.com>

On Wed, Dec 24, 2025 at 01:12:45AM +0800, Paolo Bonzini wrote:
> Create a variant of fpregs_lock_and_load() that KVM can use in its
> vCPU entry code after preemption has been disabled.  While basing
> it on the existing logic in vcpu_enter_guest(), ensure that
> fpregs_assert_state_consistent() always runs and sprinkle a few
> more assertions.
>
> Cc: stable@vger.kernel.org
> Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/fpu/api.h |  1 +
>  arch/x86/kernel/fpu/core.c     | 17 +++++++++++++++++
>  arch/x86/kvm/x86.c             |  8 +-------
>  3 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
> index cd6f194a912b..0820b2621416 100644
> --- a/arch/x86/include/asm/fpu/api.h
> +++ b/arch/x86/include/asm/fpu/api.h
> @@ -147,6 +147,7 @@ extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
>  /* KVM specific functions */
>  extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
>  extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
> +extern void fpu_load_guest_fpstate(struct fpu_guest *gfpu);
>  extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
>  extern int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures);
>
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 3ab27fb86618..a480fa8c65d5 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -878,6 +878,23 @@ void fpregs_lock_and_load(void)
>  	fpregs_assert_state_consistent();
>  }
>
> +void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
> +{
> +#ifdef CONFIG_X86_DEBUG_FPU
> +	struct fpu *fpu = x86_task_fpu(current);
> +	WARN_ON_ONCE(gfpu->fpstate != fpu->fpstate);
> +#endif
> +
> +	lockdep_assert_preemption_disabled();

Hi Paolo,

Do we need make sure the irq is disabled w/ lockdep ?

The irq_fpu_usable() returns true for:

!in_nmi () && in_hardirq() and !softirq_count()

It's possible that the TIF_NEED_FPU_LOAD is set again
w/ interrupt is enabled.

> +	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +		fpregs_restore_userregs();
> +
> +	fpregs_assert_state_consistent();
> +	if (gfpu->xfd_err)
> +		wrmsrq(MSR_IA32_XFD_ERR, gfpu->xfd_err);
> +}
> +EXPORT_SYMBOL_FOR_KVM(fpu_load_guest_fpstate);
> +
>  #ifdef CONFIG_X86_DEBUG_FPU
>  /*
>   * If current FPU state according to its tracking (loaded FPU context on this
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff8812f3a129..01d95192dfc5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11300,13 +11300,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	}
>
> -	fpregs_assert_state_consistent();
> -	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> -		switch_fpu_return();
> -
> -	if (vcpu->arch.guest_fpu.xfd_err)
> -		wrmsrq(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> -
> +	fpu_load_guest_fpstate(&vcpu->arch.guest_fpu);
>  	kvm_load_xfeatures(vcpu, true);
>
>  	if (unlikely(vcpu->arch.switch_db_regs &&
> --
> 2.52.0
>

