Return-Path: <kvm+bounces-53583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FCEB14465
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 00:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF5147A9FBE
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 22:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EAD722D4C8;
	Mon, 28 Jul 2025 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iETs8ZsC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5158111A8;
	Mon, 28 Jul 2025 22:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753741940; cv=none; b=XntcAWKguu51DENYMmIOGSEm2xMq00YRSIBOxtFlDLGi1U9RGZd4rZKwLD4fCZ3rCedN1cwmcVBMwEYNQlDa/dRI1sJoJsumLPY9gKiQA8A6wappHh+63sYZ9KZ+RDVHwNS9vHWFtZDW4kumGWkKdG+Wc2bQkiZB0YXLGE+Twrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753741940; c=relaxed/simple;
	bh=Juzzlw4ruO94a0oLs+yzxWxBy3doOd+vJtIDuC6EP18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ipbt9NpE5G+SKJtAyRtOTqFjOqzmzInB+JRlxPwNRbiteEFdHlU2JVgD4tVn0busxU0+wPy3ED16nnFcBKctpUBVZ4PiH8C8d0D9/aqNC/TroUO9d6GS15fyZjy/yttX2dyqGyHWzSUZNrAuKdEQ03Lo/TGv9iFcv44E0WMzoIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iETs8ZsC; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56SMVg3E497022
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 28 Jul 2025 15:31:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56SMVg3E497022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753741905;
	bh=coMKTzy6g47ApZXqvc/T7bzOtLJd9+moHdfS0qdGXkg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iETs8ZsCBYDItiL/u8alonHtWWOFh06MlK5KoQDP/X+US0e3spgFCE+3W3OpP9HG8
	 9GMgfewGju5gM/bjuBqg00nOQJoYFJfvmcQJhr0FEdapOYueYwt6Y2QmWet7ChTrRO
	 CgFehS/x+eeJhosLDipXx0fb2Q7NocFc54Lnl/6H1D3ZP78u38cKzIRsycvlMVlvUV
	 EapCE+h0K2EKio1pHAjc5eDkMUa5XU35W9Cxh++a/zuRgrvMJDKikRTGxgpc5Wq8VR
	 /+QeSGaxz6AVvKu1Ko0iWwR4M4dUIxgIcWUMwrGMsJ3L3401Cxzp4IgRN4ADK8HkR0
	 JKhzwXacQ56Ag==
Message-ID: <5591ecc4-2383-4804-b3f0-0dcef692e8f6@zytor.com>
Date: Mon, 28 Jul 2025 15:31:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/23] KVM: x86: Rename kvm_{g,s}et_msr()* to show
 that they emulate guest accesses
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com,
        weijiang.yang@intel.com, minipli@grsecurity.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-2-chao.gao@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250704085027.182163-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/4/2025 1:49 AM, Chao Gao wrote:
> @@ -2764,7 +2764,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>   
>   	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>   	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
> -	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> +	    WARN_ON_ONCE(kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>   				     vmcs12->guest_ia32_perf_global_ctrl))) {

Not sure if the alignment should be adjusted based on the above modified
line.

>   		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>   		return -EINVAL;
> @@ -4752,8 +4752,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>   	}
>   	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>   	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
> -		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
> -					 vmcs12->host_ia32_perf_global_ctrl));
> +		WARN_ON_ONCE(kvm_emulate_msr_write(vcpu,
> +					MSR_CORE_PERF_GLOBAL_CTRL,
> +					vmcs12->host_ia32_perf_global_ctrl));

Same here.

>   
>   	/* Set L1 segment info according to Intel SDM
>   	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7543dac7ae70..11d84075cd14 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1929,33 +1929,35 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>   				 __kvm_get_msr);
>   }
>   
> -int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
> +int kvm_emulate_msr_read_with_filter(struct kvm_vcpu *vcpu, u32 index,
> +				     u64 *data)

I think the extra new line doesn't improve readability, but it's the
maintainer's call.

>   {
>   	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
>   		return KVM_MSR_RET_FILTERED;
>   	return kvm_get_msr_ignored_check(vcpu, index, data, false);
>   }
> -EXPORT_SYMBOL_GPL(kvm_get_msr_with_filter);
> +EXPORT_SYMBOL_GPL(kvm_emulate_msr_read_with_filter);
>   
> -int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
> +int kvm_emulate_msr_write_with_filter(struct kvm_vcpu *vcpu, u32 index,

Ditto.

> +				      u64 data)
>   {
>   	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
>   		return KVM_MSR_RET_FILTERED;


