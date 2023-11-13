Return-Path: <kvm+bounces-1580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3406D7E9747
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8555B20B1E
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EAA1C2B9;
	Mon, 13 Nov 2023 08:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iuKCGJ+J"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536F71B285
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:03:51 +0000 (UTC)
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1362C10F7;
	Mon, 13 Nov 2023 00:03:50 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-58786e23d38so2575100eaf.3;
        Mon, 13 Nov 2023 00:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699862629; x=1700467429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4+cm6GeGEYdHlidIyrWy7wliJcHRHNyOIYFsFKiD5Q=;
        b=iuKCGJ+JWQvhqeAd/V0gfP+aMTE0zPEZPBOLrjvgN5eM476y+BQHvDPAUbq5hOV1wo
         6ntJOLILUDMPsDBKPcdrSF5s2gQFIQTwnaHmuRhPjBv46BrnPOqwTUs2stfXGvsvP9pe
         gcVxOS2UyDB11kOseozqxTpgY+I3DeiMEnbDGQ8x+AjMNr9NQDo9B5xfADBZZg+49DwX
         3tSJhcoQUSt8l4gLlDSp97J+gYmXY0PyfTsD8gRyLT8Hx/UUw6AtSB5jAz1A+WT881Iv
         RlWCGJubRhZ9aNEC+j4YRdGEJmT9/iBMS4Pe50DZ9hT9gDzKSKnhd9mfn3/Ky06G1o50
         16vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699862629; x=1700467429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4+cm6GeGEYdHlidIyrWy7wliJcHRHNyOIYFsFKiD5Q=;
        b=OcNvW80Zu7P/oNbaWoWamyM2PunMc1AuxVgMi+N068aN0Cjz3LhQXjvT9byqsLUBOw
         hK9MFjkP2y/6HW8SnM4eHehMsnrkzZleXb0vh3DuI3xOb+BRrBNodOKXPyENh3kUxwhV
         Xm0tR8Ii0p7TE74ii56b3bmi8j26JxHv07loEGkZy0GyAiNSgMAqI1E+2xL0NCWqvDiL
         M35l2G1nczif4Mr/N+Exryhm6u+Xj5BcTr42kpjE4J4WCLTSGhYRplSAH2ZT3JpbwL2q
         LxvDmn+k2P4N51fDCgeY6QFMGXj8MCEZJ8JhWeftU1scoYzMJWoA3jpIgsr58cRF3u+R
         H3Cg==
X-Gm-Message-State: AOJu0YxLisoJBpXthvs3j8X6GVTLMjU6U5quhwzTnxptJ5axKIgq2cTl
	xvn8cK6/Ph5WJziOMi2uqv3jLVXYmJg=
X-Google-Smtp-Source: AGHT+IGySloX5uvAGdLSdTksTuqruXH9Q3FVWuUKe6XIngqf+snPzZJjbyx+ZHTtZapXTA0/Gq0i+A==
X-Received: by 2002:a05:6871:4689:b0:1e9:b811:da13 with SMTP id ni9-20020a056871468900b001e9b811da13mr8875289oab.49.1699862629258;
        Mon, 13 Nov 2023 00:03:49 -0800 (PST)
Received: from [172.27.233.117] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id e14-20020a62ee0e000000b00688435a9915sm3328702pfi.189.2023.11.13.00.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 00:03:48 -0800 (PST)
Message-ID: <ffec2e93-cdb1-25e2-06ec-deccf8727ce4@gmail.com>
Date: Mon, 13 Nov 2023 16:03:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-7-seanjc@google.com>
Content-Language: en-US
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20231110235528.1561679-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/2023 7:55 AM, Sean Christopherson wrote:
> When updating guest CPUID entries to emulate runtime behavior, e.g. when
> the guest enables a CR4-based feature that is tied to a CPUID flag, also
> update the vCPU's cpu_caps accordingly.  This will allow replacing all
> usage of guest_cpuid_has() with guest_cpu_cap_has().
> 
> Take care not to update guest capabilities when KVM is updating CPUID
> entries that *may* become the vCPU's CPUID, e.g. if userspace tries to set
> bogus CPUID information.  No extra call to update cpu_caps is needed as
> the cpu_caps are initialized from the incoming guest CPUID, i.e. will
> automatically get the updated values.
> 
> Note, none of the features in question use guest_cpu_cap_has() at this
> time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 48 +++++++++++++++++++++++++++++++-------------
>   1 file changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 36bd04030989..37a991439fe6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -262,31 +262,48 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
>   	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>   }
>   
> +static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
> +						       struct kvm_cpuid_entry2 *entry,
> +						       unsigned int x86_feature,
> +						       bool has_feature)
> +{
> +	if (entry)
> +		cpuid_entry_change(entry, x86_feature, has_feature);
> +
> +	if (vcpu)
> +		guest_cpu_cap_change(vcpu, x86_feature, has_feature);
> +}
> +
>   static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
>   				       int nent)
>   {
>   	struct kvm_cpuid_entry2 *best;
> +	struct kvm_vcpu *caps = vcpu;

u32 *caps  = vcpu->arch.cpu_caps;
and update guest_cpu_cap_set(), guest_cpu_cap_clear(), guest_cpu_cap_change() 
and guest_cpu_cap_restrict() to pass in vcpu->arch.cpu_caps instead of vcpu, 
since all of them merely refer to vcpu cap, rather than whole vcpu info.

Or, for simple change, here rename variable name "caps" --> "vcpu", to less 
reading confusion.

> +
> +	/*
> +	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
> +	 * are coming in from userspace!
> +	 */
> +	if (entries != vcpu->arch.cpuid_entries)
> +		caps = NULL;
>   
>   	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> -	if (best) {
> -		/* Update OSXSAVE bit */
> -		if (boot_cpu_has(X86_FEATURE_XSAVE))
> -			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> +
> +	if (boot_cpu_has(X86_FEATURE_XSAVE))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSXSAVE,
>   					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
>   
> -		cpuid_entry_change(best, X86_FEATURE_APIC,
> -			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> +	kvm_update_feature_runtime(caps, best, X86_FEATURE_APIC,
> +				   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>   
> -		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> -					   vcpu->arch.ia32_misc_enable_msr &
> -					   MSR_IA32_MISC_ENABLE_MWAIT);
> -	}
> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_MWAIT,
> +					   vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT);
>   
>   	best = cpuid_entry2_find(entries, nent, 7, 0);
> -	if (best && boot_cpu_has(X86_FEATURE_PKU))
> -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> +	if (boot_cpu_has(X86_FEATURE_PKU))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSPKE,
> +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>   
>   	best = cpuid_entry2_find(entries, nent, 0xD, 0);
>   	if (best)
> @@ -353,6 +370,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
>   	 * honor userspace's definition for features that don't require KVM or
>   	 * hardware management/support (or that KVM simply doesn't care about).
> +	 *
> +	 * Note, KVM has already done runtime updates on guest CPUID, i.e. this
> +	 * will also correctly set runtime features in guest CPU capabilities.
>   	 */
>   	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
>   		const struct cpuid_reg cpuid = reverse_cpuid[i];


