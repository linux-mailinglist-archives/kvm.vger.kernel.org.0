Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CB46DA951
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 09:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbjDGHUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 03:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjDGHUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 03:20:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0533F86B9;
        Fri,  7 Apr 2023 00:20:03 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id kq3so39374333plb.13;
        Fri, 07 Apr 2023 00:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680852002; x=1683444002;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZQCxXkjhqcsEriZgDn924CV/TbxySojYMlEtAcBKotM=;
        b=U5IQDL32H9aWjn2GvTKfEkl95f8E/YOKbD9JEtXvZ0KQOtZhLpNyIC37wt0X7S8Tex
         ioEMH1kXtXqn1k6DNnGEZqryn50gQIGm/omxfH/7XUqNt48m2ya8slTbtCQj0f8lq4X+
         ex6RypUZntIg7HcpIcnDNK0JDnHn9YSR/Oo7NnjZDKlK6Le4UrKo3vOv4VorgBesicVP
         VRu1DXd4APhJP8AMZSn8XNIx/KNP6ORVzFYk53jYRYWa3gbI42iBFO5kIhmbxTLcMXg6
         Xcm5VS2iS5ng0U4yk/hQKjw0YWivfl32df03PPVgcVtrMokNLJKz3XLfpztWtUZwOYlG
         UYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680852002; x=1683444002;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQCxXkjhqcsEriZgDn924CV/TbxySojYMlEtAcBKotM=;
        b=D+EIVJvtagYHw8+CdYH5Ytnp1johTBjSIrNao8ykPhkGXsJx3tJJmEHW9Za4+MUOkd
         2GUTr9IhPYgX7oJnbEFmFmuxP750PJMcr3/uKQnLdRjAUnuVeg3fjBt/bGolL2P5as7Y
         Y41joK92ajmJ4hO+oBxjibaw65ebkMMKmajyg3Hz/2qhLcyR3tTjFcnDiX3LMWrk8ypU
         VSUcSE1zryyYIY0ntw+v5Mva61koS5Y0ksApaH8p7E+IdqJFZiZNn97sLfXIqQOSrPQ6
         SCL5llHRQ1XLqEANFE6BJUEr1PaQFQg+rTcwWxJ+yzK4x/P0K17VVZ7q1DQBBH43IjSI
         4afQ==
X-Gm-Message-State: AAQBX9eE0ZvdDBWhr7uk6Jn3ec24n2Y5wMtFbUicaN+EyOT0+SyOktaY
        DGfvNfhdu9Nc0nNNs9KGZ1w=
X-Google-Smtp-Source: AKy350ZSPDn0tC3XJHBhxHhTzMIX5h74FdJ0knLumNp6nvtcQiqcg7yLW6XSwJQ4O9KUnQOeF0q75g==
X-Received: by 2002:a17:903:1211:b0:1a2:9ce6:648b with SMTP id l17-20020a170903121100b001a29ce6648bmr2101728plh.12.1680852002346;
        Fri, 07 Apr 2023 00:20:02 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902a70c00b0019abb539cddsm2391817plq.10.2023.04.07.00.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 00:20:02 -0700 (PDT)
Message-ID: <23262f06-44d1-1b3d-6d2d-c0c418e564f6@gmail.com>
Date:   Fri, 7 Apr 2023 15:19:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v4 12/12] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg
 leaf 0x80000022
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
References: <20230214050757.9623-1-likexu@tencent.com>
 <20230214050757.9623-13-likexu@tencent.com> <ZC92/WkJf9/AnABP@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZC92/WkJf9/AnABP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/2023 9:50 am, Sean Christopherson wrote:
> On Tue, Feb 14, 2023, Like Xu wrote:
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index f4a4691b4f4e..2472fa8746c2 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4916,6 +4916,12 @@ static __init void svm_set_cpu_caps(void)
>>   		} else {
>>   			/* AMD PMU PERFCTR_CORE CPUID */
>>   			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
>> +			/*
>> +			 * KVM only supports AMD PerfMon V2, even if it supports V3+.
> 
> Ha!  A perfect example of why I strongly prefer that changelogs and comments avoid
> pronouns.  The above "it" reads as:
> 
> 			 * KVM only supports AMD PerfMon V2, even if KVM supports V3+.
> 
> which is clearly nonsensical.

I get your point. Thanks.

> 
> 
>> +			 * For PerfMon V3+, it's unsafe to expect V2 bit is set or cleared.
> 
> If it's unsafe to assume anything v3+ implying v2 support, then it's definitely
> not safe to assume that KVM can blindly set v2 without future changes.  I don't
> see any reason not to do
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index bd324962bb7e..1192f605ad47 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -756,6 +756,10 @@ void kvm_set_cpu_caps(void)
>                  F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
>          );
>   
> +       kvm_cpu_cap_mask(CPUID_8000_0022_EAX,
> +               F(PERFMON_V2)
> +       );
> +
>          /*
>           * Synthesize "LFENCE is serializing" into the AMD-defined entry in
>           * KVM's supported CPUID if the feature is reported as supported by the
> 
> 
> and then this code can be:
> 
> 			if (kvm_pmu_cap.version != 2)
> 				kvm_cpu_cap_clear(X86_FEATURE_PERFMON_V2);
> 
> Ah, but presumably the
> 
> 		if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE)
> 
> path also needs to clear PERFMON_V2.  I think I'd still vote to grab host CPUID
> and clear here (instead of setting).

Looks good to me.

> 
> What is the relationship between PERFCTR_CORE and PERFMON_V2?  E.g. if v2 depends
> on having PERFCTR_CORE, then we can do:

Yes, the PERFCTR_CORE bit will always be set if the v2 bit is set.

> 
> 	if (enable_pmu) {
> 		if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE)
> 			kvm_pmu_cap.num_counters_gp = AMD64_NUM_COUNTERS;
> 		else
> 			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
> 
> 		if (kvm_pmu_cap.version != 2 ||
> 		    !kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
> 			kvm_cpu_cap_clear(X86_FEATURE_PERFMON_V2);
