Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F43592F33
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 14:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242466AbiHOMsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 08:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiHOMsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 08:48:46 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD9D12D30;
        Mon, 15 Aug 2022 05:48:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p125so6547868pfp.2;
        Mon, 15 Aug 2022 05:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=+FbqTDcg3XPgwdCiCE9cC/6t6E7fkuXS28x1IFx7TVI=;
        b=LhSbAeJZLj2yt/H8QqsvhgepH0M0nopEDmhFCN3OQjCBjp0vH2dhdMdKy/iScrPIP9
         n5ZW2gqScrWoA9jNRYB/sU2N+wQblgzzuDGpsIb5cx7sXTs01ZPjbsQKC+y+SfEPagUO
         CSYEIEbKsi5onOyv2KL31e6sm7R/K26RWEhryqHyRIWoJ1FM0O13nxecudXRrxS40dcb
         PjOU6ClcrFeCTUiLzxk0KxgMpYpQNjG5fYUXrq7GtuPgpYZrH1bD2BygNDYpdC2KFL7R
         /t3c84I71VmJCI30IF4CsoWTBfVtPNiq12fUOi89ZWDPZXvVms17w/2xRNx7jkY4Z/6J
         zQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+FbqTDcg3XPgwdCiCE9cC/6t6E7fkuXS28x1IFx7TVI=;
        b=FGwSreIjub0lBlB+CKFMeg8UBSZ/ScpepUns/1eudCGP8ymrtcTS6LxGVmy27xXdnW
         I+teF1rFpNzCLAIG9UL9+/xFL48ecPbJsRCysPC+mDFo1xSGMOseDUq3GOAuFITwEoTq
         A51XXPFRPPa2TtuLBjPT/3D/2ykVhYX0aPDWHPvlusP0oc0h6jWEXNM/GJUHprJagDDI
         4p85BeNz69co7TyG/7jUOLlx7gsSDwCPIfsZIhq1D8rdtWVcGeRuPqKgSmTafrLs0km7
         UFYfrDmU8LRfLAg2XYupDoyOFbyR8P3gECexMfO/yrT84DNMowP16JLkbqZulyXgX9G8
         fp7g==
X-Gm-Message-State: ACgBeo0zBdIAISpt0rvWFDYC4BwbXL9MoyNph8nIzrYfOTDHYaZ68grV
        9ZqoTmTAu9IBmq5Yikovki1MErpWcqs=
X-Google-Smtp-Source: AA6agR7shFLmM+dYCF/Z/kgFutJR4niQwIXNlupJOrzDN/Qmr5WS/DpJ73o8SLjUjyalCOgHFIk/Ng==
X-Received: by 2002:a63:8bc3:0:b0:41d:4b74:b975 with SMTP id j186-20020a638bc3000000b0041d4b74b975mr13590409pge.309.1660567724959;
        Mon, 15 Aug 2022 05:48:44 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s19-20020a170903201300b001712e1ea269sm6913800pla.3.2022.08.15.05.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 05:48:44 -0700 (PDT)
Message-ID: <a592d15d-7c29-d18e-809d-b32bf3dee276@gmail.com>
Date:   Mon, 15 Aug 2022 20:48:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
 <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
 <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
 <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
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

On 15/8/2022 7:51 pm, Peter Zijlstra wrote:
> On Mon, Aug 15, 2022 at 05:43:34PM +0800, Like Xu wrote:
> 
>>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>>> index 2db93498ff71..b42c1beb9924 100644
>>> --- a/arch/x86/events/intel/core.c
>>> +++ b/arch/x86/events/intel/core.c
>>> @@ -5933,7 +5933,6 @@ __init int intel_pmu_init(void)
>>>    		x86_pmu.pebs_aliases = NULL;
>>>    		x86_pmu.pebs_prec_dist = true;
>>>    		x86_pmu.lbr_pt_coexist = true;
>>> -		x86_pmu.pebs_capable = ~0ULL;
>>>    		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>>>    		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>>>    		x86_pmu.get_event_constraints = glp_get_event_constraints;
>>> @@ -6291,7 +6290,6 @@ __init int intel_pmu_init(void)
>>>    		x86_pmu.pebs_aliases = NULL;
>>>    		x86_pmu.pebs_prec_dist = true;
>>>    		x86_pmu.pebs_block = true;
>>> -		x86_pmu.pebs_capable = ~0ULL;
>>>    		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>>>    		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>>>    		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>>> @@ -6337,7 +6335,6 @@ __init int intel_pmu_init(void)
>>>    		x86_pmu.pebs_aliases = NULL;
>>>    		x86_pmu.pebs_prec_dist = true;
>>>    		x86_pmu.pebs_block = true;
>>> -		x86_pmu.pebs_capable = ~0ULL;
>>>    		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>>>    		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>>>    		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>>> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
>>> index ba60427caa6d..e2da643632b9 100644
>>> --- a/arch/x86/events/intel/ds.c
>>> +++ b/arch/x86/events/intel/ds.c
>>> @@ -2258,6 +2258,7 @@ void __init intel_ds_init(void)
>>>    			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
>>>    			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
>>>    			if (x86_pmu.intel_cap.pebs_baseline) {
>>> +				x86_pmu.pebs_capable = ~0ULL;
>>
>> The two features of "Extended PEBS (about pebs_capable)" and "Adaptive PEBS
>> (about pebs_baseline)"
>> are orthogonal, although the two are often supported together.
> 
> The SDM explicitly states that PEBS Baseline implies Extended PEBS. See
> 3-19.8 (April 22 edition).

Indeed, "IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14]: If set, the following is 
true
- Extended PEBS is supported;
- Adaptive PEBS is supported;"

> 
> The question is if there is hardware that has Extended PEBS but doesn't
> have Baseline; and I simply don't know and was hoping Kan could find
> out.

In the SDM world, we actually have three PEBS sub-features:

[July 2017] 18.5.4.1 Extended PEBS (first on Goldmont Plus)
[January 2019] 18.9.2 Adaptive PEBS (first on Tremont)
[April 2021] IA32_PERF_CAPABILITIES.PEBS_BASELINE in the Table 2-2. IA-32 
Architectural MSRs

Waiting Kan to confirm the real world.

> 
> That said; the above patch can be further improved by also removing the
> PMU_FL_PEBS_ALL lines, which is already set by intel_ds_init().
> 
> In general though; the point is, we shouldn't be doing the FMS table
> thing for discoverable features. Having pebs_capable = ~0 and
> PMU_FL_PEBS_ALL on something with BASELINE set is just wrong.
