Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5443F6F28
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 08:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhHYGJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 02:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbhHYGJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 02:09:10 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC84C061757;
        Tue, 24 Aug 2021 23:08:24 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e7so22034571pgk.2;
        Tue, 24 Aug 2021 23:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wIZlsjM71KEU8VEYx3CYCCiwZOwOrPf1v6bA8/dbf1M=;
        b=poIPxVJMp1vIk+6ctNkoP6Yf4Z/gg8JU/Ef81md8mUQMac8TNjT6k5wGcXgLp9vxsn
         700A7wKIpHG0LrL5H0+f/ZTG6QYyOPJRbj/Pd2uc5D6L/vkf5Ow/7vReZB7GBrv1T8BI
         0u908fKeOEI0gqx3ecC/XtxoDDn3OCYcyKhX+biYEgFYKCu48TkwtkrL49+SrgbpmryS
         SkjxPS2CkSqPRW06zqtLede1qq6PgjdEfcR5fUe33/ojSCW4vEjqXrVbptQyDer3gVWE
         xHnEkMh8NXbHKxQEgJmaiqeSEEccEx1UG3hw09WMgT4d0xJM7D7vMVJz5xyIoEcMvdXH
         3KXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wIZlsjM71KEU8VEYx3CYCCiwZOwOrPf1v6bA8/dbf1M=;
        b=R5TqJwxbXaRA0GOo3/JvXrH9hIr7WhK+bNvxlR/5Rge3qQFoLvEhP05J66eBgWH6Be
         4pEEOnBRoDia+hddnMOGLih0xy69roLWKG/GArk88eMzHy0EOAy13rdlUY/dvCYQLBnB
         viGb/yuiJcQCq83AdzLf0QabGgQQ/ZseoL1Yx5gPe4ZUN++e8hBVq4FjnqQhKtbrRKzT
         gLS0ednFxFLdT5imofgHsFz1Ccxqnggn0r5kgDTAfpg817YxLUv7i5ZQ9q7lkJ36JOqy
         YuSyERbzYyMfFwdKZouQHFPBJFO+Sq92cZrvq/nLBr0Z4i4IY7w8/bRGdFKiOtHObZ7P
         oA+g==
X-Gm-Message-State: AOAM5328FXC2Rj8h6HO9r1MfLaR+CaORwtNfw2YlAp/GNg4UzdlQ4R9W
        rkf5/Ss/NppRlLj4GaXXeXw=
X-Google-Smtp-Source: ABdhPJzd9YoztbUBqgaGrFSlp1hqXpvsm5D/4Z3VRoDCdRxO6wM6ON41FlmkMEvWBZe3mItrmU/Png==
X-Received: by 2002:a05:6a00:1989:b0:3e2:a387:e1d9 with SMTP id d9-20020a056a00198900b003e2a387e1d9mr40845804pfl.64.1629871703520;
        Tue, 24 Aug 2021 23:08:23 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u24sm22298098pfm.81.2021.08.24.23.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 23:08:23 -0700 (PDT)
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
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 3/5] KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on
 other CPUID bit
Message-ID: <6dddf3c0-fa8f-f70c-bd5d-b43c7140ed9a@gmail.com>
Date:   Wed, 25 Aug 2021 14:08:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b80a91db-cb35-ba6d-ab36-a0fa1ca051e7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/8/2021 12:19 pm, Xiaoyao Li wrote:
> On 8/25/2021 11:30 AM, Like Xu wrote:
>> +Alexander
>>
>> On 24/8/2021 7:07 pm, Xiaoyao Li wrote:
>>> Per Intel SDM, RTIT_CTL_BRANCH_EN bit has no dependency on any CPUID
>>> leaf 0x14.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>>   arch/x86/kvm/vmx/vmx.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index 7ed96c460661..4a70a6d2f442 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -7116,7 +7116,8 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>>       /* Initialize and clear the no dependency bits */
>>>       vmx->pt_desc.ctl_bitmask = ~(RTIT_CTL_TRACEEN | RTIT_CTL_OS |
>>> -            RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC);
>>> +            RTIT_CTL_USR | RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC |
>>> +            RTIT_CTL_BRANCH_EN);
>>>       /*
>>>        * If CPUID.(EAX=14H,ECX=0):EBX[0]=1 CR3Filter can be set otherwise
>>> @@ -7134,12 +7135,11 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>>                   RTIT_CTL_CYC_THRESH | RTIT_CTL_PSB_FREQ);
>>>       /*
>>> -     * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn BranchEn and
>>> -     * MTCFreq can be set
>>> +     * If CPUID.(EAX=14H,ECX=0):EBX[3]=1 MTCEn and MTCFreq can be set
>>
>> If CPUID.(EAX=14H,ECX=0):EBX[3]=1,
>>
>>      "indicates support of MTC timing packet and suppression of COFI-based 
>> packets."
> 
> I think it's a mistake of SDM in CPUID instruction.
> 
> If you read 31.3.1, table 31-11 of SDM 325462-075US,
> 
> It just says CPUID(0x14, 0):EBX[3]: MTC supprted.
> It doesn't talk anything about COFI packets suppression.
> 
> Further as below.
> 
>> Per 31.2.5.4 Branch Enable (BranchEn),
>>
>>      "If BranchEn is not set, then relevant COFI packets (TNT, TIP*, FUP, 
>> MODE.*) are suppressed."
>>
>> I think if the COFI capability is suppressed, the software can't set the 
>> BranchEn bit, right ?
> 
> Based on your understanding, isn't it that
> 
> 1. if CPUID.(EAX=14H,ECX=0):EBX[3]=0, it doesn't support "suppression of 
> COFI-based packets".
> 2. if it doesn't support "suppression of COFI-based packets", then it doens't 
> support "If BranchEn is not set, then relevant COFI packets (TNT, TIP*, FUP, 
> MODE.*) are suppressed", i.e. BranchEn must be 1.

That's it.

> 
> Anyway, I think it's just a mistake on CPUID instruction document of SDM.

Is this an ambiguity rather than a mistake ?

> 
> CPUD.(EAX=14H,ECX=0):EBX[3] should only indicates the MTC support.

Please do not make assertions that you do not confirm with hw.

> 
> BranchEn should be always supported if PT is available. Per "31.2.7.2 

Check d35869ba348d3f1ff3e6d8214fe0f674bb0e404e.

> IA32_RTIT_CTL MSR" on SDM:
> When BranchEn is 1, it enables COFI-based packets.
> When BranchEn is 0, it disables COFI-based packtes. i.e., COFI packets are 
> suppressed.
> 
>>>        */
>>>       if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_mtc))
>>>           vmx->pt_desc.ctl_bitmask &= ~(RTIT_CTL_MTC_EN |
>>> -                RTIT_CTL_BRANCH_EN | RTIT_CTL_MTC_RANGE);
>>> +                          RTIT_CTL_MTC_RANGE);
>>>       /* If CPUID.(EAX=14H,ECX=0):EBX[4]=1 FUPonPTW and PTWEn can be set */
>>>       if (intel_pt_validate_cap(vmx->pt_desc.caps, PT_CAP_ptwrite))
>>>
> 
