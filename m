Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DE3602865
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 11:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJRJdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 05:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiJRJdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 05:33:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56FAAE851
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 02:33:08 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so13488666pjb.2
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 02:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bLrTDO8sbDMJpKqPVs7xaOA9KswS0i+mcC6NJxj138w=;
        b=Ys+VT8eGMrV/NOfZQoO+rjRoG+05LBQTT/RNgBdoVUmZ+vJZz578rtE5BvQEbI4MmY
         WAXy3rAh8X20HYFuniUji7/jgU9/UKB5vPYJ0cQ3TgIrHWVMtmvvqEN1FwUcUR4g8ugP
         oHQ3BH2YFSX5gNYYDK4nZq89baitJ5kIlQrUnGf77mutjHOIzCkaJhHtwBFXZ8Fmj/Yu
         csng0fkkk68v7VBYGojFOetD0m2UU8XYFIKRRqRtKHw3rZn0DDOKTQi7+WCKXVZCjPrT
         uyCYvthC0WQmrc8s5OyBgnbl7/vnluEu0v5dnAmAjS45YQEiSNzwlzrlO8ycdSDcnnSI
         eEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLrTDO8sbDMJpKqPVs7xaOA9KswS0i+mcC6NJxj138w=;
        b=zcTo6VgHI3GyG4TDIoJWDQFevU1fztXeuPYCBtOVtydKh9fsowJkcfVDr2EdSm5E01
         aBT66ynurPCqLswY9B6y6ZIbowqV6ga5B8/2YsqrJXgSgAAf1bWzr+z/L9dhbhSd48wl
         cmj4sxt+UkAr4vJSlMvcmcBhVe8u2WgyRChc8t8QN7KsOuCX92D0CUfK0AJfRoD8ydh9
         Nje2umBEAZsZ7+++rh+aF3yOoNqGqRCDgBICT2DhtXNr5ZkTB2BnMkLG1u8RQ7EC2U2r
         8166f2ksnVii/r+rts69hSeCGJO+nprbXKjvNPAxuDqeBoMBlnWmjboGNUewFazzaJ5z
         D5Gg==
X-Gm-Message-State: ACrzQf0/Ss384A80KmpK2slTzDAbF0pwoByhEgQ7/qAniIJjBVRTKipp
        XURNNoSVvdVBu/J3q9qvQvo=
X-Google-Smtp-Source: AMsMyM4ic5obSolQDBKRCgOIoaz0fSfWbM7h50BNE39gvrGLfVsaiveYFvc0Ci6dFrh7342ZU81/3A==
X-Received: by 2002:a17:902:d2c3:b0:185:3bda:46f8 with SMTP id n3-20020a170902d2c300b001853bda46f8mr2077945plc.58.1666085588265;
        Tue, 18 Oct 2022 02:33:08 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090a348e00b001f2ef3c7956sm11033514pjb.25.2022.10.18.02.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 02:33:07 -0700 (PDT)
Message-ID: <4b9d7939-ebd5-385d-d0cc-e95955e0238f@gmail.com>
Date:   Tue, 18 Oct 2022 17:32:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com> <Yz4GtqyPIMCMsUEl@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yz4GtqyPIMCMsUEl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All applied except pmu_clear_global_status_safe(). Thanks.

On 6/10/2022 6:35 am, Sean Christopherson wrote:
> On Fri, Aug 19, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> For most unit tests, the basic framework and use cases which test
>> any PMU counter do not require any changes, except for two things:
>>
>> - No access to registers introduced only in PMU version 2 and above;
>> - Expanded tolerance for testing counter overflows
>>    due to the loss of uniform control of the gloabl_ctrl register
>>
>> Adding some pmu_version() return value checks can seamlessly support
>> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
> 
> Phrase this as a command so that it's crystal clear that this is what the patch
> does, as opposed to what the patch _can_ do.
> 
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>>   1 file changed, 43 insertions(+), 21 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 25fafbe..826472c 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -125,14 +125,19 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
>>   
>>   static void global_enable(pmu_counter_t *cnt)
>>   {
>> -	cnt->idx = event_to_global_idx(cnt);
>> +	if (pmu_version() < 2)
> 
> Helper please.
> 
>> +		return;
>>   
>> +	cnt->idx = event_to_global_idx(cnt);
>>   	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
>>   			(1ull << cnt->idx));
>>   }
>>   
>>   static void global_disable(pmu_counter_t *cnt)
>>   {
>> +	if (pmu_version() < 2)
>> +		return;
>> +
>>   	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
>>   			~(1ull << cnt->idx));
>>   }
>> @@ -301,7 +306,10 @@ static void check_counter_overflow(void)
>>   	count = cnt.count;
>>   
>>   	/* clear status before test */
>> -	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
>> +	if (pmu_version() > 1) {
> 
> Should be a helper to use from an earlier patch.
> 
> Hmm, looking forward, maybe have an upper level helper?  E.g.
> 
>    void pmu_clear_global_status_safe(void)
>    {
> 	if (!exists)
> 		return
> 
> 	wrmsr(...);
>    }
> 
> Ignore this suggestion if these checks go away in the future.
> 
>> +		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>> +		      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
>> +	}
>>   
>>   	report_prefix_push("overflow");
>>   
>> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>>   			cnt.config &= ~EVNTSEL_INT;
>>   		idx = event_to_global_idx(&cnt);
>>   		__measure(&cnt, cnt.count);
>> -		report(cnt.count == 1, "cntr-%d", i);
>> +
>> +		report(check_irq() == (i % 2), "irq-%d", i);
>> +		if (pmu_version() > 1)
> 
> Helper.
> 
>> +			report(cnt.count == 1, "cntr-%d", i);
>> +		else
>> +			report(cnt.count < 4, "cntr-%d", i);
>> +
>> +		if (pmu_version() < 2)
> 
> Helper.
> 
>> +			continue;
>> +
>>   		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>>   		report(status & (1ull << idx), "status-%d", i);
>>   		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
>>   		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>>   		report(!(status & (1ull << idx)), "status clear-%d", i);
>> -		report(check_irq() == (i % 2), "irq-%d", i);
>>   	}
>>   
>>   	report_prefix_pop();
>> @@ -440,8 +456,10 @@ static void check_running_counter_wrmsr(void)
>>   	report(evt.count < gp_events[1].min, "cntr");
>>   
>>   	/* clear status before overflow test */
>> -	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>> -	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
>> +	if (pmu_version() > 1) {
> 
> Helper.  Curly braces aren't necessary.
> 
>> +		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>> +			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
>> +	}
>>   
>>   	start_event(&evt);
>>   
>> @@ -453,8 +471,11 @@ static void check_running_counter_wrmsr(void)
>>   
>>   	loop();
>>   	stop_event(&evt);
>> -	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>> -	report(status & 1, "status");
>> +
>> +	if (pmu_version() > 1) {
> 
> Helper.
> 
>> +		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>> +		report(status & 1, "status");
> 
> Can you opportunistically provide a better message than "status"?
> 
>> +	}
>>   
>>   	report_prefix_pop();
>>   }
>> @@ -474,8 +495,10 @@ static void check_emulated_instr(void)
>>   	};
>>   	report_prefix_push("emulated instruction");
>>   
>> -	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>> -	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
>> +	if (pmu_version() > 1) {
> 
> Helper, no curly braces.  Ah, IIRC, kernel perf prefers curly braces if the code
> spans multiple lines.  KVM and KUT does not.

OK.

> 
>> +		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>> +			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
>> +	}
>>   
>>   	start_event(&brnch_cnt);
>>   	start_event(&instr_cnt);
>> @@ -509,7 +532,8 @@ static void check_emulated_instr(void)
>>   		:
>>   		: "eax", "ebx", "ecx", "edx");
>>   
>> -	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> +	if (pmu_version() > 1)
> 
> Helper.
> 
>> +		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>>   
>>   	stop_event(&brnch_cnt);
>>   	stop_event(&instr_cnt);
>> @@ -520,10 +544,13 @@ static void check_emulated_instr(void)
>>   	       "instruction count");
>>   	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
>>   	       "branch count");
>> -	// Additionally check that those counters overflowed properly.
>> -	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>> -	report(status & 1, "instruction counter overflow");
>> -	report(status & 2, "branch counter overflow");
>> +
>> +	if (pmu_version() > 1) {
> 
> Helper?  E.g. if this is a "has architectural PMU".

Nit, "intel arch pmu" means "version > 0".

> 
>> +		// Additionally check that those counters overflowed properly.
>> +		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
>> +		report(status & 1, "instruction counter overflow");
>> +		report(status & 2, "branch counter overflow");
>> +	}
>>   
>>   	report_prefix_pop();
>>   }
>> @@ -647,12 +674,7 @@ int main(int ac, char **av)
>>   	buf = malloc(N*64);
>>   
>>   	if (!pmu_version()) {
>> -		report_skip("No pmu is detected!");
>> -		return report_summary();
>> -	}
>> -
>> -	if (pmu_version() == 1) {
>> -		report_skip("PMU version 1 is not supported.");
>> +		report_skip("No Intel Arch PMU is detected!");
>>   		return report_summary();
>>   	}
>>   
>> -- 
>> 2.37.2
>>
