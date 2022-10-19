Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B440604307
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 13:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJSLTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 07:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiJSLTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 07:19:21 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC1113F9E;
        Wed, 19 Oct 2022 03:49:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id f140so16859549pfa.1;
        Wed, 19 Oct 2022 03:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/8qW1C2twHakXAIO7wFh1wr81Rnz5XD0HBGrlLreUgU=;
        b=aQo7mP9KDkmS+42vXyowJYLuPqJH+G22wUpcpI3njxMu8S6WOyMPGwOj9rid29vUbK
         aL0j7VGaB2h1zktJuLGWSCGl6sQw5EUAldDgxcj12oYbXucUZmJ/MDqiYJ7ZpKNtWZbj
         Zdczmjg8/JfbZlomiCbq58EtSB9PrJN195AHedtq122FYbgWxv+ThYatFYwMyYGuonRO
         a0KDqBqdfwDmPZgM0/43HCMY5kYibf5h5/2io0N+oCU4dx4j281Si01w5sesa9hK/+km
         b3vGNMes/+piTXIpJXFAMsZMK32y5OCMLPOX4KBpyWDSa1W00aAvV1d8bJMRYhkqgeGQ
         Gx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/8qW1C2twHakXAIO7wFh1wr81Rnz5XD0HBGrlLreUgU=;
        b=hX7ewAJbUxkEd7fCYN+Iytm+SEW7mnaIV3swxJWo0woHx19n36bLyyT/rGoQtdOxj8
         fCKcEFD8DjwVLIbUrolE9An84ep4VQCSpARi+ONtHt/p4ki+Ub+wA5S75NkxT6KavGFM
         6EWQOQ/xR1JZwO2gIQHzJiubkb+woNulxMGV4dtC55I4fYaYT6cJ43CnBVM/aoGYF3fZ
         lLHu5tzai72EKefpZoscGw1Z/Jmt9/etEczGSvR6mYkXH+ihE21L14RoAOW4i4WfFCsa
         bJvcPgVb0iL35O3XRoUoCUcFgXSMkNasmhFf9MFcs+HQuBSrJMlAaP3g5oKWEaAOA/AY
         RiEA==
X-Gm-Message-State: ACrzQf3HXpBEh9SCjMdXO2Qwui44OOMzkm1A1ePsH5KzFZkmE8x2bRaH
        NXs+ph/DOCCdcfLKJjMw6gq2IETIN2M3Bg==
X-Google-Smtp-Source: AMsMyM47wurErcf4L3jsLGhlAqgC/Acnw8j3MMI3JeSi3OowTynB3DyWP3EPCJK3aJAIVUaa2Q8MbQ==
X-Received: by 2002:a63:8648:0:b0:461:722b:ffc8 with SMTP id x69-20020a638648000000b00461722bffc8mr6638480pgd.118.1666172460783;
        Wed, 19 Oct 2022 02:41:00 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z7-20020a1709027e8700b00172f4835f53sm10269851pla.192.2022.10.19.02.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 02:41:00 -0700 (PDT)
Message-ID: <6b852e8d-39f1-4baf-74f5-f98dd9f4e371@gmail.com>
Date:   Wed, 19 Oct 2022 17:40:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [kvm-unit-tests PATCH 2/2] x86/pmu: Add AMD Guest PerfMonV2
 testcases
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-7-likexu@tencent.com> <Yz4AZZWE1/wWhXFP@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yz4AZZWE1/wWhXFP@google.com>
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

All applied, thanks.

On 6/10/2022 6:08 am, Sean Christopherson wrote:
> Can you provide a single series for all of the KVM-Unit-Tests PMU work (separate
> from the KVM patches)?  Ya, it'll be big and is a blatant violation of "do one
> thing", but trying to manually handle the dependencies on the review side is time
> consuming.

Thanks for your time. PMU test cases will be combined, if no new ideas emerge.

> 
> One thought to help keep track of dependencies between KVM and KUT would be to
> add dummy commits between each sub-series, with the dummy commit containing a lore
> link to the relevant KVM patches/series.  That would allow throwing everything into
> one series without losing track of things.  Hopefully.

Sure, adding a lore link to a cover letter is always helpful. It seems that the 
ageing KVM project
has moved to a test-driven approach to development, and any new developer should 
be aware
of this rule.

> 
> On Mon, Sep 05, 2022, Like Xu wrote:
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 9c490d9..b9592c4 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -796,8 +796,12 @@ static inline void flush_tlb(void)
>>   
>>   static inline u8 pmu_version(void)
>>   {
>> -	if (!is_intel())
>> +	if (!is_intel()) {
>> +		/* Performance Monitoring Version 2 Supported */
>> +		if (cpuid(0x80000022).a & 0x1)
> 
> Add an X86_FEATURE_*, that way this is self-documenting.
> 
>> +			return 2;
>>   		return 0;
>> +	}
>>   
>>   	return cpuid(10).a & 0xff;
>>   }
>> @@ -824,6 +828,9 @@ static inline u8 pmu_nr_gp_counters(void)
>>   {
>>   	if (is_intel()) {
>>   		return (cpuid(10).a >> 8) & 0xff;
>> +	} else if (this_cpu_has_perf_global_ctrl()) {
> 
> Eww.  Took me too long to connect the dots to understand how this guarantees that
> leaf 0x80000022 is available.  With an X86_FEATURE_* this can simply be:
> 
> 	} else if (this_cpu_has(X86_FEATURE_AMD_PMU_V2) {
> 
> or whatever name is appropriate.
> 
>> +		/* Number of Core Performance Counters. */
>> +		return cpuid(0x80000022).b & 0xf;
>>   	} else if (!has_amd_perfctr_core()) {
>>   		return AMD64_NUM_COUNTERS;
>>   	}
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 11607c0..6d5363b 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -72,6 +72,9 @@ struct pmu_event {
>>   #define PMU_CAP_FW_WRITES	(1ULL << 13)
>>   static u32 gp_counter_base;
>>   static u32 gp_select_base;
>> +static u32 global_status_msr;
>> +static u32 global_ctl_msr;
>> +static u32 global_status_clr_msr;
> 
> What do you think about naming these like MSR #defines?  E.g.
> 
>    MSR_PERF_GLOBAL_CTRL
>    MSR_PERF_GLOBAL_STATUS
>    MSR_PERF_GLOBAL_STATUS_CLR
> 
> There's a little risk of causing confusing, but I think it would make the code
> easier to read.

Lowercase variable names are applied.

> 
>>   static unsigned int gp_events_size;
>>   static unsigned int nr_gp_counters;
>>   
>> @@ -150,8 +153,7 @@ static void global_enable(pmu_counter_t *cnt)
>>   		return;
>>   
>>   	cnt->idx = event_to_global_idx(cnt);
>> -	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
>> -			(1ull << cnt->idx));
>> +	wrmsr(global_ctl_msr, rdmsr(global_ctl_msr) | (1ull << cnt->idx));
> 
> Opportunistically use BIT_ULL().
> 
>>   }
>>   
>>   static void global_disable(pmu_counter_t *cnt)
>> @@ -159,8 +161,7 @@ static void global_disable(pmu_counter_t *cnt)
>>   	if (pmu_version() < 2)
>>   		return;
>>   
>> -	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
>> -			~(1ull << cnt->idx));
>> +	wrmsr(global_ctl_msr, rdmsr(global_ctl_msr) & ~(1ull << cnt->idx));
> 
> BIT_ULL()
> 
>>   }
>>   
>>   static inline uint32_t get_gp_counter_msr(unsigned int i)
>> @@ -326,6 +327,23 @@ static void check_counters_many(void)
>>   	report(i == n, "all counters");
>>   }
>>   
>> +static bool is_the_count_reproducible(pmu_counter_t *cnt)
>> +{
>> +	unsigned int i;
>> +	uint64_t count;
>> +
>> +	__measure(cnt, 0);
>> +	count = cnt->count;
>> +
>> +	for (i = 0; i < 10; i++) {
>> +		__measure(cnt, 0);
>> +		if (count != cnt->count)
>> +			return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>   static void check_counter_overflow(void)
>>   {
>>   	uint64_t count;
>> @@ -334,13 +352,14 @@ static void check_counter_overflow(void)
>>   		.ctr = gp_counter_base,
>>   		.config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel /* instructions */,
>>   	};
>> +	bool precise_event = is_the_count_reproducible(&cnt);
>> +
>>   	__measure(&cnt, 0);
>>   	count = cnt.count;
>>   
>>   	/* clear status before test */
>>   	if (pmu_version() > 1) {
> 
> Please provide helper(s) to replace the myriad open coded "pmu_version() > ???"
> checks.  E.g. this one appears to be:
> 
> 	if (this_cpu_has_perf_global_status_clr())
> 
> I obviously don't care about the verbosity, it's that people like me might not
> know what the PMU version has to do with an MSR being accessible.
