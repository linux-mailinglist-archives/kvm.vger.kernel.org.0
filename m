Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20981592C3C
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242116AbiHOJnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 05:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242098AbiHOJnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 05:43:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD081EC7B;
        Mon, 15 Aug 2022 02:43:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id 17so5958034pli.0;
        Mon, 15 Aug 2022 02:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=VGpb9yI++t5guVH3M2YI/eDKS/dhqvfqUzMOcfAxFYM=;
        b=gpB9oB+d+adC3A2ILZHzdUTWDfix4r5IqThT5UGjkMW6MFsSFd+4Le1XvWyHHUYxNp
         6EI715Xp4ESBJNNfwyZ0a3QvoR7P4Bv7bnV/QhFvCPS0OxUSAiPpGg2jiF2lU2no3QoO
         hKhy4eikoePjMuvzpxyaL5hJdXPeIgVT88cYCGFCmxUR44NNLqw9WIuXldhVz60LoRgw
         u8DhjdMPOEBx7qfIyiYqAMtVh9eCrl9FVEqbdDDmq2bwUBxhI3pfcfMvO9UhwTbZNsmW
         mV+/IO7uA5LRJP9iSYRD3GknT0Pp4f2IClojrIT8lWM1/reOr415b4yd8v37qOjZryMH
         sFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VGpb9yI++t5guVH3M2YI/eDKS/dhqvfqUzMOcfAxFYM=;
        b=2Fdjco9dAAQmgiHvJLW9W7wDXMkppGw8HLUNud0MtOcbcSAhpTMeyeVSCBa9xu/njh
         zFoAm0hjwJKSDcLLxOIyRSbGSEnnGVHZhpSQjyxUxA8GuMxyRvt7UOAGM64i2Rqn5KeX
         +DUdMHwIIlVvtq9duSuUZ4jShJqr0oLDF6QfQ4IePBG9g3JpvP5+KRYJPFegbgapB5nP
         Jty/1CtrsM1Ca34xq9WaXUUUXYNUvCoP2dSkauYouBq7n3FQQan5gKhnUR9f3PPuatfO
         ovuvBE6m3wSIn+yIpg4GFj8bOaJ5x+8BRjS9RtzCM1cy+mh7a2pu2Bs8a7BunY/e5oU2
         sLJA==
X-Gm-Message-State: ACgBeo0Qibtcl5ZgKixZ6nfSpJKKNx8gR6hVucc6tpzHwADTRhg7DPPT
        osboyBIEuc3XDIor41DyXl4=
X-Google-Smtp-Source: AA6agR7ju0iT+Ai73DrRPx/j6EPOe56/R2gA20CwOKA5toF2Ke90gkNy/DgQ4JvhgLE7M8wGDPlUPQ==
X-Received: by 2002:a17:90b:4a0a:b0:1f4:e4fc:91d3 with SMTP id kk10-20020a17090b4a0a00b001f4e4fc91d3mr26878322pjb.67.1660556621938;
        Mon, 15 Aug 2022 02:43:41 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z6-20020a170903018600b0016ccbc9db0fsm6740246plg.5.2022.08.15.02.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 02:43:41 -0700 (PDT)
Message-ID: <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
Date:   Mon, 15 Aug 2022 17:43:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
 <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/8/2022 5:31 pm, Peter Zijlstra wrote:
> On Fri, Aug 12, 2022 at 09:52:13AM +0200, Paolo Bonzini wrote:
>> On 7/21/22 12:35, Like Xu wrote:
>>> From: Like Xu <likexu@tencent.com>
>>>
>>> Ice Lake microarchitecture with EPT-Friendly PEBS capability also support
>>> the Extended feature, which means that all counters (both fixed function
>>> and general purpose counters) can be used for PEBS events.
>>>
>>> Update x86_pmu.pebs_capable like SPR to apply PEBS_ALL semantics.
>>>
>>> Cc: Kan Liang <kan.liang@linux.intel.com>
>>> Fixes: fb358e0b811e ("perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server")
>>> Signed-off-by: Like Xu <likexu@tencent.com>
>>> ---
>>>    arch/x86/events/intel/core.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>>> index 4e9b7af9cc45..e46fd496187b 100644
>>> --- a/arch/x86/events/intel/core.c
>>> +++ b/arch/x86/events/intel/core.c
>>> @@ -6239,6 +6239,7 @@ __init int intel_pmu_init(void)
>>>    	case INTEL_FAM6_ICELAKE_X:
>>>    	case INTEL_FAM6_ICELAKE_D:
>>>    		x86_pmu.pebs_ept = 1;
>>> +		x86_pmu.pebs_capable = ~0ULL;
>>>    		pmem = true;
>>>    		fallthrough;
>>>    	case INTEL_FAM6_ICELAKE_L:
>>
>> Peter, can you please ack this (you were not CCed on this KVM series but
>> this patch is really perf core)?
> 
> I would much rather see something like this; except I don't know if it
> is fully correct. I can never find what models support what... Kan do
> you know?

For guest PEBS, it's a minor optimization from 0d23dc34a7ce to reduce branch 
instructions:
https://lore.kernel.org/kvm/YKIqbph62oclxjnt@hirez.programming.kicks-ass.net/

> 
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2db93498ff71..b42c1beb9924 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -5933,7 +5933,6 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.lbr_pt_coexist = true;
> -		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>   		x86_pmu.get_event_constraints = glp_get_event_constraints;
> @@ -6291,7 +6290,6 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.pebs_block = true;
> -		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
> @@ -6337,7 +6335,6 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.pebs_block = true;
> -		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index ba60427caa6d..e2da643632b9 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -2258,6 +2258,7 @@ void __init intel_ds_init(void)
>   			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
>   			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
>   			if (x86_pmu.intel_cap.pebs_baseline) {
> +				x86_pmu.pebs_capable = ~0ULL;

The two features of "Extended PEBS (about pebs_capable)" and "Adaptive PEBS 
(about pebs_baseline)"
are orthogonal, although the two are often supported together.

>   				x86_pmu.large_pebs_flags |=
>   					PERF_SAMPLE_BRANCH_STACK |
>   					PERF_SAMPLE_TIME;
