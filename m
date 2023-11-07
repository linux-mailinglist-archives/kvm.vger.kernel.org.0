Return-Path: <kvm+bounces-892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57CF57E41CC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DD72281117
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8B73158C;
	Tue,  7 Nov 2023 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z0br5Ufz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E7430FB2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:28:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DD0C1
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 06:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699367299;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQz7XDRqpRcOvl1El/TeTwltdvqTAcyN8GLW2xo3nRI=;
	b=Z0br5UfzE+RDrgfodAJyJ8WfLjfZNYjizUINd6u1sPlEsI69khSEbqMXkxAuuF+IU3813Q
	hFqCObvy3rNRa+h/1fudkVGPThhHqw3NnuVp1Cj2fZBCpy/H5iNNwbGr7WKOhOCdb6JoLb
	v5Zyd2WdJuaRmPYrpmIY4c3xawijjng=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-D8brIUHcOt6T8PYSJfpphg-1; Tue, 07 Nov 2023 09:28:18 -0500
X-MC-Unique: D8brIUHcOt6T8PYSJfpphg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-66d1e755077so71057586d6.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 06:28:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699367297; x=1699972097;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yQz7XDRqpRcOvl1El/TeTwltdvqTAcyN8GLW2xo3nRI=;
        b=uGUg66dBeX91eltQ/kC06FGBSjVwcqTuhW+Qnd8EQF7n+ZtW0WcLTkbSb4XJT8dGmK
         FLU4nWlbwU9qtkheLgL1L7w35WsJttezNxi7G90TVkpAiq9GTDZh1HqTh1rEzCSHqDBh
         GvlUXCWxj/wS6dXc8/En5v1NYLXETi/JzzKK64NdTb5IcG0WU2ZbgTQQ8AqHlxz7IDDK
         26/rc2WX/v+F02/4UODyshtPhUnYnlCxQfvZ9iGpUjwYSVT1gMIUS0Y5eyJ5c4nZETaf
         +UAYKognFb7BrrqFCrTs3Dt6yHxJaTn5VI7uNPth0vKAlu5g3Jtg/pYswVv4DkxAkYGt
         veOw==
X-Gm-Message-State: AOJu0Ywqf/O7Fw+shmXh/euJkdhdn1GNiopTZ6WXCHaFaIcFknXaCBnX
	Le7Yor5DK8x3Vsty3BF8QsaN1stHeOXdVzdXKAvvwTSlh9aJ1e49mEiOpMg610xrTzYUwggeG7x
	3wDXy8EvS8N0h
X-Received: by 2002:a05:6214:21e3:b0:66d:2eb6:f3f6 with SMTP id p3-20020a05621421e300b0066d2eb6f3f6mr33303066qvj.32.1699367297374;
        Tue, 07 Nov 2023 06:28:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrhbICCqAcrRSt7nl5/ozJ8pTsPUjIlvisA6dHwVEpq2Z/yEIywToGrfLz5HB582YC0J2ioA==
X-Received: by 2002:a05:6214:21e3:b0:66d:2eb6:f3f6 with SMTP id p3-20020a05621421e300b0066d2eb6f3f6mr33303043qvj.32.1699367297017;
        Tue, 07 Nov 2023 06:28:17 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id e16-20020a056214111000b00670a8921170sm4405134qvs.112.2023.11.07.06.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 06:28:16 -0800 (PST)
Message-ID: <78773d4c-21b6-4366-a1ec-da42286d2458@redhat.com>
Date: Tue, 7 Nov 2023 15:28:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm: pmu-overflow-interrupt: Increase
 count values
Content-Language: en-US
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 andrew.jones@linux.dev, maz@kernel.org, oliver.upton@linux.dev,
 jarichte@redhat.com
References: <20231103100139.55807-1-eric.auger@redhat.com>
 <ZUoIxznZwPyti254@monolith> <5d93f447-c2c5-4c41-b0ea-9108736a2372@redhat.com>
 <ZUpEPbILA-idXISd@monolith>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZUpEPbILA-idXISd@monolith>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/7/23 15:05, Alexandru Elisei wrote:
> On Tue, Nov 07, 2023 at 02:34:05PM +0100, Eric Auger wrote:
>> Hi Alexandru,
>>
>> On 11/7/23 10:52, Alexandru Elisei wrote:
>>> Hi Eric,
>>>
>>> On Fri, Nov 03, 2023 at 11:01:39AM +0100, Eric Auger wrote:
>>>> On some hardware, some pmu-overflow-interrupt failures can be observed.
>>>> Although the even counter overflows, the interrupt is not seen as
>>>> expected. This happens in the subtest after "promote to 64-b" comment.
>>>> After analysis, the PMU overflow interrupt actually hits, ie.
>>>> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
>>>> as expected. However the PMCR.E is reset by the handle_exit path, at
>>>> kvm_pmu_handle_pmcr() before the next guest entry and
>>>> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
>>>> There, since the enable bit has been reset, kvm_pmu_update_state() does
>>>> not inject the interrupt into the guest.
>>>>
>>>> This does not seem to be a KVM bug but rather an unfortunate
>>>> scenario where the test disables the PMCR.E too closely to the
>>>> advent of the overflow interrupt.
>>> If I understand correctly, the KVM PMU, after receiving the hardware PMUIRQ and
>>> before injecting the interrupt, checks that the PMU is enabled according to the
>>> pseudocode for the function CheckForPMUOverflow(). CheckForPMUOverflow() returns
>>> false because PMCR_EL1.E is 0, so the KVM PMU decides not to inject the
>>> interrupt.
>>>
>>> Is that correct?
>> Yes that's correct
>>> Changing the number of SW_INCR events might not be optimal - for example,
>>> COUNT_INT > 100 might hide an error that otherwise would have been triggered if
>>> the number of events were 100. Not very likely, but still a possibility.
>> I also changed the COUNT for SW_INCR events to unify the code. However
>> this is not strictly necessary to fix the issue I encounter. I can
>> revert that change if you prefer.
> I don't understand how that would solve the problem. As I see it, the problem is
> that PMCR_EL1.E is cleared too fast after the PMU asserts the interrupt on
> overflow, not the time it takes to get to the overflow condition (i.e, the
> number of iterations mem_access_loop() does).

sorry I did not make my point clear. Indeed wrt SW_INCR overflow testing
I do not intend to fix any issue by this change. I just intended to use
the same number of iterations as for mem_access. So I will revert that
change.
>
>>> Another approach would be to wait for a set amount of time for the CPU to take
>>> the interrupt. There's something similar in timer.c::{test_timer_tval(),
>>> timer_do_wfi()}.
>> you're right. However this would urge me to have a separate asm code
>> that loops with wfi after doing the mem_access loop. I am not sure this
>> is worth the candle here?
> I think plain C would work, I was thinking something like this:
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index a91a7b1fd4be..fb2eb5fa2e50 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -979,6 +979,23 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>         /* interrupts are disabled (PMINTENSET_EL1 == 0) */
>
>         mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
Currently PMCR_E is reset by mem_access_loop() (at msr pmcr_el0,
xzr\n"). so if we want to introduce a delay between the overflow
interrupt and the PMCR.E disable, we need to either add extra MEM_ACCESS
or do wfi within mem_access_loop()
Or we do something like what you suggest below and reset the PMCR_E
afterwards with the downside to add extra code execution accounted by
the PMU. I would prefer to avoid that since the purpose of having the
asm code was to "master" what we measure.
> +
> +       if (!expect_interrupts(0)) {
> +                for (i = 0; i < 10; i++) {
> +                       local_irq_disable();
> +                       if (expect_interrupts(0)) {
> +                               local_irq_enable();
> +                               break;
> +                       }
> +                       report_info("waiting for interrupt...");
> +                       wfi();
> +                       local_irq_enable();
> +                       if (expect_interrupts(0))
> +                               break;
> +                        mdelay(100);
> +                }
> +       }
> +
>         report(expect_interrupts(0), "no overflow interrupt after preset");
>
>         set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>
> Can be cleaned up by moving it to separate function, etc. Has the downside that
> it may performs extra memory accesses in expect_interrupts(). Your choice.
>
> By the way, pmu_stats is not declared volatile, which means that the
> compiler is free to optimize accesses to the struct by caching previously
> read values in registers. Have you tried declaring it as volatile, in case
> that fixes the issues you were seeing?
In my case it won't fix the issue because the stats match what happens
but your suggestion makes total sense in general.

I will add that.

Eric
>
> If you do decide to go with the above suggestion, I strongly suggest
> pmu_stats is declared as volatile, otherwise the compiler will likely end
> up not reading from memory on every iteration.
>
> Thanks,
> Alex
>> Thanks!
>>
>> Eric
>>> Thanks,
>>> Alex
>>>
>>>> Since it looks like a benign and inlikely case, let's resize the number
>>>> of iterations to prevent the PMCR enable bit from being resetted
>>>> at the same time as the actual overflow event.
>>>>
>>>> COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
>>>> used in this test.
>>>>
>>>> Reported-by: Jan Richter <jarichte@redhat.com>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> ---
>>>>  arm/pmu.c | 15 ++++++++-------
>>>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>> index a91a7b1f..acd88571 100644
>>>> --- a/arm/pmu.c
>>>> +++ b/arm/pmu.c
>>>> @@ -66,6 +66,7 @@
>>>>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>>>>  #define COUNT 250
>>>>  #define MARGIN 100
>>>> +#define COUNT_INT 1000
>>>>  /*
>>>>   * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
>>>>   * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
>>>> @@ -978,13 +979,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>  
>>>>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>>>>  
>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>>>>  
>>>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>  	isb();
>>>>  
>>>> -	for (i = 0; i < 100; i++)
>>>> +	for (i = 0; i < COUNT_INT; i++)
>>>>  		write_sysreg(0x2, pmswinc_el0);
>>>>  
>>>>  	isb();
>>>> @@ -1002,15 +1003,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>  	write_sysreg(ALL_SET_32, pmintenset_el1);
>>>>  	isb();
>>>>  
>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>  
>>>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>  	isb();
>>>>  
>>>> -	for (i = 0; i < 100; i++)
>>>> +	for (i = 0; i < COUNT_INT; i++)
>>>>  		write_sysreg(0x3, pmswinc_el0);
>>>>  
>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro);
>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
>>>>  	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
>>>>  	report(expect_interrupts(0x3),
>>>>  		"overflow interrupts expected on #0 and #1");
>>>> @@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>>>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>>>>  	isb();
>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>  	report(expect_interrupts(0x1), "expect overflow interrupt");
>>>>  
>>>>  	/* overflow on odd counter */
>>>> @@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>>>>  	write_regn_el0(pmevcntr, 1, all_set);
>>>>  	isb();
>>>> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>  	if (overflow_at_64bits) {
>>>>  		report(expect_interrupts(0x1),
>>>>  		       "expect overflow interrupt on even counter");
>>>> -- 
>>>> 2.41.0
>>>>


