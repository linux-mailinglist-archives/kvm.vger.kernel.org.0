Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0639E603D39
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 11:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJSJAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 05:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiJSI7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 04:59:24 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7490C1EEE3;
        Wed, 19 Oct 2022 01:54:44 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bh13so15655721pgb.4;
        Wed, 19 Oct 2022 01:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A9I2hdsafS0GLgFrUl5npQLZoG5UYLa7iPh5261ayqo=;
        b=ND2gNkFGJK/iFxe1u4L1Z4VR6R0+/irm1SWn/+mVJZ8kRiC4sqLxORRE3Bnzb3IAm/
         PpsdWaARYEUywuq4KsAobLlpVmEo5ztkYnFTx3/y0dia2U/Pz/tiXLOwZDEXqhIE4UYN
         fZxCb3tmjy9J92XOVGnNlsgT0KfHvuv8ZAvaer/D0bvdtoiQJBl7h9bOqFapKnkGhJKV
         kaiQk9vEA/QI5Gv8F5CJmTzwNcADZ939bhd1j/lQtqE7/i30WMXekTVkzpKu0G7FWGW2
         9Tl2xTQAx1zUi5XmGL37kAJFV7HLzrIiQpXTy8xLfCetzCweyxf4oW9nm9BNwH0zjbEq
         ZUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A9I2hdsafS0GLgFrUl5npQLZoG5UYLa7iPh5261ayqo=;
        b=IC8uI7asMXSWE4xZv91Z1NIFBaB/49shOhUMB0PbmeRgmwTiPjLGGJ+SXzNoc+1US3
         w0oeqv5jplOFofYVDWs5uClJXpcHPnJOFKldVTX8yfwcyCHauuVq+X8XFK/w0y0k8fRi
         VhyyY6f/lm2uaQDM0PBWjoE06OVMoOE/mGu0rEen3RiMi7fTigV7L039zTdweFqRzSK9
         VBb0ooYfYnxC69TNPIq+hm3CzCB5p2eyRPO/eBfXAowEZpALicrDhQGJ68IIuV/vz80i
         UiBED8YoA32AbrfwJlqX6Q7xk1mnKtp6sRAf1JctOfZRBnQuQwFfMt8Wq1p9lNBpDkq6
         lMqA==
X-Gm-Message-State: ACrzQf3rZ7aewbuluSjr8CXnuKGXwOjBYMxeGSalhHe7gksFolAquKO3
        JxHSVgpQ4XD1w00tc3oMVdQphXOAKUdf6XBt
X-Google-Smtp-Source: AMsMyM40w6UMkYswxtch5o/A/PXXkcHSQKHravoRfkRZr1dMkwH8z470vBIsGgTeshYz3je9LHISdA==
X-Received: by 2002:a05:6a00:f03:b0:563:210a:5ffb with SMTP id cr3-20020a056a000f0300b00563210a5ffbmr7565582pfb.70.1666169468546;
        Wed, 19 Oct 2022 01:51:08 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id pf15-20020a17090b1d8f00b00200a85fa777sm12978904pjb.1.2022.10.19.01.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 01:51:07 -0700 (PDT)
Message-ID: <c4e78b67-bfcb-3671-3de9-252b97062c27@gmail.com>
Date:   Wed, 19 Oct 2022 16:50:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [kvm-unit-tests PATCH 1/2] x86/pmu: Update rdpmc testcase to
 cover #GP and emulation path
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-6-likexu@tencent.com> <Yz347iKzq7cbjMdw@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yz347iKzq7cbjMdw@google.com>
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

On 6/10/2022 5:36 am, Sean Christopherson wrote:
> On Mon, Sep 05, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Specifying an unsupported PMC encoding will cause a #GP(0).
>> All testcases should be passed when the KVM_FEP prefix is added.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   lib/x86/processor.h |  5 ++++-
>>   x86/pmu.c           | 13 +++++++++++++
>>   2 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
>> index 10bca27..9c490d9 100644
>> --- a/lib/x86/processor.h
>> +++ b/lib/x86/processor.h
>> @@ -441,7 +441,10 @@ static inline int wrmsr_safe(u32 index, u64 val)
>>   static inline uint64_t rdpmc(uint32_t index)
>>   {
>>   	uint32_t a, d;
>> -	asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
>> +	if (is_fep_available())
>> +		asm volatile (KVM_FEP "rdpmc" : "=a"(a), "=d"(d) : "c"(index));
>> +	else
>> +		asm volatile ("rdpmc" : "=a"(a), "=d"(d) : "c"(index));
> 
> Hmm, not sure how I feel about the idea of always use FEP in a common helper when
> it's available.  Part of me likes the idea, but part of me is worried that it
> will cause confusion due to not being explicit.
> 
> Unless there's a pressing need to force emulation, let's punt the FEP stuff for
> now.  More below.

Some security researchers are very interested in these corners.

To my limited testing, most KVM emulation code (at least arch/x86/kvm/emulate.c) 
are not
adequately covered by test cases, and perhaps some will move them to the user space.

> 
>>   	return a | ((uint64_t)d << 32);
>>   }
>>   
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 203a9d4..11607c0 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -758,12 +758,25 @@ static bool pmu_is_detected(void)
>>   	return detect_intel_pmu();
>>   }
>>   
>> +static void rdpmc_unsupported_counter(void *data)
>> +{
>> +	rdpmc(64);
>> +}
>> +
>> +static void check_rdpmc_cause_gp(void)
> 
> Maybe check_invalid_rdpmc_gp()?  There are multiple reasons RDPMC can #GP, the
> one that is being relied on to guarantee #GP is specifically that the PMC is
> invalid.

Applied.

> dd

p, :D

> 
>> +{
>> +	report(test_for_exception(GP_VECTOR, rdpmc_unsupported_counter, NULL),
> 
> I'd really like to move away from test_for_exception() and use ASM_TRY().  Ignoring
> FEP for the moment, the most extensible solution is to provide a safe variant:
> 
> static inline int rdpmc_safe(u32 index, uint64_t *val)
> {
> 	uint32_t a, d;
> 
> 	asm volatile (ASM_TRY("1f")
> 		      "rdpmc"
> 		      : "=a"(a), "=d"(d) : "c"(index));

	asm volatile (ASM_TRY("1f")
		      "rdpmc\n\t"
		      "1:"
		      : "=a"(a), "=d"(d) : "c"(index) : "memory");

, otherwise the compiler will complain.

> 	*val = (uint64_t)a | ((uint64_t)d << 32);
> 	return exception_vector();
> }
> 
> static inline uint64_t rdpmc(uint32_t index)
> {
> 	uint64_t val;
> 	int vector = rdpmc_safe(index, &val);
> 
> 	assert_msg(!vector, "Unexpected %s on RDPMC(%d)",
> 		   exception_mnemonic(vector), index);
> 	return val;
> }

Applied.

> 
> 
> For long-term emulation validation, the best idea I have at this point is to do
> add a config knob to opt-in to using FEP in _all_ common helpers (where "all"
> means everything KVM actually emulates).  It'd take some macro magic, but it'd
> be easier to maintain (no need to have two paths in every helper) and would be
> controllable.

With both hands up in favour. Leave it to you, as this involves a wider change.

> 
>> +		"rdpmc with invalid PMC index raises #GP");
>> +}
>> +
>>   int main(int ac, char **av)
>>   {
>>   	setup_vm();
>>   	handle_irq(PC_VECTOR, cnt_overflow);
>>   	buf = malloc(N*64);
>>   
>> +	check_rdpmc_cause_gp();
>> +
>>   	if (!pmu_is_detected())
>>   		return report_summary();
>>   
>> -- 
>> 2.37.3
>>
