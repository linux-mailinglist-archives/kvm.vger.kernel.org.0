Return-Path: <kvm+bounces-1613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9717EA246
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 18:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5BD31F22054
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 17:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FE122EF8;
	Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Au8GcURq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AEE22EE4
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 17:43:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD5110E5
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 09:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699897419;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YvkSxf3ewcy3zoHK2JkOgmeXH15mWkzKpCFxC9BiXS8=;
	b=Au8GcURqOeSVhzJhbRHXXZ11A4Vf/UAN3irTlllYwCqESPzv1q7uOhcDQEcZqhe3goF7ea
	Gka6xft2paQTwe07nS57pp8aX8MIIRkGEPhxIO7sklf4VUpWbgAYYPULKH0L9/hi2943q/
	7w8k2hL6ca/J3hRcbetiKwoSeTG511E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-CIblTyGSMBCVx68HxhrpLw-1; Mon, 13 Nov 2023 12:43:37 -0500
X-MC-Unique: CIblTyGSMBCVx68HxhrpLw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-778a455f975so566154685a.1
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 09:43:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699897417; x=1700502217;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YvkSxf3ewcy3zoHK2JkOgmeXH15mWkzKpCFxC9BiXS8=;
        b=ASE1zcqi5Ez91Wmlvamuf2/pTouPJGCeBKkSJ8QSJTqLWYADoOwLor9l6L/3ldl6WP
         yyoBwDi3dafXXkr746RPolaZlNsKWGKdJeX2aMq8lb0OT/oNqwL1CqX/wSqmPsKwq4J/
         65RlUXG22e/w5t0YgATR9YR1h+KXeGjFcBsDkwbEGELg2tjQeMzfy91GIYk/zmzYG5mI
         StVz3rY1m0CAakV9uCIEWYTFvyyiEKh0UAU0syOnfREdIH8/VrSxs22u2fKL0AwpFDo/
         XA5vsBPE99ouHIIMzbZwkr/h73ViGWrlYppdOWqE6sNZajAVGDdiuyVmwy693p15koYo
         ALTw==
X-Gm-Message-State: AOJu0YwZyFM2ZD8Tg7+blCHb+PVMWYqeuJFuK3kxwAGecqewbN0nbly2
	aPYLT5NMqaLQLs7jSDgEmFN0Yp8ccbZMss4sRMMvFLRLDpdgGr9+C0tjvtrJc3hQEjuL99rgmUl
	/If7NCtTBpLAw
X-Received: by 2002:a05:620a:4547:b0:76d:83ae:fdcd with SMTP id u7-20020a05620a454700b0076d83aefdcdmr9650196qkp.57.1699897417068;
        Mon, 13 Nov 2023 09:43:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpIZI1S+uAcOWfb9yLj/DlHgpmgdzKaNqsG9rNbCZvKxXLgGb3eXpQ6ty/BHzcYp4VPmNw1g==
X-Received: by 2002:a05:620a:4547:b0:76d:83ae:fdcd with SMTP id u7-20020a05620a454700b0076d83aefdcdmr9650175qkp.57.1699897416705;
        Mon, 13 Nov 2023 09:43:36 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id b23-20020a05620a271700b007759a81d88esm2017985qkp.50.2023.11.13.09.43.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 09:43:35 -0800 (PST)
Message-ID: <669ac85b-1271-40af-a594-83b737f2f5ea@redhat.com>
Date: Mon, 13 Nov 2023 18:43:32 +0100
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
 <ZUpEPbILA-idXISd@monolith> <78773d4c-21b6-4366-a1ec-da42286d2458@redhat.com>
 <ZUpX9VIlCB169opb@monolith>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZUpX9VIlCB169opb@monolith>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 11/7/23 16:29, Alexandru Elisei wrote:
> Hi,
>
> On Tue, Nov 07, 2023 at 03:28:12PM +0100, Eric Auger wrote:
>>
>> On 11/7/23 15:05, Alexandru Elisei wrote:
>>> On Tue, Nov 07, 2023 at 02:34:05PM +0100, Eric Auger wrote:
>>>> Hi Alexandru,
>>>>
>>>> On 11/7/23 10:52, Alexandru Elisei wrote:
>>>>> Hi Eric,
>>>>>
>>>>> On Fri, Nov 03, 2023 at 11:01:39AM +0100, Eric Auger wrote:
>>>>>> On some hardware, some pmu-overflow-interrupt failures can be observed.
>>>>>> Although the even counter overflows, the interrupt is not seen as
>>>>>> expected. This happens in the subtest after "promote to 64-b" comment.
>>>>>> After analysis, the PMU overflow interrupt actually hits, ie.
>>>>>> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
>>>>>> as expected. However the PMCR.E is reset by the handle_exit path, at
>>>>>> kvm_pmu_handle_pmcr() before the next guest entry and
>>>>>> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
>>>>>> There, since the enable bit has been reset, kvm_pmu_update_state() does
>>>>>> not inject the interrupt into the guest.
>>>>>>
>>>>>> This does not seem to be a KVM bug but rather an unfortunate
>>>>>> scenario where the test disables the PMCR.E too closely to the
>>>>>> advent of the overflow interrupt.
>>>>> If I understand correctly, the KVM PMU, after receiving the hardware PMUIRQ and
>>>>> before injecting the interrupt, checks that the PMU is enabled according to the
>>>>> pseudocode for the function CheckForPMUOverflow(). CheckForPMUOverflow() returns
>>>>> false because PMCR_EL1.E is 0, so the KVM PMU decides not to inject the
>>>>> interrupt.
>>>>>
>>>>> Is that correct?
>>>> Yes that's correct
>>>>> Changing the number of SW_INCR events might not be optimal - for example,
>>>>> COUNT_INT > 100 might hide an error that otherwise would have been triggered if
>>>>> the number of events were 100. Not very likely, but still a possibility.
>>>> I also changed the COUNT for SW_INCR events to unify the code. However
>>>> this is not strictly necessary to fix the issue I encounter. I can
>>>> revert that change if you prefer.
>>> I don't understand how that would solve the problem. As I see it, the problem is
>>> that PMCR_EL1.E is cleared too fast after the PMU asserts the interrupt on
>>> overflow, not the time it takes to get to the overflow condition (i.e, the
>>> number of iterations mem_access_loop() does).
>> sorry I did not make my point clear. Indeed wrt SW_INCR overflow testing
>> I do not intend to fix any issue by this change. I just intended to use
>> the same number of iterations as for mem_access. So I will revert that
>> change.
>>>>> Another approach would be to wait for a set amount of time for the CPU to take
>>>>> the interrupt. There's something similar in timer.c::{test_timer_tval(),
>>>>> timer_do_wfi()}.
>>>> you're right. However this would urge me to have a separate asm code
>>>> that loops with wfi after doing the mem_access loop. I am not sure this
>>>> is worth the candle here?
>>> I think plain C would work, I was thinking something like this:
>>>
>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>> index a91a7b1fd4be..fb2eb5fa2e50 100644
>>> --- a/arm/pmu.c
>>> +++ b/arm/pmu.c
>>> @@ -979,6 +979,23 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>         /* interrupts are disabled (PMINTENSET_EL1 == 0) */
>>>
>>>         mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> Currently PMCR_E is reset by mem_access_loop() (at msr pmcr_el0,
>> xzr\n"). so if we want to introduce a delay between the overflow
>> interrupt and the PMCR.E disable, we need to either add extra MEM_ACCESS
>> or do wfi within mem_access_loop()
> Sorry, missed that.
>
>> Or we do something like what you suggest below and reset the PMCR_E
>> afterwards with the downside to add extra code execution accounted by
>> the PMU. I would prefer to avoid that since the purpose of having the
>> asm code was to "master" what we measure.
> Just an idea, we could re-enable the PMU in the C function right after the
> mem_loop(), which will get trapped and KVM will probably inject the
> interrupt because according to CheckForPMUOverflow() the PMUIRQ should be
> asserted.  This is just a theory, haven't tested this and haven't looked at
> the KVM code.

Yes it does but you still need to leave time for the guest to aknowledge
the interrupt, with intrusiveness wrt counting.

Adding traces or even adding the volatile pmu_stats change the timings
and sometimes the error cannot be encountered anymore.
Adding the wait loop would probably be nicer but it also disturbs the
PMU counting so I am inclined to keep things simple and just
increase the mem_access_loop count to let the IRQ being processed by KVM
with PMU enable bit still set. This does not change the functionality of
the test and this fixes failures on Amberwing.

Thanks

Eric
>
> I still think we should have the wait loop after re-enabling the PMU, just
> so the test is architecturally compliant (i.e., interrupts are not
> delivered instantaneously after the device asserts the interrupt to the
> GIC), but that could be left as an exercise for another patch.
>
> Thanks,
> Alex
>
>>> +
>>> +       if (!expect_interrupts(0)) {
>>> +                for (i = 0; i < 10; i++) {
>>> +                       local_irq_disable();
>>> +                       if (expect_interrupts(0)) {
>>> +                               local_irq_enable();
>>> +                               break;
>>> +                       }
>>> +                       report_info("waiting for interrupt...");
>>> +                       wfi();
>>> +                       local_irq_enable();
>>> +                       if (expect_interrupts(0))
>>> +                               break;
>>> +                        mdelay(100);
>>> +                }
>>> +       }
>>> +
>>>         report(expect_interrupts(0), "no overflow interrupt after preset");
>>>
>>>         set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>
>>> Can be cleaned up by moving it to separate function, etc. Has the downside that
>>> it may performs extra memory accesses in expect_interrupts(). Your choice.
>>>
>>> By the way, pmu_stats is not declared volatile, which means that the
>>> compiler is free to optimize accesses to the struct by caching previously
>>> read values in registers. Have you tried declaring it as volatile, in case
>>> that fixes the issues you were seeing?
>> In my case it won't fix the issue because the stats match what happens
>> but your suggestion makes total sense in general.
>>
>> I will add that.
>>
>> Eric
>>> If you do decide to go with the above suggestion, I strongly suggest
>>> pmu_stats is declared as volatile, otherwise the compiler will likely end
>>> up not reading from memory on every iteration.
>>>
>>> Thanks,
>>> Alex
>>>> Thanks!
>>>>
>>>> Eric
>>>>> Thanks,
>>>>> Alex
>>>>>
>>>>>> Since it looks like a benign and inlikely case, let's resize the number
>>>>>> of iterations to prevent the PMCR enable bit from being resetted
>>>>>> at the same time as the actual overflow event.
>>>>>>
>>>>>> COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
>>>>>> used in this test.
>>>>>>
>>>>>> Reported-by: Jan Richter <jarichte@redhat.com>
>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>> ---
>>>>>>  arm/pmu.c | 15 ++++++++-------
>>>>>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>>>> index a91a7b1f..acd88571 100644
>>>>>> --- a/arm/pmu.c
>>>>>> +++ b/arm/pmu.c
>>>>>> @@ -66,6 +66,7 @@
>>>>>>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>>>>>>  #define COUNT 250
>>>>>>  #define MARGIN 100
>>>>>> +#define COUNT_INT 1000
>>>>>>  /*
>>>>>>   * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
>>>>>>   * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
>>>>>> @@ -978,13 +979,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>>>  
>>>>>>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>>>>>>  
>>>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>>>>>>  
>>>>>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>>  	isb();
>>>>>>  
>>>>>> -	for (i = 0; i < 100; i++)
>>>>>> +	for (i = 0; i < COUNT_INT; i++)
>>>>>>  		write_sysreg(0x2, pmswinc_el0);
>>>>>>  
>>>>>>  	isb();
>>>>>> @@ -1002,15 +1003,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>>>  	write_sysreg(ALL_SET_32, pmintenset_el1);
>>>>>>  	isb();
>>>>>>  
>>>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>>  
>>>>>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>>  	isb();
>>>>>>  
>>>>>> -	for (i = 0; i < 100; i++)
>>>>>> +	for (i = 0; i < COUNT_INT; i++)
>>>>>>  		write_sysreg(0x3, pmswinc_el0);
>>>>>>  
>>>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro);
>>>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
>>>>>>  	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
>>>>>>  	report(expect_interrupts(0x3),
>>>>>>  		"overflow interrupts expected on #0 and #1");
>>>>>> @@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>>>>>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>>>>>>  	isb();
>>>>>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>>  	report(expect_interrupts(0x1), "expect overflow interrupt");
>>>>>>  
>>>>>>  	/* overflow on odd counter */
>>>>>> @@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>>>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>>>>>>  	write_regn_el0(pmevcntr, 1, all_set);
>>>>>>  	isb();
>>>>>> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>>>>>  	if (overflow_at_64bits) {
>>>>>>  		report(expect_interrupts(0x1),
>>>>>>  		       "expect overflow interrupt on even counter");
>>>>>> -- 
>>>>>> 2.41.0
>>>>>>


