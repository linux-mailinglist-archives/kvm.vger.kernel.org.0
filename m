Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367653E5598
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhHJIhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhHJIhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:37:38 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EB5C061798;
        Tue, 10 Aug 2021 01:37:16 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso3297395pjb.2;
        Tue, 10 Aug 2021 01:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FXspbIoQyJRsyjWs8Jej6neYLGbnTXtR1OFOqJbyzHc=;
        b=RhKuaaI//VH/hQUv6HMSjFuD5PkUSJ6uxkqacUjOJBcu/GPGckMx9in8HsQjC1j/AU
         5+T+xZNuN3rRXbxmHX6GMYZVLMIkhqqalmlsgGeYbVxHfBIAxDSb5bjVFPlmQGJZcl/v
         gQ8Xr4XyzeMKXc2PogUfCu4sRf+03Ioxd54X8WB9sHzHFncfy/nHLoVUVXlKwUh850Dz
         qGKzh1YADluwvE60ymDLFiPr06Zt0fCnaM0NWX1rFX1aaVKnT9kB0zPxCIAVqOKA6lDE
         ghPI1t3Ue+UAiS9zA7DraEegUuaeOrMq17XZi7rOKvzkxvMCiXvwdXLBMRFtBPxSuRuh
         HQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FXspbIoQyJRsyjWs8Jej6neYLGbnTXtR1OFOqJbyzHc=;
        b=kohGe4G6FQGA51KZNlr0bjQFcIGWGxkbkrTRLvpnT2vB5NAJxaLH3p8ffrJsh8Mld7
         iGTwwOJS7dRMS77AF//3TOON/8X3UDBwYKvbbMnQyAXKMw7IeQc6CcOOdhA4GRNNlsg7
         HzvUjsAqS7h4xIr9y+lmwLhlzpAhB3f8ltXxGOmpCsy95KFQvqkVmCna9rSBI7BnF1LI
         b6tZRwwk+Dog7i4+E6ynwQSchIKt+woOHPaS0H4NJu5V2a2mKRgWYtC+0Wf9pPyEn19D
         o5NNUOfB5xJe3OGAQTVtjFnua2lw864NcrjZt6PJ21pbU1G8WNLWJW/ZR+nFmHW8PlLz
         szdw==
X-Gm-Message-State: AOAM5309GYFke6atKoRD2bDf5utFy8x4xXhluZb7npMHvY6deKAvFuDt
        62l9zGhf3oRzgH6kcqF07glWfT/QjQDvtvILky4=
X-Google-Smtp-Source: ABdhPJxO4R7Cjz/PlKeF0hb20D3YAGLbe0Gh+hGszCTGcj4D/Y4AaHuOwmkhU5rNLSglvTsKQR3LJA==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr3869936pjq.88.1628584636090;
        Tue, 10 Aug 2021 01:37:16 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z13sm2036287pjd.44.2021.08.10.01.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 01:37:15 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-6-git-send-email-weijiang.yang@intel.com>
 <59ef2c3c-0997-d6a5-0d4a-4e777206a665@gmail.com>
 <20210810083040.GB2970@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v7 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
Message-ID: <e3439027-097e-6af6-46e0-ce223b6b6ec4@gmail.com>
Date:   Tue, 10 Aug 2021 16:37:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810083040.GB2970@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2021 4:30 pm, Yang Weijiang wrote:
> On Mon, Aug 09, 2021 at 09:36:49PM +0800, Like Xu wrote:
>> On 6/8/2021 3:42 pm, Yang Weijiang wrote:
>>> From: Like Xu <like.xu@linux.intel.com>
>>>
>>> Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
>>> state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
>>> When guest Arch LBR is enabled, a guest LBR event will be created like the
>>> model-specific LBR does. Clear guest LBR enable bit on host PMI handling so
>>> guest can see expected config.
>>>
>>> On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
>>> meaning. It can be written to 0 or 1, but reads will always return 0.
>>> Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also preserved on INIT.
>>>
>>> Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of the
>>> corresponding control MSR is set to 1, LBR recording will be enabled.
>>>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>>   arch/x86/events/intel/lbr.c      |  2 --
>>>   arch/x86/include/asm/msr-index.h |  1 +
>>>   arch/x86/include/asm/vmx.h       |  2 ++
>>>   arch/x86/kvm/vmx/pmu_intel.c     | 48 ++++++++++++++++++++++++++++----
>>>   arch/x86/kvm/vmx/vmx.c           |  9 ++++++
>>>   5 files changed, 55 insertions(+), 7 deletions(-)
>>>
> 
> [...]
> 
>>> +static bool arch_lbr_ctl_is_valid(struct kvm_vcpu *vcpu, u64 ctl)
>>> +{
>>> +	unsigned int eax, ebx, ecx, edx;
>>> +
>>> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>>> +		return false;
>>> +
>>> +	cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
>>> +	if (!(ebx & BIT(0)) && (ctl & ARCH_LBR_CTL_CPL))
>>> +		return false;
>>> +	if (!(ebx & BIT(2)) && (ctl & ARCH_LBR_CTL_STACK))
>>> +		return false;
>>> +	if (!(ebx & BIT(1)) && (ctl & ARCH_LBR_CTL_BRN_MASK))
>>> +		return false;
>>> +
>>> +	return !(ctl & ~KVM_ARCH_LBR_CTL_MASK);
>>> +}
>>
>> Please check it with the *guest* cpuid entry.
> If KVM "trusts" user-space, then check with guest cpuid is OK.
> But if user-space enable excessive controls, then check against guest
> cpuid could make things mess.

The user space should be aware of its own risk
if it sets the cpuid that exceeds the host's capabilities.

> 
>>
>> And it should remove the bits that are not supported by x86_pmu.lbr_ctl_mask before
>> vmcs_write64(...) if the guest value is a superset of the host value with
>> warning message.
> Then I think it makes more sense to check against x86_pmu.lbr_xxx masks in above function
> for compatibility. What do you think of it?

The host driver hard-codes x86_pmu.lbr_ctl_mask to ARCH_LBR_CTL_MASK
but the user space can mask out some of the capability based on its cpuid selection.
In that case, we need to check it with the guest cpuid entry.

If user space exceeds the KVM supported capabilities,
KVM could leave a warning before the vm-entry fails.

>>
>>> +
>>>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   {
>>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>> @@ -392,6 +414,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   	case MSR_ARCH_LBR_DEPTH:
>>>   		msr_info->data = lbr_desc->records.nr;
>>>   		return 0;
>>> +	case MSR_ARCH_LBR_CTL:
>>> +		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>>> +		return 0;
>>>   	default:
>>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>>>   		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> 
> [...]
> 
>>>   		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
>>>   		    (data & DEBUGCTLMSR_LBR))
>>> @@ -4441,6 +4448,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>>   		vmcs_writel(GUEST_SYSENTER_ESP, 0);
>>>   		vmcs_writel(GUEST_SYSENTER_EIP, 0);
>>>   		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
>>> +		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
>>> +			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
>>
>> Please update dump_vmcs() to dump GUEST_IA32_LBR_CTL as well.
> OK, will add it.
>>
>> How about update the load_vmcs12_host_state() for GUEST_IA32_LBR_CTL
>> since you enabled the nested case in this patch set ?
> No, I didn't enable nested Arch LBR but unblocked some issues for nested case.

Would you like to explain more about the unblocked issue ?

>>
>>>   	}
>>>   	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>>>
