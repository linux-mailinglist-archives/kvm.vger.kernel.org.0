Return-Path: <kvm+bounces-72560-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNxYNVgtp2mbfgAAu9opvQ
	(envelope-from <kvm+bounces-72560-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:50:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF7F1F57A6
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:49:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AA8573027588
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A953492528;
	Tue,  3 Mar 2026 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XlVCeQ0q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C6138655B
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772563774; cv=none; b=A8CDIiH/QQ3ORochRosyurUyQJPJQIu8xGHvR9qIcmuM7FThbGlOyefKBVf+t4RzxS595AaMr5kCTtFfa88/KPYMUSiWJE6//D2yk5P7zJ0YdhUsJzgDKjmQEI5GRFjyrBOPy0xPUisOGLb2Ks2QjclTHN2XJgXs+R6C2AUIZO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772563774; c=relaxed/simple;
	bh=PXqaH0XsPYwKgnbesGlSRGwmPB2SW89gjwUrlS6E3Qw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZbAZl30fYY5hzxyLZeWm2p4UCV+G/AOxSYmKXuFteZ6ieGn/IoI7u84DpKxnPYgqFFgGjNJ0lf5Pt7cZGsBJFrz+8SYIR861QXwNKRzXp6ERSH/D82VOmlshFDWdLjq8xHYAWiFJY5aY0emsweVFt2EDDIVbCGuLmsOKfzUCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XlVCeQ0q; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82748257f5fso3134896b3a.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772563772; x=1773168572; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfFy0+sICiIpuWtJU7Loxi/Rf1izKQ3p65y5jr4rNp4=;
        b=XlVCeQ0qvekpMzZTVBZsEleO5pIUxKBHdqHE5204Z4q56KvArvYNvSAEaJTlNH2T+c
         WulFhpYzDVCDsAPCAyD7iTsuH0f37aAD/fHdKH0Laj2lNclU5KQi2loe5Skc6S05n2Tb
         cjwQAdgiV5MqCuQS7Gk3FkQifFD3SCSP0lr+7e4D3inrxnqOUzGeFH7w3sxHlaQoD2vH
         bBcr3zmAd/5jLnJNIk5gtKCjb/C9cBeeoS/R9KrrDMz8Xz5mSW9kTQzuUvs6PaVq5Tbh
         QAmDZ7iltIIjZIIgr/OLgVfUmeI7mQlOkoLucCBXqydNHDIJnD54EcY842G1/xhEawtY
         pupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772563772; x=1773168572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lfFy0+sICiIpuWtJU7Loxi/Rf1izKQ3p65y5jr4rNp4=;
        b=VDf8Twa5kpziMkgCfCFAB8MaK6xLyvz6I5As1FuBRlIpsCJDEAfqmnRdqmgrjXBohF
         Jmp5xbaAYl6mCtkBR9F8o2D0q0EEiPw4Kvc4SvsIHYcErFE9BVluNGA06CCC9fZJ7CNa
         p6xFko9j9y8FZXd3ovnc7ndeVHZvGB0XUbXZ+XNUBpOZiv6jdY2dR+unbEcOG3XWCEGh
         1almXz/csKTHxPvyMg3QXobmeYaBs+8S8nLBMB91kHz7IsBM2jtHfKFMaIukIK4sK8ic
         YXmhO9VOLj3cWjpNm4mwBVZMfxiDG6lGN5XnIKjf5J2JhslpbsTB1TJxTsIAXoPADiyp
         USiQ==
X-Forwarded-Encrypted: i=1; AJvYcCViduD2/tieAPXDoFLrNd6Q29tcvZyA6C/Tt2xAXmjkrRWSlghb8AvyfHa/mjv5OufiGHo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze95ib5NvuMZWlJwU3cnffBDXUkgkZfQtRqy0P5bJTYPOnLAhZ
	5Xx+sj02w+qJAXqnCfcdeieQVNQI8zqkkfsH0c986MY90L+AmGPnDiP6
X-Gm-Gg: ATEYQzyRK2Ej98RvBYeb+iOhgYYnQisydmXGqjzNVpfRLszXGuUVM26dF+iodv+8/OR
	y15LuW9PEXP4WC8eIcXhHoTACBz7tXBN7rBpaxJs2jOLMqivL6/icIytWRGtJmFBOrPDrdTlZkY
	fR3v+VdjKhiYysQ0v9Xj7S/1wxnTEjht3Ed8YpTjt7uVVAD4yhD2RByMG4Tmunyeb06JzDZDEVY
	FolQXjQFjS8Kmoa+AoA+yp2WFkuvyxVMeNb2jB/TPB+09mbylWXEr1dVZN6I85TireEtRzoUP2M
	L3kRVMEySUU4SsndaoloH/oScgMRoDpTeAP0sacmyoFp1hfsuh25HHGVe4p30OxJo40Ic8QJFIv
	1BytNk/C2gF9e5XtrwZs30NHN0H8B1p10sPnXFriyXNwM+sRBh7u3GrS2hLmDrwe6YLQPKz+Dhq
	J5R6pAAAZQFAfalrB3s6Neljg=
X-Received: by 2002:a17:90b:5286:b0:359:83a3:584d with SMTP id 98e67ed59e1d1-3599ce32dabmr2717858a91.6.1772563772118;
        Tue, 03 Mar 2026 10:49:32 -0800 (PST)
Received: from localhost ([27.7.180.69])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3599c49eb5bsm2803924a91.11.2026.03.03.10.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:49:31 -0800 (PST)
Date: Wed, 4 Mar 2026 00:19:28 +0530
From: shaikh kamaluddin <shaikhkamal2012@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] KVM: mmu_notifier: make mn_invalidate_lock non-sleeping
 for non-blocking invalidations
Message-ID: <aactOOfirdVRYfNS@acer-nitro-anv15-41>
References: <20260209161527.31978-1-shaikhkamal2012@gmail.com>
 <20260211120944.-eZhmdo7@linutronix.de>
 <aYyhfvC_2s000P7H@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYyhfvC_2s000P7H@google.com>
X-Rspamd-Queue-Id: CDF7F1F57A6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72560-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shaikhkamal2012@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 07:34:22AM -0800, Sean Christopherson wrote:
> On Wed, Feb 11, 2026, Sebastian Andrzej Siewior wrote:
> > On 2026-02-09 21:45:27 [+0530], shaikh.kamal wrote:
> > > mmu_notifier_invalidate_range_start() may be invoked via
> > > mmu_notifier_invalidate_range_start_nonblock(), e.g. from oom_reaper(),
> > > where sleeping is explicitly forbidden.
> > > 
> > > KVM's mmu_notifier invalidate_range_start currently takes
> > > mn_invalidate_lock using spin_lock(). On PREEMPT_RT, spin_lock() maps
> > > to rt_mutex and may sleep, triggering:
> > > 
> > >   BUG: sleeping function called from invalid context
> > > 
> > > This violates the MMU notifier contract regardless of PREEMPT_RT;
> 
> I highly doubt that.  kvm.mmu_lock is also a spinlock, and KVM has been taking
> that in invalidate_range_start() since
> 
>   e930bffe95e1 ("KVM: Synchronize guest physical memory map to host virtual memory map")
> 
> which was a full decade before mmu_notifiers even added the blockable concept in
> 
>   93065ac753e4 ("mm, oom: distinguish blockable mode for mmu notifiers")
> 
> and even predate the current concept of a "raw" spinlock introduced by
> 
>   c2f21ce2e312 ("locking: Implement new raw_spinlock")
> 
> > > RT kernels merely make the issue deterministic.
> 
> No, RT kernels change the rules, because suddenly a non-sleeping locking becomes
> sleepable.
> 
> > > Fix by converting mn_invalidate_lock to a raw spinlock so that
> > > invalidate_range_start() remains non-sleeping while preserving the
> > > existing serialization between invalidate_range_start() and
> > > invalidate_range_end().
> 
> This is insufficient.  To actually "fix" this in KVM mmu_lock would need to be
> turned into a raw lock on all KVM architectures.  I suspect the only reason there
> haven't been bug reports is because no one trips an OOM kill on VM while running
> with CONFIG_DEBUG_ATOMIC_SLEEP=y.
> 
> That combination is required because since commit
> 
>   8931a454aea0 ("KVM: Take mmu_lock when handling MMU notifier iff the hva hits a memslot")
> 
> KVM only acquires mmu_lock if the to-be-invalidated range overlaps a memslot,
> i.e. affects memory that may be mapped into the guest.
> 
> E.g. this hack to simulate a non-blockable invalidation
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7015edce5bd8..7a35a83420ec 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -739,7 +739,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>                 .handler        = kvm_mmu_unmap_gfn_range,
>                 .on_lock        = kvm_mmu_invalidate_begin,
>                 .flush_on_ret   = true,
> -               .may_block      = mmu_notifier_range_blockable(range),
> +               .may_block      = false,//mmu_notifier_range_blockable(range),
>         };
>  
>         trace_kvm_unmap_hva_range(range->start, range->end);
> @@ -768,6 +768,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>          */
>         gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
>  
> +       non_block_start();
>         /*
>          * If one or more memslots were found and thus zapped, notify arch code
>          * that guest memory has been reclaimed.  This needs to be done *after*
> @@ -775,6 +776,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>          */
>         if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
>                 kvm_arch_guest_memory_reclaimed(kvm);
> +       non_block_end();
>  
>         return 0;
>  }
> 
> immediately triggers
> 
>   BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:241
>   in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 4992, name: qemu
>   preempt_count: 0, expected: 0
>   RCU nest depth: 0, expected: 0
>   CPU: 6 UID: 1000 PID: 4992 Comm: qemu Not tainted 6.19.0-rc6-4d0917ffc392-x86_enter_mmio_stack_uaf_no_null-rt #1 PREEMPT_RT 
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x51/0x60
>    __might_resched+0x10e/0x160
>    rt_write_lock+0x49/0x310
>    kvm_mmu_notifier_invalidate_range_start+0x10b/0x390 [kvm]
>    __mmu_notifier_invalidate_range_start+0x9b/0x230
>    do_wp_page+0xce1/0xf30
>    __handle_mm_fault+0x380/0x3a0
>    handle_mm_fault+0xde/0x290
>    __get_user_pages+0x20d/0xbe0
>    get_user_pages_unlocked+0xf6/0x340
>    hva_to_pfn+0x295/0x420 [kvm]
>    __kvm_faultin_pfn+0x5d/0x90 [kvm]
>    kvm_mmu_faultin_pfn+0x31b/0x6e0 [kvm]
>    kvm_tdp_page_fault+0xb6/0x160 [kvm]
>    kvm_mmu_do_page_fault+0xee/0x1f0 [kvm]
>    kvm_mmu_page_fault+0x8d/0x600 [kvm]
>    vmx_handle_exit+0x18c/0x5a0 [kvm_intel]
>    kvm_arch_vcpu_ioctl_run+0xc70/0x1c90 [kvm]
>    kvm_vcpu_ioctl+0x2d7/0x9a0 [kvm]
>    __x64_sys_ioctl+0x8a/0xd0
>    do_syscall_64+0x5e/0x11b0
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
>   kvm: emulating exchange as write
> 
> 
> It's not at all clear to me that switching mmu_lock to a raw lock would be a net
> positive for PREEMPT_RT.  OOM-killing a KVM guest in a PREEMPT_RT seems like a
> comically rare scenario.  Whereas contending mmu_lock in normal operation is
> relatively common (assuming there are even use cases for running VMs with a
> PREEMPT_RT host kernel).
> 
> In fact, the only reason the splat happens is because mmu_notifiers somewhat
> artificially forces an atomic context via non_block_start() since commit
> 
>   ba170f76b69d ("mm, notifier: Catch sleeping/blocking for !blockable")
> 
> Given the massive amount of churn in KVM that would be required to fully eliminate
> the splat, and that it's not at all obvious that it would be a good change overall,
> at least for now:
> 
> NAK
> 
> I'm not fundamentally opposed to such a change, but there needs to be a _lot_
> more analysis and justification beyond "fix CONFIG_DEBUG_ATOMIC_SLEEP=y".
>
Hi Sean,
Thanks for the detailed explanation and for spelling out the border
issue.
Understood on both points:
	1. The changelog wording was too strong; PREEMPT_RT changes
	spin_lock() semantics, and the splat is fundamentally due to
	spinlocks becoming sleepable there.
	2. Converting only mm_invalidate_lock to raw is insufficient
	since KVM can still take the mmu_lock (and other sleeping locks
	RT) in invalidate_range_start() when the invalidation hits a
	memslot.
Given the above, it shounds like "convert locks to raw" is not the right
direction without sinificat rework and justification.
Would an acceptable direction be to handle the !blockable notifier case
by deferring the heavyweight invalidation work(anything that take
mmu_lock/may sleep on RT) to a context that may block(e.g. queued work),
while keeping start()/end() accounting consisting with memslot changes ?
if so, I can protoptype a patch along those lines and share for
feedback.

Alternatively, if you think this needs to be addressed in
mmu_notifiers(eg. how non_block_start() is applied), I'm happy to
redirect my efforts there-Please advise.
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 5fcd401a5897..7a9c33f01a37 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -747,9 +747,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
> > >  	 *
> > >  	 * Pairs with the decrement in range_end().
> > >  	 */
> > > -	spin_lock(&kvm->mn_invalidate_lock);
> > > +	raw_spin_lock(&kvm->mn_invalidate_lock);
> > >  	kvm->mn_active_invalidate_count++;
> > > -	spin_unlock(&kvm->mn_invalidate_lock);
> > > +	raw_spin_unlock(&kvm->mn_invalidate_lock);
> > 
> > 	atomic_inc(mn_active_invalidate_count)
> > >  
> > >  	/*
> > >  	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
> > > @@ -817,11 +817,11 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
> > >  	kvm_handle_hva_range(kvm, &hva_range);
> > >  
> > >  	/* Pairs with the increment in range_start(). */
> > > -	spin_lock(&kvm->mn_invalidate_lock);
> > > +	raw_spin_lock(&kvm->mn_invalidate_lock);
> > >  	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
> > >  		--kvm->mn_active_invalidate_count;
> > >  	wake = !kvm->mn_active_invalidate_count;
> > 
> > 	wake = atomic_dec_return_safe(mn_active_invalidate_count);
> > 	WARN_ON_ONCE(wake < 0);
> > 	wake = !wake;
> > 
> > > -	spin_unlock(&kvm->mn_invalidate_lock);
> > > +	raw_spin_unlock(&kvm->mn_invalidate_lock);
> > >  
> > >  	/*
> > >  	 * There can only be one waiter, since the wait happens under
> > > @@ -1129,7 +1129,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
> > > @@ -1635,17 +1635,17 @@ static void kvm_swap_active_memslots(struct kvm *kvm, int as_id)
> > >  	 * progress, otherwise the locking in invalidate_range_start and
> > >  	 * invalidate_range_end will be unbalanced.
> > >  	 */
> > > -	spin_lock(&kvm->mn_invalidate_lock);
> > > +	raw_spin_lock(&kvm->mn_invalidate_lock);
> > >  	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
> > >  	while (kvm->mn_active_invalidate_count) {
> > >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > > -		spin_unlock(&kvm->mn_invalidate_lock);
> > > +		raw_spin_unlock(&kvm->mn_invalidate_lock);
> > >  		schedule();
> > 
> > And this I don't understand. The lock protects the rcuwait assignment
> > which would be needed if multiple waiters are possible. But this goes
> > away after the unlock and schedule() here. So these things could be
> > moved outside of the locked section which limits it only to the
> > mn_active_invalidate_count value.
> 
> The implementation is essentially a deliberately unfair rwswem.  The "write" side
> in kvm_swap_active_memslots() subtly protect this code:
> 
>   rcu_assign_pointer(kvm->memslots[as_id], slots);
> 
> and the "read" side protects the kvm->memslot lookups in kvm_handle_hva_range().
> 
> KVM optimizes its mmu_notifier invalidation path to only take action if the
> to-be-invalidated range overlaps one or more memslots, i.e. affects memory that
> be can be mapped into the guest.  The wrinkle with those optimizations is that
> KVM needs to prevent changes to the memslots between invalidation start() and end(),
> otherwise the accounting can become imbalanced, e.g. mmu_invalidate_in_progress
> will underflow or be left elevated and essentially hang the VM (among other bad
> things).
> 
> So simply making mn_active_invalidate_count an atomic won't suffice, because KVM
> needs to block start() to ensure start()+end() see the exact same set of memslots.

