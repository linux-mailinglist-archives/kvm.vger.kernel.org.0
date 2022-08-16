Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883E9595B46
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 14:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiHPMIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 08:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiHPMHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 08:07:36 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1C827B;
        Tue, 16 Aug 2022 04:57:34 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 130so8881819pfy.6;
        Tue, 16 Aug 2022 04:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=WVBWgaTswemfzbw20qpPuEgDxV6dSmIqi1C1KwekqYY=;
        b=TxwJ0LMbqWQRSogwJI+4gfDuv4S06duLKu8XKvr/GrOF2/qRelZ8hQgOHT9sikfN/F
         W4BRoKzk8dfEIfyEjOkuh7k7IB9aZXV675vxRmp5IxpmfdkvJxU6mzuin6jb7bznrpVW
         FBzH1aVg/Wkwo/EuLxYO/vH6OwGC6/PC+9ZYxu9tJzYfDLNk/wQ/KP67+t5gEf3YgvGt
         phIO++y+yAX1WNBbXv2qvy53STlE5O/R/WlaDuemSirQXFAiIxyGqn/HCpyFBdq1Kl8H
         XcT1n1qE42BLJJ4gy+IpwTmuGFrc2v0i4zhEG3mY1+xKEFiw5WQyAEAZB/iHLVbl6cPu
         FnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=WVBWgaTswemfzbw20qpPuEgDxV6dSmIqi1C1KwekqYY=;
        b=3a172Drvy8nvWForQpSOCd9H8We83n6DCOtAXKM4ONlCF2Fbkzavbg7bOW1oI+YZAC
         fefsMFYCzFdH0rzxzrFNBPgCTmuskBKsp4xXVbH0ydXBVKoMPBVQK0u5CTAoBxvbkaEA
         LD8Jem21WMnA3zQQeK6CXRKKMgsUpFDCG11MxKX0vemQ1pgKPbkjRwC4FS7CdHcA9Ol1
         RmBSWktwmk97Wx0mQKRWQbFSDOKolLkOBw5ZNB43eeM20IZIZxAtrtHRFObi1MQWoIKn
         BdHGwrxil7LY6pVhDNYMqsmbL8LLR3OLxu8lFR6jwmbMHGzkPkdsTTuSbplbiJGXyh50
         TDbQ==
X-Gm-Message-State: ACgBeo2CZ2huyp7fHTkjjp70KuJ14jNetfJ0+R6d0uD+I7BmZ385a5oa
        /GxvIFr78ygseP12tjnJ9s0r2iCf3uJ4LQ==
X-Google-Smtp-Source: AA6agR4z4zYLIyvxZTTp8NXJrObkJJB64Hh4H7vQ9DRGQgYq5NWs23DiD6omwQiH1WOBNrW50yfo+A==
X-Received: by 2002:a63:d94a:0:b0:412:6e04:dc26 with SMTP id e10-20020a63d94a000000b004126e04dc26mr17751528pgj.539.1660651054412;
        Tue, 16 Aug 2022 04:57:34 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s13-20020aa78bcd000000b0052cdb06c125sm8295548pfd.159.2022.08.16.04.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 04:57:34 -0700 (PDT)
Message-ID: <e16680b0-8fb9-8ebd-8a2f-fc6830e28745@gmail.com>
Date:   Tue, 16 Aug 2022 19:57:22 +0800
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
        "Liang, Kan" <kan.liang@linux.intel.com>
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
 <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
 <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
 <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
 <952632db-b090-ceb9-1467-a6b598ca2b02@linux.intel.com>
 <YvpYa+YagI/7x9MU@worktop.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <YvpYa+YagI/7x9MU@worktop.programming.kicks-ass.net>
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

On 15/8/2022 10:30 pm, Peter Zijlstra wrote:
> On Mon, Aug 15, 2022 at 09:06:01AM -0400, Liang, Kan wrote:
> 
>> Goldmont Plus should be the only platform which supports extended PEBS
>> but doesn't have Baseline.
> 
> Like so then...
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2db93498ff71..cb98a05ee743 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -6291,10 +6291,8 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.pebs_block = true;
> -		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
> -		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>   		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
>   		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
>   
> @@ -6337,10 +6335,8 @@ __init int intel_pmu_init(void)
>   		x86_pmu.pebs_aliases = NULL;
>   		x86_pmu.pebs_prec_dist = true;
>   		x86_pmu.pebs_block = true;
> -		x86_pmu.pebs_capable = ~0ULL;
>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
> -		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>   		x86_pmu.flags |= PMU_FL_INSTR_LATENCY;
>   		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
>   		x86_pmu.lbr_pt_coexist = true;
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index ba60427caa6d..ac6dd4c96dbc 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -2262,6 +2262,7 @@ void __init intel_ds_init(void)
>   					PERF_SAMPLE_BRANCH_STACK |
>   					PERF_SAMPLE_TIME;
>   				x86_pmu.flags |= PMU_FL_PEBS_ALL;
> +				x86_pmu.pebs_capable = ~0ULL;
>   				pebs_qual = "-baseline";
>   				x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_EXTENDED_REGS;
>   			} else {

Looks good to me.

This diff touches PMU_FL_PEBS_ALL, which is less needed for guest PEBS fixes.
It has be sent out separately to the linux-perf-users group for further review.
