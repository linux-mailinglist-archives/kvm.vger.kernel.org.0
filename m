Return-Path: <kvm+bounces-55028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAE8B2CB9F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 20:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CDC57AEC81
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5955330EF99;
	Tue, 19 Aug 2025 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="EAz1ueGm"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95CF24167B;
	Tue, 19 Aug 2025 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755626770; cv=none; b=bdH4irOTsAd9mKdIyb8oBrF14uBa0yipahmKe7WTjBIx3gjDBKc267Z91YH0uajj/NzZNdC7DYscfxAIxZfYtp6b8CArOL+y2niHxJPDdA41jz7S8hgL5YBDrpHlIk0wbCgSDX6ZXIfgFz6o87h7jpz6hsjWvb8wEbrJ8OWNHx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755626770; c=relaxed/simple;
	bh=4ci/uHSDKQUzrAd9QBw63j3lDa6mBX0Sl7kzMeMl/xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=esmfB3zykpFEu2KayavNZnWeWOJ1Ut7iPvY9IW/r1ZSdKlSNLMnHE4dCNT83fDEizJtizzWgzM7mLuxVi+9vgFMXfIOxaM3mlMCWjtwyi5eqcVtNlNVhUHKrMQx+2+RVxanoSuj+vPdD6e/Ij9Ctfrcln+jI67m8nsJsPyPjJuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=EAz1ueGm; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57JI5cMt2753519
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 19 Aug 2025 11:05:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57JI5cMt2753519
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755626740;
	bh=vL89P2kUJUJQcq2gfuxqgo4lotKFJfiugtrUniRUAbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EAz1ueGm+8725k9yfPkGYZwTgi262iLmA17o6Izn44IkgEvuux3jlSp/Tm4CkV8I2
	 Cs/bdv595+w2vjO9/5mKUvpyuaPPNGSvXv7tnudiXrTdj18nZtuZCK4Z7g8clu8H+/
	 lUbQ2SrVgImVQDOu63O5YZ3uTguiKE94QYYqRVBtIde3LPjBBATTXTzaTazdeYrVFb
	 iLs0vRy/ZmzkOryLPprlfqGzLe4qCRd5qU4uUSjC8SRVr2kVMgvV3Ug+N5ExtXv3kr
	 WiRVZ2bB9amDssNzUkuVD35rYtHvtFSX3hXB2IIwlfKBvZbQhaWu91RHt8qeRIuE6E
	 P8d/sricEi7Jg==
Message-ID: <77edb8d9-4093-49fe-963c-56da76514d4c@zytor.com>
Date: Tue, 19 Aug 2025 11:05:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/24] KVM: VMX: Set up interception for CET MSRs
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Mathias Krause <minipli@grsecurity.net>,
        John Allen <john.allen@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-18-chao.gao@intel.com> <aKSiNh43UCosGIVh@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aKSiNh43UCosGIVh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/2025 9:11 AM, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>>
>> Enable/disable CET MSRs interception per associated feature configuration.
>>
>> Shadow Stack feature requires all CET MSRs passed through to guest to make
>> it supported in user and supervisor mode
> 
> I doubt that SS _requires_ CET MSRs to be passed through.  IIRC, the actual
> reason for passing through most of the MSRs is that they are managed via XSAVE,
> i.e. _can't_ be intercepted without also intercepting XRSTOR.
> 
>> while IBT feature only depends on
>> MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>>
>> Note, this MSR design introduced an architectural limitation of SHSTK and
>> IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
>> to guest from architectural perspective since IBT relies on subset of SHSTK
>> relevant MSRs.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Tested-by: Mathias Krause <minipli@grsecurity.net>
>> Tested-by: John Allen <john.allen@amd.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index bd572c8c7bc3..130ffbe7dc1a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4088,6 +4088,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>>   
>>   void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>>   {
>> +	bool set;
> 
> s/set/intercept
> 

Maybe because you asked me to change "flag" to "set" when reviewing FRED
patches, however "intercept" does sound better, and I just changed it :)

>> +
>>   	if (!cpu_has_vmx_msr_bitmap())
>>   		return;
>>   
>> @@ -4133,6 +4135,24 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>>   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
>>   					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
>>   
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, set);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, set);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, set);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, set);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, set);
> 
> MSR_IA32_INT_SSP_TAB isn't managed via XSAVE, so why is it being passed through?

It's managed in VMCS host and guest areas, i.e. HOST_INTR_SSP_TABLE and
GUEST_INTR_SSP_TABLE, if the "load CET" bits are set in both VM entry
and exit controls.

FRED MSRs are also passed through to guest in such cases.

no?

