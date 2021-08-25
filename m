Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2071C3F70F0
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 10:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbhHYIO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 04:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhHYIO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 04:14:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6AAC061757;
        Wed, 25 Aug 2021 01:14:11 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so4192445pjt.0;
        Wed, 25 Aug 2021 01:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+EBNmwz3B1OcseYo+ko82tHs9cVVYc8STzsxk/yeCuM=;
        b=ksRkoxNVHyatv1yfIozmlKddwqOMa57C6hE8uPO1mRfbqcSPxuw1tINZRERxUX7ho9
         hp2jzqkYPn5M17jDSZVEC//BKky4wWD/M9X238Ix/QN3cWCodF+t3cMvOTa3WbRKSfrL
         vvKyux1kbYgb6D9a9Jx3SkDZoN1mZxd32szLjNDs5OArIOLIL8lx11R9tjptAGnI/vU7
         aKlBrlCJtfs8471ZH33wGIUDWkB2Ucic3gT4nIHsQVtmgxyPEMc8q/krIbKUzsw0FIvC
         OzOT3Luu8VX/7BWSe56XdgwSKoqB8FncyJyB1nxwvH5zjMFADbWHIC3NGPXjJXZmBud5
         4L0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+EBNmwz3B1OcseYo+ko82tHs9cVVYc8STzsxk/yeCuM=;
        b=a11YAS9iK2FBmMee688Lmta+P05Sxf3z8k9t8Yua7RD0Pxz+1e4xastZ4GrXu9PO7R
         lT3LNMQXErzIk/+RqZgwMo9bzYJ0RtDwyyhlhnYpSKbijLaUBCWwnNQ06w5AFyfgfXmA
         yUpeukHxnFRT4jcA3BNb2bBEmOiHSyR53WeS0QI9jqWibOOYL+Fko1LW02e3RcCND8fJ
         ZEsf2Rybbztf8b8Gv2qsC4oXmcg3baz6scuSX3jJNdhTV8enkyrxQfUmcNW0FINes1vb
         0gKjXKX1k9i7Wl+VSgCYDvUhEg7VKgBQKvW300cSHPPBZR6hGYSDUjE08efJLJMh/UTP
         jQUQ==
X-Gm-Message-State: AOAM532/K/ML4xxG0W4BbhmV/edMkDYJO3bVLOSJHB/Vw4l+iS6X8tp4
        abgXWiPcgM5tf2phOeqw/Kk=
X-Google-Smtp-Source: ABdhPJzVMOumgAcZ9MNU86j21uehpj3wC2snO1KQvlwlyYqDsTIe98WZ9RQYVyxFXusDjkLDStDnHQ==
X-Received: by 2002:a17:90a:af8f:: with SMTP id w15mr9063699pjq.90.1629879251200;
        Wed, 25 Aug 2021 01:14:11 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y64sm24740637pgy.32.2021.08.25.01.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 01:14:10 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on
 other CPUID bit
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Alexander Shishkin (hwtracing + intel_th + stm + R:perf)" 
        <alexander.shishkin@linux.intel.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-4-xiaoyao.li@intel.com>
 <711265db-f634-36ac-40d2-c09cea825df6@gmail.com>
 <b80a91db-cb35-ba6d-ab36-a0fa1ca051e7@intel.com>
 <6dddf3c0-fa8f-f70c-bd5d-b43c7140ed9a@gmail.com>
 <ed18e08f-1ea6-4ffa-91a7-9d8706a1b781@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <26103eda-806a-516d-096f-c9e85552286a@gmail.com>
Date:   Wed, 25 Aug 2021 16:14:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ed18e08f-1ea6-4ffa-91a7-9d8706a1b781@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/8/2021 2:33 pm, Xiaoyao Li wrote:
> On 8/25/2021 2:08 PM, Like Xu wrote:
>> On 25/8/2021 12:19 pm, Xiaoyao Li wrote:
>>> On 8/25/2021 11:30 AM, Like Xu wrote:
>>>> +Alexander
>>>>
>>>> On 24/8/2021 7:07 pm, Xiaoyao Li wrote:
>>>>> Per Intel SDM, RTIT_CTL_BRANCH_EN bit has no dependency on any CPUID
>>>>> leaf 0x14.
>>>>>
>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>> ---
>>>>>   arch/x86/kvm/vmx/vmx.c | 8 ++++----
>>>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>>> index 7ed96c460661..4a70a6d2f442 100644
>>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>>> @@ -7116,7 +7116,8 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>>>>       /* Initialize and clear the no dependency bits */
>>>>>       vmx->pt_desc.ctl_bitmask = ~(RTIT_CTL_TRACEEN | RTIT_CTL_OS |
>>>>> -            RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC);
>>>>> +            RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC |
>>>>> +            RTIT_CTL_BRANCH_EN);
>>>>>       /*
>>>>>        * If CPUID.(EAX=14H,ECX=0):EBX[0]=1 CR3Filter can be set otherwise
>>>>> @@ -7134,12 +7135,11 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>>>>                   RTIT_CTL_CYC_THRESH | RTIT_CTL_PSB_FREQ);
>>>>>       /*
>>>>> -     * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn BranchEn and
>>>>> -     * MTCFreq can be set
>>>>> +     * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn and MTCFreq can be set
>>>>
>>>> If CPUID.(EAX=14H,ECX=0):EBX[3]=1,
>>>>
>>>>      "indicates support of MTC timing packet and suppression of COFI-based 
>>>> packets."
>>>
>>> I think it's a mistake of SDM in CPUID instruction.
>>>
>>> If you read 31.3.1, table 31-11 of SDM 325462-075US,
>>>
>>> It just says CPUID(0x14, 0):EBX[3]: MTC supprted.
>>> It doesn't talk anything about COFI packets suppression.
>>>
>>> Further as below.
>>>
>>>> Per 31.2.5.4 Branch Enable (BranchEn),
>>>>
>>>>      "If BranchEn is not set, then relevant COFI packets (TNT, TIP*, FUP, 
>>>> MODE.*) are suppressed."
>>>>
>>>> I think if the COFI capability is suppressed, the software can't set the 
>>>> BranchEn bit, right ?
>>>
>>> Based on your understanding, isn't it that
>>>
>>> 1. if CPUID.(EAX=14H,ECX=0):EBX[3]=0, it doesn't support "suppression of 
>>> COFI-based packets".
>>> 2. if it doesn't support "suppression of COFI-based packets", then it doens't 
>>> support "If BranchEn is not set, then relevant COFI packets (TNT, TIP*, FUP, 
>>> MODE.*) are suppressed", i.e. BranchEn must be 1.
>>
>> That's it.
>>
>>>
>>> Anyway, I think it's just a mistake on CPUID instruction document of SDM.
>>
>> Is this an ambiguity rather than a mistake ?
>>
>>>
>>> CPUD.(EAX=14H,ECX=0):EBX[3] should only indicates the MTC support.
>>
>> Please do not make assertions that you do not confirm with hw.
>>
>>>
>>> BranchEn should be always supported if PT is available. Per "31.2.7.2 
>>
>> Check d35869ba348d3f1ff3e6d8214fe0f674bb0e404e.
> 
> This commit shows BranchEn is supported on BDW, and must be enabled on BDW. This 
> doesn't conflict the description above that BranchEn should be always supported.

Per Vol. 4 Table 2-34. Additional MSRs Common to Processors Based the
Broadwell Microarchitectures, the BranchEn bit 13 is:

	"Reserved; writing 0 will #GP if also setting TraceEn"

on the Intel® Core™ M Processors.

My point is that we, especially software developers from hardware vendors,
should really focus on real hardware and fix real problems.

<EOM>

> 
>>> IA32_RTIT_CTL MSR" on SDM:
>>> When BranchEn is 1, it enables COFI-based packets.
>>> When BranchEn is 0, it disables COFI-based packtes. i.e., COFI packets are 
>>> suppressed.
>>>
>>>>>        */
>>>>>       if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc))
>>>>>           vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_MTC_EN |
>>>>> -                RTIT_CTL_BRANCH_EN | RTIT_CTL_MTC_RANGE);
>>>>> +                          RTIT_CTL_MTC_RANGE);
>>>>>       /* If CPUID.(EAX=14H,ECX=0):EBX[4]=1 FUPonPTW and PTWEn can be set */
>>>>>       if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_ptwrite))
>>>>>
>>>
> 
