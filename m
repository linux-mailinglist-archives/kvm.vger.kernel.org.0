Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8E5AE890
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiIFMje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 08:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239985AbiIFMie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 08:38:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14C428721;
        Tue,  6 Sep 2022 05:38:29 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o4so11106778pjp.4;
        Tue, 06 Sep 2022 05:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=NBEKziai8tD7EfeGEWY04U+cM25v0Gl7ZFe6/+WXtdQ=;
        b=PkSO3MhDpWTCIIKdUZQB61aijuiZz13aguTJg6oljfZYOkuefg/Z7dOGtm4h8QOTZj
         Rwx36xpAkHevjj8xGXI0L9axwDmsn9idfHuVoShmU2zYkonVd6WKLDhPTQbKdwUVsL4W
         vl0wO6SGgdUCHLN0Df3cU2Pm/L0tjlVEgXDhslO+lGh/5Q+JWit0Iergj03vmdNfMw8a
         bESnAi0VcQDI0Crzv0Jeslk5YqFLawEUssWedVM12aOGTAbFMbbSBTDP3Ezx1RbaYmUN
         lIz4Xs5wFXLH+fC2QB6CnNMEnGvIhUZxl0hcmKEwzeY+68MN1qyXc8r3YLo7hiVO6ugU
         GeqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NBEKziai8tD7EfeGEWY04U+cM25v0Gl7ZFe6/+WXtdQ=;
        b=a1TKQVyzDHyemhiMZYKj2mRTjubqRDIP6OeuZNVU2IRTQ14LtFRmj+59UX1zIT1MZw
         2xT/IlPP3DZ7JG0PhZVBVn+lQAaAH255Y5KQfSj3rutUJelfa66HBRsIpa80tJby9x4U
         kb+YAP85N49mwQrWvsJOABEynm0nth3PGs2xOaXAAZvu0bc7JU0wajtQQjgAWrGfEuKc
         rYMQBp7ZgexKF6q98B1mkhuxKcUxCe5nV5XW+Yt00aEZWXichaD51+ogT1AR2iclf5kL
         MkqLyAI6MxDyqJR0bxnKwpkR2ejdIUnQuyEikVE9acs1d98zRCBjZaZtHHLNAFuQtmQY
         LSNg==
X-Gm-Message-State: ACgBeo3K7oFE58fIeKxHTEuLITdi5I9uuvenJDKDipRxqZE5qkwcwu5r
        zvYt2UfyNVvSIHVh0S9MLic=
X-Google-Smtp-Source: AA6agR5lbyVYod0F4EBgwjq0toAN0+4JDV/+6Uh9yjjGMGoPmmaD5I4YOKZerATUwhPgZtnz0JuGeg==
X-Received: by 2002:a17:90b:230f:b0:200:a5f3:d60b with SMTP id mt15-20020a17090b230f00b00200a5f3d60bmr2223352pjb.215.1662467909057;
        Tue, 06 Sep 2022 05:38:29 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y187-20020a6264c4000000b0053db6f7d2f1sm4833395pfb.181.2022.09.06.05.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 05:38:28 -0700 (PDT)
Message-ID: <309cbd6b-4d50-7a11-f7c1-0859b0f812d1@gmail.com>
Date:   Tue, 6 Sep 2022 20:38:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 1/4] KVM: x86/svm/pmu: Limit the maximum number of
 supported GP counters
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220905123946.95223-1-likexu@tencent.com>
 <20220905123946.95223-2-likexu@tencent.com>
 <CALMp9eR3qSVvVgCVq9qsZkFOxa1mHWaAhZimOd14j30_3fXsZg@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eR3qSVvVgCVq9qsZkFOxa1mHWaAhZimOd14j30_3fXsZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/2022 1:26 am, Jim Mattson wrote:
> On Mon, Sep 5, 2022 at 5:45 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The AMD PerfMonV2 specification allows for a maximum of 16 GP counters,
>> which is clearly not supported with zero code effort in the current KVM.
>>
>> A local macro (named like INTEL_PMC_MAX_GENERIC) is introduced to
>> take back control of this virt capability, which also makes it easier to
>> statically partition all available counters between hosts and guests.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.h     | 2 ++
>>   arch/x86/kvm/svm/pmu.c | 7 ++++---
>>   arch/x86/kvm/x86.c     | 2 ++
>>   3 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 847e7112a5d3..e3a3813b6a38 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -18,6 +18,8 @@
>>   #define VMWARE_BACKDOOR_PMC_REAL_TIME          0x10001
>>   #define VMWARE_BACKDOOR_PMC_APPARENT_TIME      0x10002
>>
>> +#define KVM_AMD_PMC_MAX_GENERIC        AMD64_NUM_COUNTERS_CORE
>> +
>>   struct kvm_event_hw_type_mapping {
>>          u8 eventsel;
>>          u8 unit_mask;
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index 2ec420b85d6a..f99f2c869664 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -192,9 +192,10 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
>>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>          int i;
>>
>> -       BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > INTEL_PMC_MAX_GENERIC);
>> +       BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > KVM_AMD_PMC_MAX_GENERIC);
>> +       BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
>>
>> -       for (i = 0; i < AMD64_NUM_COUNTERS_CORE ; i++) {
>> +       for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
>>                  pmu->gp_counters[i].type = KVM_PMC_GP;
>>                  pmu->gp_counters[i].vcpu = vcpu;
>>                  pmu->gp_counters[i].idx = i;
>> @@ -207,7 +208,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
>>          struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>          int i;
>>
>> -       for (i = 0; i < AMD64_NUM_COUNTERS_CORE; i++) {
>> +       for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
>>                  struct kvm_pmc *pmc = &pmu->gp_counters[i];
>>
>>                  pmc_stop_counter(pmc);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 43a6a7efc6ec..b9738efd8425 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1444,12 +1444,14 @@ static const u32 msrs_to_save_all[] = {
>>          MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> 
> IIRC, the effective maximum on the Intel side is 18, despite what
> INTEL_PMC_MAX_GENERIC says, due to collisions with other existing MSR

Emm, check https://lore.kernel.org/kvm/20220906081604.24035-1-likexu@tencent.com/

> indices. That's why the Intel list stops here. Should we introduce a
> KVM_INTEL_PMC_MAX_GENERIC as well?

Yes, this suggestion will be applied in the next version.

> 
>>          MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
>>
>> +       /* This part of MSRs should match KVM_AMD_PMC_MAX_GENERIC. */
> 
> Perhaps the comment above should be moved down two lines, since the
> next two lines deal with the legacy counters.

Applied, thanks.

> 
>>          MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
>>          MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
>>          MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
>>          MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
>>          MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
>>          MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
> 
> At some point, we may want to consider populating the PMU MSR list
> dynamically, rather than statically enumerating all of them (for both
> AMD and Intel).

The uncertainty of msrs_to_save_all[] may cause troubles for legacy user spaces.
I had draft patches to rewrite pmu msr accesses for host-initiated as first move.

> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
