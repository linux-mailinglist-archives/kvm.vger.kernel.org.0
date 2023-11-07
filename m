Return-Path: <kvm+bounces-887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFCF7E401B
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:34:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B6631C20B1B
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 13:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D7130CF3;
	Tue,  7 Nov 2023 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWFbmB3n"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184342FE3A
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 13:34:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F3C93
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 05:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699364050;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1cJRt9Hh1gkpWx/pnSymwGngN5HgV0e76oVuw4mSbHI=;
	b=VWFbmB3nNQOc0QY8uCRG90KgeKzK1Rk8BZEUdKG5izrjWi+j+RqVnY07bzFBhu2gnbSTAz
	eGH6cPyMuAN9bNB3YAFB5L5YVlNctpMri7HnklpjgSn0NDA82/+KPFuUtyMKCAWw1/p9Rf
	d3prqBErmA6a+M3I2N2XfMCI1Q6tOKs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-B7lxO7uGPVm2jca4fQO7pg-1; Tue, 07 Nov 2023 08:34:09 -0500
X-MC-Unique: B7lxO7uGPVm2jca4fQO7pg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-66d12b547e2so73655986d6.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 05:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699364049; x=1699968849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1cJRt9Hh1gkpWx/pnSymwGngN5HgV0e76oVuw4mSbHI=;
        b=gx7PX1i32/90qdr5jcKQnmirWL8QcCR9d6QHVU0EKJLB4sMn6kry5DC9iZlSgIx2+u
         bj6mJDXg9ijuFzYFX8XfD8ILa79yKApvllBmX3cCpIiIJ83KpQAwr9pMYkCplofHMFT4
         Wi5f5Ye1iadLOe2/lswWfYBKkGw1yFXDwneOr8ByI2N2fH3AU33gT36Q8R4w1sY90MMn
         HStDO3I3iMEi1WY9Tf9djkPJIg5BWcP3fmr2Jut2XKMgSC3G79KsG9/fsVwVQFh3CqBm
         9F9OPtT31ygnFv/JxLWALc60CoUy4+afCaPtdGzK6s6xzRNT7zfx3ZAwgf+pL36TyEUT
         1xEw==
X-Gm-Message-State: AOJu0YwaMNW9r9lKnVbW+ZnI2MqQ7FJHFP/XL37hTAM40uoAHAXiUWyJ
	e78qAiZa1JEWm9hhr1OadEIroLkMZpeqmCJhYtPzMiREmth5M1o4/qzViXrAh3N4iA7WkBxcsor
	aeyWy3azfSSVV
X-Received: by 2002:ad4:5f4f:0:b0:66d:5020:ef67 with SMTP id p15-20020ad45f4f000000b0066d5020ef67mr35107102qvg.36.1699364048869;
        Tue, 07 Nov 2023 05:34:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFOHDTf/8Ys7QRuX1rOCxSBHQ0XTcoY4xrEjdDPKhgk93uz0BhrvPTMIV1q/WLSzYssdcAOaA==
X-Received: by 2002:ad4:5f4f:0:b0:66d:5020:ef67 with SMTP id p15-20020ad45f4f000000b0066d5020ef67mr35107079qvg.36.1699364048590;
        Tue, 07 Nov 2023 05:34:08 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g9-20020ad45109000000b0066cf2423c79sm4358222qvp.139.2023.11.07.05.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 05:34:08 -0800 (PST)
Message-ID: <5d93f447-c2c5-4c41-b0ea-9108736a2372@redhat.com>
Date: Tue, 7 Nov 2023 14:34:05 +0100
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
 <ZUoIxznZwPyti254@monolith>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZUoIxznZwPyti254@monolith>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 11/7/23 10:52, Alexandru Elisei wrote:
> Hi Eric,
>
> On Fri, Nov 03, 2023 at 11:01:39AM +0100, Eric Auger wrote:
>> On some hardware, some pmu-overflow-interrupt failures can be observed.
>> Although the even counter overflows, the interrupt is not seen as
>> expected. This happens in the subtest after "promote to 64-b" comment.
>> After analysis, the PMU overflow interrupt actually hits, ie.
>> kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
>> as expected. However the PMCR.E is reset by the handle_exit path, at
>> kvm_pmu_handle_pmcr() before the next guest entry and
>> kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
>> There, since the enable bit has been reset, kvm_pmu_update_state() does
>> not inject the interrupt into the guest.
>>
>> This does not seem to be a KVM bug but rather an unfortunate
>> scenario where the test disables the PMCR.E too closely to the
>> advent of the overflow interrupt.
> If I understand correctly, the KVM PMU, after receiving the hardware PMUIRQ and
> before injecting the interrupt, checks that the PMU is enabled according to the
> pseudocode for the function CheckForPMUOverflow(). CheckForPMUOverflow() returns
> false because PMCR_EL1.E is 0, so the KVM PMU decides not to inject the
> interrupt.
>
> Is that correct?

Yes that's correct
>
> Changing the number of SW_INCR events might not be optimal - for example,
> COUNT_INT > 100 might hide an error that otherwise would have been triggered if
> the number of events were 100. Not very likely, but still a possibility.
I also changed the COUNT for SW_INCR events to unify the code. However
this is not strictly necessary to fix the issue I encounter. I can
revert that change if you prefer.
>
> Another approach would be to wait for a set amount of time for the CPU to take
> the interrupt. There's something similar in timer.c::{test_timer_tval(),
> timer_do_wfi()}.
you're right. However this would urge me to have a separate asm code
that loops with wfi after doing the mem_access loop. I am not sure this
is worth the candle here?

Thanks!

Eric
>
> Thanks,
> Alex
>
>> Since it looks like a benign and inlikely case, let's resize the number
>> of iterations to prevent the PMCR enable bit from being resetted
>> at the same time as the actual overflow event.
>>
>> COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
>> used in this test.
>>
>> Reported-by: Jan Richter <jarichte@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/pmu.c | 15 ++++++++-------
>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index a91a7b1f..acd88571 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -66,6 +66,7 @@
>>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>>  #define COUNT 250
>>  #define MARGIN 100
>> +#define COUNT_INT 1000
>>  /*
>>   * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
>>   * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
>> @@ -978,13 +979,13 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>  
>>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>>  
>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>>  
>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>  	isb();
>>  
>> -	for (i = 0; i < 100; i++)
>> +	for (i = 0; i < COUNT_INT; i++)
>>  		write_sysreg(0x2, pmswinc_el0);
>>  
>>  	isb();
>> @@ -1002,15 +1003,15 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>  	write_sysreg(ALL_SET_32, pmintenset_el1);
>>  	isb();
>>  
>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>  
>>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>  	isb();
>>  
>> -	for (i = 0; i < 100; i++)
>> +	for (i = 0; i < COUNT_INT; i++)
>>  		write_sysreg(0x3, pmswinc_el0);
>>  
>> -	mem_access_loop(addr, 200, pmu.pmcr_ro);
>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
>>  	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
>>  	report(expect_interrupts(0x3),
>>  		"overflow interrupts expected on #0 and #1");
>> @@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>>  	isb();
>> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>  	report(expect_interrupts(0x1), "expect overflow interrupt");
>>  
>>  	/* overflow on odd counter */
>> @@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>  	write_regn_el0(pmevcntr, 0, pre_overflow);
>>  	write_regn_el0(pmevcntr, 1, all_set);
>>  	isb();
>> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>> +	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>>  	if (overflow_at_64bits) {
>>  		report(expect_interrupts(0x1),
>>  		       "expect overflow interrupt on even counter");
>> -- 
>> 2.41.0
>>


