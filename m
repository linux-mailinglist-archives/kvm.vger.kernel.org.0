Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168726894C7
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 11:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjBCKJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 05:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjBCKJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 05:09:06 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05372332E;
        Fri,  3 Feb 2023 02:09:05 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so4492295pjb.3;
        Fri, 03 Feb 2023 02:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q+HeQrnQROAeO+K+Pxvg+SD5/hgh32RR5KWwNQTEJ2w=;
        b=JhFj0QUrXvj4cKhjHnu5cQH2G1ngAqJsTr3jt/l0K7N23qy0Of6u4epeoS9NI4H+94
         LsPcuGORT7ReMOD38POrMPvJBw54sZd10mue0U2TtHV51ffVkZIqbPfNvlt+ZOT2nayy
         +lHemI87cPp+kW4fjt9ho22P/xqncQlqS9k4nLrhc7FQLO1hrMTpjbO9Vl+aEae2ie5a
         vfYwXXOFQhZULNa1Dh+jaz/hP6M2Y1/MTwOCX+/qvK4XWO4o0K6Rs6nrl5mI5hDCgyG5
         y3bZeGeG1EIr7kzghhQldj6oXZ/aaYzKa+Uq9841bp1jUltxK4WUkOL3oImoab0vYvor
         ewlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+HeQrnQROAeO+K+Pxvg+SD5/hgh32RR5KWwNQTEJ2w=;
        b=Y7zdUAYDKt0LoDJ6JPdGUWqHeQ0UBa1xRhO7iAjERn11wpDas4Zp/NtKA4fH4S22jp
         w9cZBWZGPSyh1RmTQBwgnnHyQtux10ugmyJb1gILGX15bEJIWBUTkkFP01pDDV77luaf
         XQxWwICE4Fx5fVXs8Dd2AxQ2lyGkC7jStSpQ4qF7g2t1rJEl9uEWuxZQN2VSOjGdoR6x
         ysq3a5Qn8UbOHjCekvqbC1jGFiD7iGhO3ZDnkoPlLMeUUCorb/LoGr+rEfa8BP75JpRs
         rwn5GcWHCGSEvaRasakHDRIqkbpt57vvtYOWYwe75FQvAiSl7JZ7y2dmTm8su3E2/WL+
         pu2w==
X-Gm-Message-State: AO0yUKX58Ay+4U3rT9KfJlO3eyUKVIjE3J2JPJe0+sjfWQ5VMlWAs/Ir
        YM9O5PIjRJPNVThhD2AEw5E=
X-Google-Smtp-Source: AK7set80XvT6Ggmwgt79Yo1ITKh0YCamcJGsauOH8aQAkHswhYTKKuXKaZIacqevA0+3C9nuf8nR6A==
X-Received: by 2002:a17:902:c948:b0:198:adc4:2286 with SMTP id i8-20020a170902c94800b00198adc42286mr5182510pla.1.1675418945234;
        Fri, 03 Feb 2023 02:09:05 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w11-20020a170902d70b00b00198be44edaesm1219839ply.88.2023.02.03.02.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:09:04 -0800 (PST)
Message-ID: <7dc66398-aa0c-991f-3fa9-43aac8c710fd@gmail.com>
Date:   Fri, 3 Feb 2023 18:08:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20230131085031.88939-1-likexu@tencent.com>
 <Y9k7eyfmXjqW9lYF@google.com>
 <afe1fdd8-9f3e-c988-cd38-476a6da26d46@gmail.com>
 <Y9v7tEXPlki7YOT4@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9v7tEXPlki7YOT4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/2023 2:06 am, Sean Christopherson wrote:
> On Thu, Feb 02, 2023, Like Xu wrote:
>> On 1/2/2023 12:02 am, Sean Christopherson wrote:
>>>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>>>> index 79988dafb15b..6a3995657e1e 100644
>>>> --- a/arch/x86/kvm/pmu.h
>>>> +++ b/arch/x86/kvm/pmu.h
>>>> @@ -166,9 +166,11 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>>>    	 /*
>>>>    	  * For Intel, only support guest architectural pmu
>>>> -	  * on a host with architectural pmu.
>>>> +	  * on a non-hybrid host with architectural pmu.
>>>>    	  */
>>>> -	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
>>>> +	if (!kvm_pmu_cap.num_counters_gp ||
>>>> +	    (is_intel && (!kvm_pmu_cap.version ||
>>>> +			  boot_cpu_has(X86_FEATURE_HYBRID_CPU))))
>>>
>>> Why do this here instead of in perf_get_x86_pmu_capability()[*]?  The issue isn't
>>> restricted to Intel CPUs, it just so happens that Intel is the only x86 vendor
>>> that has shipped hybrid CPUs/PMUs.  Similarly, it's entirely possible to create a
>>> hybrid CPU with a fully homogeneous PMU.  IMO KVM should rely on the PMU's is_hybrid()
>>> and not the generic X86_FEATURE_HYBRID_CPU flag.
>>>
>>> [*] https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com
>>
>> As of today, other x86 vendors do not have hybrid core products in their
>> road maps. Before implementing the virtual hybrid vCPU model, there is
>> no practical value in talking about homogeneous PMU on hybrid vCPU
>> at the present stage.
> 
> Why not?  I assume Intel put a fair bit of effort into ensuring feature parity
> between P and E cores.  Other than time, money, and effort, I don't see any
> reason why Intel can't do the same for the PMU.

I asked the same question when I was last accessed to hyprid core and
was told that it wouldn't happen on pmu capabilities since different pmu
events on different cpu type imply micro-architectural differences between
big and little cores,  and even the harmonization of event coding is difficult
to achieve in the short term.

> 
>> The perf interface only provides host PMU capabilities and the logic for
>> choosing to disable (or enable) vPMU based on perf input should be left
>> in the KVM part so that subsequent development work can add most code
>> to the just KVM, which is very helpful for downstream users to upgrade
>> loadable KVM module rather than the entire core kernel.
>>
>> My experience interacting with the perf subsystem has taught me that
>> perf change required from KVM should be made as small as possible.
> 
> I don't disagree, but I don't think that's relevant in this case.  Perf doesn't
> provide the necessary bits for KVM to virtualize a hybrid PMU, so unless KVM is
> somehow able to get away with enumerating a very stripped down vPMU, additional
> modifications to perf_get_x86_pmu_capability() will be required.
> 
> What I care more about though is this ugliness in perf_get_x86_pmu_capability():
> 
> 	/*
> 	 * KVM doesn't support the hybrid PMU yet.
> 	 * Return the common value in global x86_pmu,
> 	 * which available for all cores.

I would have expected w/ current code base, vpmu (excluding pebs and lbr, intel_pt)
to continue to work on any type of pCPU until you decide to disable them completely.

Moreover, the caller of perf_get_x86_pmu_capability() may be more than just KVM,
it may be technically ebpf helpers. The diff on comments from v1 can be applied to
this version (restrict KVM semantics), and it makes the status quo clearer to 
KVM users.

> 	 */
> 	cap->num_counters_gp	= x86_pmu.num_counters;
> 
> I really don't want to leave that comment lying around as it's flat out wrong in
> that it obviously doesn't address the other differences beyond the number of
> counters.  And since there are dependencies on perf, my preference is to disable
> PMU enumeration in perf specifically so that whoever takes on vPMU enabling is
> forced to consider the perf side of things, and get buy in from the perf folks.

The perf_get_x86_pmu_capability() obviously needs to be revamped,
but until real effective KVM enabling work arrives, any inconsequential intrusion
into perf/core code will only lead to trivial system maintenance.
