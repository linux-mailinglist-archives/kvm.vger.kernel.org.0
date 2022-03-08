Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A354D16C1
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 12:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346577AbiCHMAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 07:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiCHMAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 07:00:48 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C43289B6;
        Tue,  8 Mar 2022 03:59:52 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso2059299pjb.0;
        Tue, 08 Mar 2022 03:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=wHCHcNv35jsq9uJZNtNUOMWI8ofZ17Ys+sOz/RMBH2Y=;
        b=fTSu255snnLS1boMzSwSXCtpILYhn+fxqGJRzzIQnOWPzwmidDgpWj1EZ/nWrooPUN
         m13gywxcmYTKSpWE1e1F6Rw1DipevK83Hxf6qqdC9Ie1911j3Wl5pW1X5gZ2Ln+96jzo
         JnqXi9Kf+LNfSJ2Y/3XV2xU+LA3avuZ3CZDbMeFXl7+tpwSp0eJOWu5V4UyljVvKkOKI
         peWTHRRDYunnqaJfPckjNa9ppHRUSUKH/sGf0bJpxGzAsJlUQNXxgWUDC6wx2kieFKFp
         K7Hg42WPcTa2gbSjKC8VXJKGiU7Je+9m/OKJSqtEYFOA6Z6Jxk/V2UoC0EuryrgY2EHd
         to4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=wHCHcNv35jsq9uJZNtNUOMWI8ofZ17Ys+sOz/RMBH2Y=;
        b=uZynL9CPSWyLjqjKep2G0706w6HC2E2my47fd4Gr+3oeY8WDKdMdrZILql39Synu4n
         d5OyOK8izoCToi59fe6fXZYomz7q5UGfEOu6OgLPfaruoPLk6puGbdEid/t0Uf8snYBA
         sQFGuavPmiMdHQ/Tf/bln+Sny/Ckpn9Rm6HtPAGOpJZyMejxdlo8OX6TVgR9MwAmn2Op
         X0mju5d5CfG3CrzpLh2q6N0l5hVGuUNRl6oEjkw/yE0aQq5x5ZgPBAI3FbFEmCVnd63U
         8W7zEXnLloEhNjyepbEsuA0UVclHSs6uvbh2z27v7WkqH6faMmt7PxTqnn1kFj/d5vc+
         olEA==
X-Gm-Message-State: AOAM530/TTfZuUykSnIHWbg2YgYmMxob4txfqjjIiaqFNcwcxrD9jjs6
        xJ46p43AU0M7U7G2wOSJ2jA=
X-Google-Smtp-Source: ABdhPJyXsq3i+35vKFEFyBvbGkmze5hQ2fkRfm7MLFRJfgDr4mENQ/dUF95fvfqJBLBgVyQHQyNiQQ==
X-Received: by 2002:a17:90b:38ce:b0:1bf:a34:5bad with SMTP id nn14-20020a17090b38ce00b001bf0a345badmr4315295pjb.129.1646740791559;
        Tue, 08 Mar 2022 03:59:51 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l20-20020a056a00141400b004f65cedfb09sm19707996pfu.48.2022.03.08.03.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 03:59:51 -0800 (PST)
Message-ID: <f1f846f6-a544-d38c-beef-611bf70c4fcc@gmail.com>
Date:   Tue, 8 Mar 2022 19:59:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] KVM: x86/pmu: Isolate TSX specific perf_event_attr.attr
 logic for AMD
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Andi Kleen <ak@linux.intel.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>
References: <20220307063805.65030-1-likexu@tencent.com>
 <CALMp9eSCWxM5-_-S6SK_0o-aTCWGzyut-L2qsqnaeR_dJc6n3g@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eSCWxM5-_-S6SK_0o-aTCWGzyut-L2qsqnaeR_dJc6n3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2022 5:39 am, Jim Mattson wrote:
> On Sun, Mar 6, 2022 at 10:38 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> HSW_IN_TX* bits are used in generic code which are not supported on
>> AMD. Worse, these bits overlap with AMD EventSelect[11:8] and hence
>> using HSW_IN_TX* bits unconditionally in generic code is resulting in
>> unintentional pmu behavior on AMD. For example, if EventSelect[11:8]
>> is 0x2, pmc_reprogram_counter() wrongly assumes that
>> HSW_IN_TX_CHECKPOINTED is set and thus forces sampling period to be 0.
>>
>> Opportunistically remove two TSX specific incoming parameters for
>> the generic interface reprogram_counter().
>>
>> Fixes: 103af0a98788 ("perf, kvm: Support the in_tx/in_tx_cp modifiers in KVM arch perfmon emulation v5")
>> Co-developed-by: Ravi Bangoria <ravi.bangoria@amd.com>
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>> Note: this patch is based on [1] which is considered to be a necessary cornerstone.
>> [1] https://lore.kernel.org/kvm/20220302111334.12689-1-likexu@tencent.com/
>>
>>   arch/x86/kvm/pmu.c | 29 ++++++++++++++---------------
>>   1 file changed, 14 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 17c61c990282..d0f9515c37dd 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -99,8 +99,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
>>
>>   static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>                                    u64 config, bool exclude_user,
>> -                                 bool exclude_kernel, bool intr,
>> -                                 bool in_tx, bool in_tx_cp)
>> +                                 bool exclude_kernel, bool intr)
>>   {
>>          struct perf_event *event;
>>          struct perf_event_attr attr = {
>> @@ -116,16 +115,18 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>>
>>          attr.sample_period = get_sample_period(pmc, pmc->counter);
>>
>> -       if (in_tx)
>> -               attr.config |= HSW_IN_TX;
>> -       if (in_tx_cp) {
>> -               /*
>> -                * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
>> -                * period. Just clear the sample period so at least
>> -                * allocating the counter doesn't fail.
>> -                */
>> -               attr.sample_period = 0;
>> -               attr.config |= HSW_IN_TX_CHECKPOINTED;
>> +       if (guest_cpuid_is_intel(pmc->vcpu)) {
> 
> This is not the right condition to check. Per the SDM, both bits 32
> and 33 "may only be set if the processor supports HLE or RTM." On
> other Intel processors, this bit is reserved and any attempts to set
> them result in a #GP.

We already have this part of the code:

	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
	if (entry &&
	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;

> 
>> +               if (pmc->eventsel & HSW_IN_TX)
>> +                       attr.config |= HSW_IN_TX;
> 
> This statement does nothing. If HSW_IN_TX is set in pmc->eventsel, it
> is set in attr.config already.

Agree for the redundancy, since attr.config is "(eventsel & AMD64_RAW_EVENT_MASK)".

> 
>> +               if (pmc->eventsel & HSW_IN_TX_CHECKPOINTED) {
>> +                       /*
>> +                        * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
>> +                        * period. Just clear the sample period so at least
>> +                        * allocating the counter doesn't fail.
>> +                        */
>> +                       attr.sample_period = 0;
>> +                       attr.config |= HSW_IN_TX_CHECKPOINTED;
> 
> As above, this statement does nothing. We should just set
> attr.sample_period to 0. Note, however, that the SDM documents an

Thanks and applied.

> additional constraint which is ignored here: "This bit may only be set
> for IA32_PERFEVTSEL2." I have confirmed that a #GP is raised for an
> attempt to set bit 33 in any PerfEvtSeln other than PerfEvtSel2 on a
> Broadwell Xeon E5.

Yes, "19.3.6.5 Performance Monitoring and Intel® TSX".

I'm not sure if the host perf scheduler indicate this restriction.

cc Kan.

> 
>> +               }
>>          }
>>
>>          event = perf_event_create_kernel_counter(&attr, -1, current,
>> @@ -268,9 +269,7 @@ void reprogram_counter(struct kvm_pmc *pmc)
>>                          (eventsel & AMD64_RAW_EVENT_MASK),
>>                          !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
>>                          !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
>> -                       eventsel & ARCH_PERFMON_EVENTSEL_INT,
>> -                       (eventsel & HSW_IN_TX),
>> -                       (eventsel & HSW_IN_TX_CHECKPOINTED));
>> +                       eventsel & ARCH_PERFMON_EVENTSEL_INT);
>>   }
>>   EXPORT_SYMBOL_GPL(reprogram_counter);
>>
>> --
>> 2.35.1
>>
