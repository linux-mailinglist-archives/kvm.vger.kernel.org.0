Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6853E54A3
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 09:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbhHJHym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 03:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbhHJHyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 03:54:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D317C0613D3;
        Tue, 10 Aug 2021 00:54:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j1so31907078pjv.3;
        Tue, 10 Aug 2021 00:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1pWCy1aPX1NRIPpBRen/YfBM8c2q/vJjDSPgmfFU8Wc=;
        b=tQw/h7MWIewVqSkCVqfocpZd1Xpq6M1RQ3OpvGNuHKjUFa8WBlAdS/rJLDJeWrLePO
         gqnYFfNTIjSGguPire/+upR6nRqogFz8Z7UMHZN3wrP6jCi9BP77S9dPo9PLbk9KPd25
         h4hD/bWjW3LUtNQ9nUNmQsScK/f8XegD3IclZ0lbDnKMSqZMI2+Y58IwCjkL4j/os9ZO
         5fek1pkwHD+DXlRDCH3k8O0FE360zDZWGFjobnR5UGdB5oKE61nR3czitLtrFJdyNint
         N6UCml8M7deOWGeSl5DTJ4TCEoOQ87LO14nd7Zf7rgzQ4Cft06IvJbmCGX/2+utG4UKN
         dufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1pWCy1aPX1NRIPpBRen/YfBM8c2q/vJjDSPgmfFU8Wc=;
        b=Jn2OyJar/YfcSEGfRoTt50m23Qoh99A24kVgDBsUVg7yL99u8hPfgyDIIT3JECNgsZ
         +26X/3frABnMiIh0Ok3aL+TQRgw7cAViQqLkfpEubIEmRq4dRxy+Msr1nZ/V8/wPs7Ob
         eM6vyYd5OI6aideQWZe1jqG7ss8WeLLdT4RqTQH673uqp7qkCkhQEBmBiuwQZ3vPZN+a
         IuhqLd072zjx5Kf1kb/WVs8iBqpteAkLkx1VmUs8jvoXLgei81x6906W5fGoAqeF9t5Z
         4tqzwHbR6dRi2HNl6RKnZS38kjxJA3vByIUG779YtwRJH/hT+/ZS5rglnM9wQ395/GjL
         LVWA==
X-Gm-Message-State: AOAM531MtOEZGRDVB6mMfV073eFLboSlfvEuK1CypSUenaHmaNJ2NMzl
        26ccL/B/a+n9z7qlIyKb8Uy1PodZzKuilVOnLGM=
X-Google-Smtp-Source: ABdhPJx22MzVwnCgcNNb+AGqI5zUaElT/AIm8aIzwQaTUemn/Ng/0j3LHfqumCpMNXm3aa1TotC6Hw==
X-Received: by 2002:a62:7bd4:0:b029:3b7:29bf:b0f with SMTP id w203-20020a627bd40000b02903b729bf0b0fmr28322319pfc.15.1628582059664;
        Tue, 10 Aug 2021 00:54:19 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x189sm26024843pfx.99.2021.08.10.00.54.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 00:54:19 -0700 (PDT)
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-5-git-send-email-weijiang.yang@intel.com>
 <e739722a-b875-6e5b-3e77-38586d799485@gmail.com>
 <20210810073858.GA2970@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v7 04/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Message-ID: <0707a301-b6b5-0f54-810f-ef07e4148943@gmail.com>
Date:   Tue, 10 Aug 2021 15:54:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810073858.GA2970@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/2021 3:38 pm, Yang Weijiang wrote:
> On Mon, Aug 09, 2021 at 09:16:47PM +0800, Like Xu wrote:
>> On 6/8/2021 3:42 pm, Yang Weijiang wrote:
>>> From: Like Xu <like.xu@linux.intel.com>
>>
>> ...
>>
>>>
>>> The number of Arch LBR entries available is determined by the value
>>> in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
>>> enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
>>> in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
>>> supported.
>>>
>>> On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
>>> KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
>>> (this is safe because the two values will be the same) when the Arch LBR
>>> records MSRs are pass-through to the guest.
>>>
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>>> ---
>>>   arch/x86/kvm/vmx/pmu_intel.c | 35 ++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 34 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>>> index 9efc1a6b8693..a4ef5bbce186 100644
>>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>>> @@ -211,7 +211,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>>>   static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>>>   {
>>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>> -	int ret;
>>> +	int ret = 0;
>>>   	switch (msr) {
>>>   	case MSR_CORE_PERF_FIXED_CTR_CTRL:
>>> @@ -220,6 +220,10 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>>>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>>>   		ret = pmu->version > 1;
>>>   		break;
>>> +	case MSR_ARCH_LBR_DEPTH:
>>> +		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>>> +			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>>> +		break;
>>>   	default:
>>>   		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
>>>   			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
>>> @@ -348,10 +352,28 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>>>   	return true;
>>>   }
>>> +/*
>>> + * Check if the requested depth value the same as that of host.
>>> + * When guest/host depth are different, the handling would be tricky,
>>> + * so now only max depth is supported for both host and guest.
>>> + */
>>> +static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
>>> +{
>>> +	unsigned int eax, ebx, ecx, edx;
>>> +
>>> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>>> +		return false;
>>> +
>>> +	cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
>>
>> I really don't understand why the sanity check of the
>> guest lbr depth needs to read the host's cpuid entry and it's pretty slow.
>>
> This is to address a concern from Jim:
> "Does this imply that, when restoring a vCPU, KVM_SET_CPUID2 must be called before
> KVM_SET_MSRS, so that arch_lbr_depth_is_valid() knows what to do? Is this documented
> anywhere?"

What will KVM do if the #GP behaviour of msr does not match the CPUID it is set to?

For user space host_initiated path, we may check it with the host one but
for the guest emulation, it should rely on guest cpuid, just like what we do in 
the intel_is_valid_msr().

> anyway, setting depth MSR shouldn't be hot path.

Not at all, it will be used to reset LBR entries
and it's as frequent as task switching.

>   
>> KVM has reported the maximum host LBR depth as the only supported value.
>>
>>> +
>>> +	return (depth == fls(eax & 0xff) * 8);
>>> +}
>>> +
>>>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   {
>>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>   	struct kvm_pmc *pmc;
>>> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>>>   	u32 msr = msr_info->index;
>>>   	switch (msr) {
>>> @@ -367,6 +389,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>>>   		msr_info->data = pmu->global_ovf_ctrl;
>>>   		return 0;
>>> +	case MSR_ARCH_LBR_DEPTH:
>>> +		msr_info->data = lbr_desc->records.nr;
>>> +		return 0;
>>>   	default:
>>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>>> @@ -393,6 +418,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   {
>>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>   	struct kvm_pmc *pmc;
>>> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>>>   	u32 msr = msr_info->index;
>>>   	u64 data = msr_info->data;
>>> @@ -427,6 +453,13 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>   			return 0;
>>>   		}
>>>   		break;
>>> +	case MSR_ARCH_LBR_DEPTH:
>>> +		if (!arch_lbr_depth_is_valid(vcpu, data))
>>> +			return 1;
>>> +		lbr_desc->records.nr = data;
>>> +		if (!msr_info->host_initiated)
>>> +			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
>>
>> Resetting the host msr here is dangerous,
>> what if the guest LBR event doesn't exist or isn't scheduled on?
> Hmm, should be vmcs_write to the DEPTH field, thanks for pointing this
> out!

Seriously?

>>
>>> +		return 0;
>>>   	default:
>>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>>>
