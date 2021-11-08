Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D811447EB2
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238003AbhKHLTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237955AbhKHLT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:19:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35C6C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 03:16:45 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so2446675pja.1
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 03:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vwKn8A78nbxh1bT4nrrDsinal0xZprUrg1oMka+P7PM=;
        b=NtiPFd+5N8XEr1a/xdNsTVcfmD/2APTPDe1Wj+sYaKyn+Cyd2eek0LmuKVCVmmdk15
         /mDYBMPOBdDKjUPyok6e0ZI7SW6i5NKqBnctc0RtDFQmGZRyzTlBVZN3bTxC6xO36quR
         yj+IQfKFvRyxxKGN1YK96IHqXXMwJTM0vf/FP8BLn1gpT86MoxWxCBlOe/w92OaAd0Y2
         5+e0p7d8TLpqX+xdsmMx1o5yT5s0zna6oEvuRm2hpULRriS/mjE6EzqPmtpP0iZOCzT/
         eemKmVpRD0YOEHH4KSoJvg8RQCuUMPS2oAPH/v1WE5XMLZ+f3kQx9xHyq2PHtIZaAOUf
         NWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vwKn8A78nbxh1bT4nrrDsinal0xZprUrg1oMka+P7PM=;
        b=RM439UBeEsBs6B1Q5crDOycjhLnmqhdm2/kGVCV895yKBFpXgGemHtZZzv5vXjSyRm
         UbbpJKlqdiLzr1H0kWAJRxKHqaXnv2Goerxl46Irj9J8j9nd7WBKGp9SWYe5EtmiVDGf
         zVrOARL/m3dlpKJVHhaK8v+ZcqBnTQ+G3D+gHIlS0lOOWJe6jBuUy3VTo9SQxqtdZaZz
         ++qqOCLQ5UPjaqiCIbUsyLkgl48rkC47i3UPS41YncWKZgilbvE67mMr2/eX3tkuVk9T
         GDoniS+D5gJcUu8sR113GVGh6nG1x219lEQDfXTRyy8SwziDiPuoBsmgGa5qopsBjSsS
         N32w==
X-Gm-Message-State: AOAM530RtlRtuJ7C7lmCqEXT1Q8Ci4J+cgTAk8DB/EL33kaG2bUUQgZl
        6sKMsehk2q/vZJo6EWObczQXKA==
X-Google-Smtp-Source: ABdhPJwT9OALjA7XUOHAUqMWCDd7RxGUBBT74K9E+6FkOYMtJyjbAwop3cCVdj3F8B78r9nsEmkMvA==
X-Received: by 2002:a17:90b:4d86:: with SMTP id oj6mr49859606pjb.101.1636370205218;
        Mon, 08 Nov 2021 03:16:45 -0800 (PST)
Received: from [10.2.24.177] ([61.120.150.70])
        by smtp.gmail.com with ESMTPSA id b18sm13187422pjo.31.2021.11.08.03.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:16:44 -0800 (PST)
Subject: Re: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with
 AVIC
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kele Huang <huangkele@bytedance.com>
Cc:     chaiwen.cc@bytedance.com, xieyongji@bytedance.com,
        dengliang.1214@bytedance.com, wanpengli@tencent.com,
        seanjc@google.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211108095931.618865-1-huangkele@bytedance.com>
 <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com>
 <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
From:   zhenwei pi <pizhenwei@bytedance.com>
Message-ID: <ad6b3ef5-4928-681c-a0cf-5a1095654566@bytedance.com>
Date:   Mon, 8 Nov 2021 19:14:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/21 7:08 PM, Maxim Levitsky wrote:
> On Mon, 2021-11-08 at 11:30 +0100, Paolo Bonzini wrote:
>> On 11/8/21 10:59, Kele Huang wrote:
>>> Currently, AVIC is disabled if x2apic feature is exposed to guest
>>> or in-kernel PIT is in re-injection mode.
>>>
>>> We can enable AVIC with options:
>>>
>>>     Kmod args:
>>>     modprobe kvm_amd avic=1 nested=0 npt=1
>>>     QEMU args:
>>>     ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
>>>
>>> When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
>>> can accelerate IPI operations for guest. However, the relationship
>>> between AVIC and PV_SEND_IPI feature is not sorted out.
>>>
>>> In logical, AVIC accelerates most of frequently IPI operations
>>> without VMM intervention, while the re-hooking of apic->send_IPI_xxx
>>> from PV_SEND_IPI feature masks out it. People can get confused
>>> if AVIC is enabled while getting lots of hypercall kvm_exits
>>> from IPI.
>>>
>>> In performance, benchmark tool
>>> https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
>>> shows below results:
>>>
>>>     Test env:
>>>     CPU: AMD EPYC 7742 64-Core Processor
>>>     2 vCPUs pinned 1:1
>>>     idle=poll
>>>
>>>     Test result (average ns per IPI of lots of running):
>>>     PV_SEND_IPI 	: 1860
>>>     AVIC 		: 1390
>>>
>>> Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
>>> do have some solid performance test results to this.
>>>
>>> This patch fixes this by masking out PV_SEND_IPI feature when
>>> AVIC is enabled in setting up of guest vCPUs' CPUID.
>>>
>>> Signed-off-by: Kele Huang <huangkele@bytedance.com>
>>
>> AVIC can change across migration.  I think we should instead use a new
>> KVM_HINTS_* bit (KVM_HINTS_ACCELERATED_LAPIC or something like that).
>> The KVM_HINTS_* bits are intended to be changeable across migration,
>> even though we don't have for now anything equivalent to the Hyper-V
>> reenlightenment interrupt.
> 
> Note that the same issue exists with HyperV. It also has PV APIC,
> which is harmful when AVIC is enabled (that is guest uses it instead
> of using AVIC, negating AVIC benefits).
> 
> Also note that Intel recently posted IPI virtualizaion, which
> will make this issue relevant to APICv too soon.
> 
> I don't yet know if there is a solution to this which doesn't
> involve some management software decision (e.g libvirt or higher).
> 
> Best regards,
> 	Maxim Levitsky
> 

For QEMU, "-cpu host,kvm-pv-ipi=off" can disable kvm-pv-ipi.
And for libvirt, I posted a patch to disable kvm-pv-ipi by libvirt xml, 
link:
https://github.com/libvirt/libvirt/commit/b2757b697e29fa86972a4638a5879dccc8add2ad

>>
>> Paolo
>>
>>> ---
>>>    arch/x86/kvm/cpuid.c   |  4 ++--
>>>    arch/x86/kvm/svm/svm.c | 13 +++++++++++++
>>>    2 files changed, 15 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 2d70edb0f323..cc22975e2ac5 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -194,8 +194,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>    		best->ecx |= XFEATURE_MASK_FPSSE;
>>>    	}
>>>    
>>> -	kvm_update_pv_runtime(vcpu);
>>> -
>>>    	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>>>    	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>>>    
>>> @@ -208,6 +206,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>    	/* Invoke the vendor callback only after the above state is updated. */
>>>    	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
>>>    
>>> +	kvm_update_pv_runtime(vcpu);
>>> +
>>>    	/*
>>>    	 * Except for the MMU, which needs to do its thing any vendor specific
>>>    	 * adjustments to the reserved GPA bits.
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index b36ca4e476c2..b13bcfb2617c 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -4114,6 +4114,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>>    		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
>>>    			kvm_request_apicv_update(vcpu->kvm, false,
>>>    						 APICV_INHIBIT_REASON_NESTED);
>>> +
>>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) &&
>>> +				!(nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))) {
>>> +			/*
>>> +			 * PV_SEND_IPI feature masks out AVIC acceleration to IPI.
>>> +			 * So, we do not expose PV_SEND_IPI feature to guest when
>>> +			 * AVIC is enabled.
>>> +			 */
>>> +			best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
>>> +			if (best && enable_apicv &&
>>> +					(best->eax & (1 << KVM_FEATURE_PV_SEND_IPI)))
>>> +				best->eax &= ~(1 << KVM_FEATURE_PV_SEND_IPI);
>>> +		}
>>>    	}
>>>    	init_vmcb_after_set_cpuid(vcpu);
>>>    }
>>>
> 
> 

-- 
zhenwei pi
