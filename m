Return-Path: <kvm+bounces-183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2FDC7DCB0F
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 11:43:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BD311C20C28
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4CE12E75;
	Tue, 31 Oct 2023 10:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KsUyStkR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18B15B0
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:42:52 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637B8A9;
	Tue, 31 Oct 2023 03:42:50 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40839807e82so32605515e9.0;
        Tue, 31 Oct 2023 03:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698748969; x=1699353769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tu/NVIPw13vh/eRvLk6UGsgezAJze2MNtoMdnmel/do=;
        b=KsUyStkRBSjPpVAClbghCTTYcG4D9d1B0Q1qVjOdJFH15vQqm3naJlyJcdrvS56PXY
         FVqUeGZMhBQwWAccMqmOGHrnVvsNlzpRYU8mtZBOEShSNubS0l7xC19FZpqJaCiQH8Mp
         e6UnQSj1igoUNf4M5efNc6MktpmU78WAPdkNvmg2446nuBJDDlfFLFDcA2nzBXHzvo9I
         zniwqwKxA4wFIRGaXBeKd0OxoO8Zc7fq8VK8Pin8xpC7HX622WlQLIx90BeqIBWHVpxZ
         r4m5oPOnxYPXdd/5EUhhbifar4fdRLwqHpk3G3JI/KJ+A0LfWtya/xjbZkXHGx29EpIb
         sR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698748969; x=1699353769;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tu/NVIPw13vh/eRvLk6UGsgezAJze2MNtoMdnmel/do=;
        b=FUGm+LNz9ph+xunvW9EwzTqUJEPQd9GsEXF66+L+kcuSfj1H/WbwPXNK3+Sc9UuIE8
         WtCGxlGdZn4Y6sFl1Xa0f5N8qpX8LVPHqmMvkPsK7ZFbmfGWTWBWqZ3rEaKDgtHvReOo
         5ipJ6bVMtI22/Uz0uOx0qqiS7yRytjSfqOHJy3xI2doOCxXGA9OETfH0ALGTiJusHZ8q
         wKkCTwbieMenHQqxY9MtL7C/cvaqHfvKBvcdTfUa/IZVOe9o45aX/Lul+2xNzbwccYMv
         uNySfxGK5JfD6eNa0L0MaZEAwuP9ATtFILjXJ+d8zbynNT78hj78KyA5q8eGXMomtloX
         +RGw==
X-Gm-Message-State: AOJu0Yz01UBxvBLjfJkGfIUg5XBnProl2BTMtyuAojDGhbS/qZ5ZrKfA
	EtBM+mbReKyU2SaoJd2sg8w=
X-Google-Smtp-Source: AGHT+IF946GEGhBamACP5AKpNHBHYs80aXFAb3KtG0/meUT/dyw++7fzFJU23QENLa1lfE8FtJjsxw==
X-Received: by 2002:a05:600c:3c83:b0:401:c8b9:4b86 with SMTP id bg3-20020a05600c3c8300b00401c8b94b86mr2309600wmb.9.1698748968403;
        Tue, 31 Oct 2023 03:42:48 -0700 (PDT)
Received: from [10.95.146.166] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id z20-20020a1c4c14000000b00405c33a9a12sm686082wmf.0.2023.10.31.03.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 03:42:48 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <1a679274-bbff-4549-a1ea-c7ea9f1707cc@xen.org>
Date: Tue, 31 Oct 2023 10:42:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86/xen: improve accuracy of Xen timers
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> A test program such as http://david.woodhou.se/timerlat.c confirms user
> reports that timers are increasingly inaccurate as the lifetime of a
> guest increases. Reporting the actual delay observed when asking for
> 100µs of sleep, it starts off OK on a newly-launched guest but gets
> worse over time, giving incorrect sleep times:
> 
> root@ip-10-0-193-21:~# ./timerlat -c -n 5
> 00000000 latency 103243/100000 (3.2430%)
> 00000001 latency 103243/100000 (3.2430%)
> 00000002 latency 103242/100000 (3.2420%)
> 00000003 latency 103245/100000 (3.2450%)
> 00000004 latency 103245/100000 (3.2450%)
> 
> The biggest problem is that get_kvmclock_ns() returns inaccurate values
> when the guest TSC is scaled. The guest sees a TSC value scaled from the
> host TSC by a mul/shift conversion (hopefully done in hardware). The
> guest then converts that guest TSC value into nanoseconds using the
> mul/shift conversion given to it by the KVM pvclock information.
> 
> But get_kvmclock_ns() performs only a single conversion directly from
> host TSC to nanoseconds, giving a different result. A test program at
> http://david.woodhou.se/tsdrift.c demonstrates the cumulative error
> over a day.
> 
> It's non-trivial to fix get_kvmclock_ns(), although I'll come back to
> that. The actual guest hv_clock is per-CPU, and *theoretically* each
> vCPU could be running at a *different* frequency. But this patch is
> needed anyway because...
> 
> The other issue with Xen timers was that the code would snapshot the
> host CLOCK_MONOTONIC at some point in time, and then... after a few
> interrupts may have occurred, some preemption perhaps... would also read
> the guest's kvmclock. Then it would proceed under the false assumption
> that those two happened at the *same* time. Any time which *actually*
> elapsed between reading the two clocks was introduced as inaccuracies
> in the time at which the timer fired.
> 
> Fix it to use a variant of kvm_get_time_and_clockread(), which reads the
> host TSC just *once*, then use the returned TSC value to calculate the
> kvmclock (making sure to do that the way the guest would instead of
> making the same mistake get_kvmclock_ns() does).
> 
> Sadly, hrtimers based on CLOCK_MONOTONIC_RAW are not supported, so Xen
> timers still have to use CLOCK_MONOTONIC. In practice the difference
> between the two won't matter over the timescales involved, as the
> *absolute* values don't matter; just the delta.
> 
> This does mean a new variant of kvm_get_time_and_clockread() is needed;
> called kvm_get_monotonic_and_clockread() because that's what it does.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c |  30 ++++++++++++
>   arch/x86/kvm/x86.h |   1 +
>   arch/x86/kvm/xen.c | 111 +++++++++++++++++++++++++++++++--------------
>   3 files changed, 109 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 41cce5031126..aeede83d65dc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2863,6 +2863,25 @@ static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
>   	return mode;
>   }
>   
> +static int do_monotonic(s64 *t, u64 *tsc_timestamp)
> +{
> +	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
> +	unsigned long seq;
> +	int mode;
> +	u64 ns;
> +
> +	do {
> +		seq = read_seqcount_begin(&gtod->seq);
> +		ns = gtod->clock.base_cycles;
> +		ns += vgettsc(&gtod->clock, tsc_timestamp, &mode);
> +		ns >>= gtod->clock.shift;
> +		ns += ktime_to_ns(ktime_add(gtod->clock.offset, gtod->offs_boot));
> +	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
> +	*t = ns;
> +
> +	return mode;
> +}
> +
>   static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
>   {
>   	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
> @@ -2895,6 +2914,17 @@ static bool kvm_get_time_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp)
>   						      tsc_timestamp));
>   }
>   
> +/* returns true if host is using TSC based clocksource */
> +bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp)
> +{
> +	/* checked again under seqlock below */
> +	if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode))
> +		return false;
> +
> +	return gtod_is_based_on_tsc(do_monotonic(kernel_ns,
> +						 tsc_timestamp));
> +}
> +
>   /* returns true if host is using TSC based clocksource */
>   static bool kvm_get_walltime_and_clockread(struct timespec64 *ts,
>   					   u64 *tsc_timestamp)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 1e7be1f6ab29..c08c6f729965 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -293,6 +293,7 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
>   void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>   
>   u64 get_kvmclock_ns(struct kvm *kvm);
> +bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
>   
>   int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
>   	gva_t addr, void *val, unsigned int bytes,
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 0ea6016ad132..00a1e924a717 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -24,6 +24,7 @@
>   #include <xen/interface/sched.h>
>   
>   #include <asm/xen/cpuid.h>
> +#include <asm/pvclock.h>
>   
>   #include "cpuid.h"
>   #include "trace.h"
> @@ -144,17 +145,87 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
>   	return HRTIMER_NORESTART;
>   }
>   
> -static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 delta_ns)
> +static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
> +				bool linux_wa)
>   {
> +	uint64_t guest_now;
> +	int64_t kernel_now, delta;
> +
> +	 /*
> +	 * The guest provides the requested timeout in absolute nanoseconds
> +	 * of the KVM clock — as *it* sees it, based on the scaled TSC and
> +	 * the pvclock information provided by KVM.
> +	 *
> +	 * The kernel doesn't support hrtimers based on CLOCK_MONOTONIC_RAW
> +	 * so use CLOCK_MONOTONIC. In the timescales covered by timers, the
> +	 * difference won't matter much as there is no cumulative effect.
> +	 *
> +	 * Calculate the time for some arbitrary point in time around "now"
> +	 * in terms of both kvmclock and CLOCK_MONOTONIC. Calculate the
> +	 * delta between the kvmclock "now" value and the guest's requested
> +	 * timeout, apply the "Linux workaround" described below, and add
> +	 * the resulting delta to the CLOCK_MONOTONIC "now" value, to get
> +	 * the absolute CLOCK_MONOTONIC time at which the timer should
> +	 * fire.
> +	 */
> +	if (vcpu->kvm->arch.use_master_clock &&
> +	    static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +		uint64_t host_tsc, guest_tsc;
> +
> +		if (!IS_ENABLED(CONFIG_64BIT) ||
> +		    !kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
> +			/*
> +			 * Don't fall back to get_kvmclock_ns() because it's
> +			 * broken; it has a systemic error in its results
> +			 * because it scales directly from host TSC to
> +			 * nanoseconds, and doesn't scale first to guest TSC
> +			 * and then* to nanoseconds as the guest does.
> +			 *
> +			 * There is a small error introduced here because time
> +			 * continues to elapse between the ktime_get() and the
> +			 * subsequent rdtsc(). But not the systemic drift due
> +			 * to get_kvmclock_ns().
> +			 */
> +			kernel_now = ktime_get(); /* This is CLOCK_MONOTONIC */
> +			host_tsc = rdtsc();
> +		}
> +
> +		/* Calculate the guest kvmclock as the guest would do it. */
> +		guest_tsc = kvm_read_l1_tsc(vcpu, host_tsc);
> +		guest_now = __pvclock_read_cycles(&vcpu->arch.hv_clock, guest_tsc);
> +	} else {
> +		/* Without CONSTANT_TSC, get_kvmclock_ns() is the only option */
> +		guest_now = get_kvmclock_ns(vcpu->kvm);
> +		kernel_now = ktime_get();
> +	}
> +
> +	delta = guest_abs - guest_now;
> +
> +	/* Xen has a 'Linux workaround' in do_set_timer_op() which
> +	 * checks for negative absolute timeout values (caused by
> +	 * integer overflow), and for values about 13 days in the
> +	 * future (2^50ns) which would be caused by jiffies
> +	 * overflow. For those cases, it sets the timeout 100ms in
> +	 * the future (not *too* soon, since if a guest really did
> +	 * set a long timeout on purpose we don't want to keep
> +	 * churning CPU time by waking it up).
> +	 */
> +	if (linux_wa) {
> +		if ((unlikely((int64_t)guest_abs < 0 ||
> +			      (delta > 0 && (uint32_t) (delta >> 50) != 0)))) {
> +			delta = 100 * NSEC_PER_MSEC;
> +			guest_abs = guest_now + delta;
> +		}
> +	}
> +
>   	atomic_set(&vcpu->arch.xen.timer_pending, 0);
>   	vcpu->arch.xen.timer_expires = guest_abs;
>   
> -	if (delta_ns <= 0) {
> +	if (delta <= 0) {
>   		xen_timer_callback(&vcpu->arch.xen.timer);
>   	} else {
> -		ktime_t ktime_now = ktime_get();
>   		hrtimer_start(&vcpu->arch.xen.timer,
> -			      ktime_add_ns(ktime_now, delta_ns),
> +			      ktime_add_ns(kernel_now, delta),
>   			      HRTIMER_MODE_ABS_HARD);
>   	}
>   }
> @@ -923,8 +994,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>   		/* Start the timer if the new value has a valid vector+expiry. */
>   		if (data->u.timer.port && data->u.timer.expires_ns)
>   			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
> -					    data->u.timer.expires_ns -
> -					    get_kvmclock_ns(vcpu->kvm));
> +					    false);

There is no documented ordering requirement on setting 
KVM_XEN_VCPU_ATTR_TYPE_TIMER versus KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO or 
KVM_XEN_ATTR_TYPE_SHARED_INFO but kvm_xen_start_timer() now needs the 
vCPU's pvclock to be valid. Should actually starting the timer not be 
deferred until then? (Or simply add a check here and have the attribute 
setting fail if the pvclock is not valid).

   Paul

>   
>   		r = 0;
>   		break;
> @@ -1340,7 +1410,6 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
>   {
>   	struct vcpu_set_singleshot_timer oneshot;
>   	struct x86_exception e;
> -	s64 delta;
>   
>   	if (!kvm_xen_timer_enabled(vcpu))
>   		return false;
> @@ -1374,13 +1443,7 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
>   			return true;
>   		}
>   
> -		delta = oneshot.timeout_abs_ns - get_kvmclock_ns(vcpu->kvm);
> -		if ((oneshot.flags & VCPU_SSHOTTMR_future) && delta < 0) {
> -			*r = -ETIME;
> -			return true;
> -		}
> -
> -		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, delta);
> +		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, false);
>   		*r = 0;
>   		return true;
>   
> @@ -1404,25 +1467,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_vcpu *vcpu, uint64_t timeout,
>   		return false;
>   
>   	if (timeout) {
> -		uint64_t guest_now = get_kvmclock_ns(vcpu->kvm);
> -		int64_t delta = timeout - guest_now;
> -
> -		/* Xen has a 'Linux workaround' in do_set_timer_op() which
> -		 * checks for negative absolute timeout values (caused by
> -		 * integer overflow), and for values about 13 days in the
> -		 * future (2^50ns) which would be caused by jiffies
> -		 * overflow. For those cases, it sets the timeout 100ms in
> -		 * the future (not *too* soon, since if a guest really did
> -		 * set a long timeout on purpose we don't want to keep
> -		 * churning CPU time by waking it up).
> -		 */
> -		if (unlikely((int64_t)timeout < 0 ||
> -			     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
> -			delta = 100 * NSEC_PER_MSEC;
> -			timeout = guest_now + delta;
> -		}
> -
> -		kvm_xen_start_timer(vcpu, timeout, delta);
> +		kvm_xen_start_timer(vcpu, timeout, true);
>   	} else {
>   		kvm_xen_stop_timer(vcpu);
>   	}


