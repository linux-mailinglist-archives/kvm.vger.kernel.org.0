Return-Path: <kvm+bounces-226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 128C87DD578
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E8AEB20F07
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BC2E21354;
	Tue, 31 Oct 2023 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCmpXN13"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B37D208D0
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:51:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629FBA6
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SG+40GpplkvNW1CAOdJBVH5eVU8uZEgWxfsItEyklhU=;
	b=BCmpXN13J0ezqh1cRHSyLvDn/Q0d4qvsHRZ9TSCBOADQ+YS5jNbdQ06w4riztB2pAuHe+Z
	zg+uoUL59+mdEBnuRPqzZpcZ+3ojLnvwWLSiFEnQc2oXkpHPz4gRWigUGf9wIrU/Z6O1FZ
	0WsdMaewE+w1QwQTc66JlqHbemWROnI=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-Quu4acqOPxisUsby880CqA-1; Tue, 31 Oct 2023 13:51:07 -0400
X-MC-Unique: Quu4acqOPxisUsby880CqA-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c131ddfcfaso61710781fa.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774666; x=1699379466;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SG+40GpplkvNW1CAOdJBVH5eVU8uZEgWxfsItEyklhU=;
        b=dw5yE/ZiU4gfELqKH2Xwg54TeL+hBajULORfmcq8vdw36GHh04FC6NPBVM9Jak3lJo
         7+x8RB5zrVA5CjD3BLRJO+UNh9DUN6tdmD6jWovOIQDKguIbG8cqiylyYnxdsyYKv01R
         oLtmgUP2lB+2XU3rmCUYvQ2QZqQ0gib1slH9ziWritEQJFSgDbgCHfzfBauRxYNJ8P7u
         6ddd2ZtoWKyA5j8jU4kzTkomfWU0TItB8CYLWUpgQbQ/Si3vKlyauE/hK+skS+9YfKmx
         D3puqUtJ1grGel2L0+ZpbKGHl0gy1cXpdin478m/hMhLi+cBBIvTPo8A5z3SgPJm12TH
         nu2w==
X-Gm-Message-State: AOJu0Ywgznd8HMqsX+ymu+zi/As9tw0WGZPX5ZRdulWB77OZVmKvXtcB
	cE6WKk614hHgXeMUVDyMDwMcOcXawAOv3W057B04FSnyt9EUHaqXM8QUftmiSQXXtEBjJRwtk66
	2NdmC29oVWptM
X-Received: by 2002:a2e:990a:0:b0:2bc:f41a:d9bc with SMTP id v10-20020a2e990a000000b002bcf41ad9bcmr10231302lji.25.1698774665832;
        Tue, 31 Oct 2023 10:51:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaajZM1G/jLAEkI7sQHt++jLqf/BneIH6DsAPsMXOxg7iM1riPSMuMES+LaJat0TY3dBJlLw==
X-Received: by 2002:a2e:990a:0:b0:2bc:f41a:d9bc with SMTP id v10-20020a2e990a000000b002bcf41ad9bcmr10231290lji.25.1698774665475;
        Tue, 31 Oct 2023 10:51:05 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b0040523bef620sm1087120wmj.0.2023.10.31.10.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:51:05 -0700 (PDT)
Message-ID: <5c5eb1cc92d05fb7717fe3480aeb7b20e7842d05.camel@redhat.com>
Subject: Re: [PATCH v6 12/25] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com, Zhang Yi Z
	 <yi.z.zhang@linux.intel.com>
Date: Tue, 31 Oct 2023 19:51:03 +0200
In-Reply-To: <20230914063325.85503-13-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
> due to XSS MSR modification.
> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
> before allocate sufficient xsave buffer.
> 
> Note, KVM does not yet support any XSS based features, i.e. supported_xss
> is guaranteed to be zero at this time.
> 
> Opportunistically modify XSS write access logic as: if !guest_cpuid_has(),
> write initiated from host is allowed iff the write is reset operaiton,
> i.e., data == 0, reject host_initiated non-reset write and any guest write.

The commit message is not clear and somewhat misleading because it forces the reader 
to parse the whole patch before one could understand what '!guest_cpuid_has()'
means.

Also I don't think that the term 'reset operation' is a good choice, because it is too closely
related to vCPU reset IMHO. Let's at least call it 'reset to a default value' or something like that.
Also note that 0 is not always the default/reset value of an MSR.

I suggest this instead:

"If XSAVES is not enabled in the guest CPUID, forbid setting IA32_XSS msr
to anything but 0, even if the write is host initiated."

Also, isn't this change is at least in theory not backward compatible?
While KVM didn't report IA32_XSS as one needing save/restore, the userspace
could before this patch set the IA32_XSS to any value, now it can't.

Maybe it's safer to allow to set any value, ignore the set value and
issue a WARN_ON_ONCE or something?

Finally, I think that this change is better to be done in a separate patch
because it is unrelated and might not even be backward compatible.

Best regards,
	Maxim Levitsky

> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
>  arch/x86/kvm/x86.c              | 13 +++++++++----
>  3 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 0fc5e6312e93..d77b030e996c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -803,6 +803,7 @@ struct kvm_vcpu_arch {
>  
>  	u64 xcr0;
>  	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
>  
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1f206caec559..4e7a820cba62 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
> +						 vcpu->arch.ia32_xss, true);
>  
>  	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>  	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> @@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
>  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>  }
>  
> +static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
> +	if (!best)
> +		return 0;
> +
> +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
> +}

Same question as one for patch that added vcpu_get_supported_xcr0()
Why to have per vCPU supported XSS if we assume that all CPUs have the same
CPUID?

I mean I am not against supporting hybrid CPU models, but KVM currently doesn't
support this and this creates illusion that it does.

> +
>  static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>  {
>  	struct kvm_cpuid_entry2 *entry;
> @@ -358,6 +370,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	}
>  
>  	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
> +	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
>  
>  	/*
>  	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1258d1d6dd52..9a616d84bd39 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3795,20 +3795,25 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			vcpu->arch.ia32_tsc_adjust_msr += adj;
>  		}
>  		break;
> -	case MSR_IA32_XSS:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> +	case MSR_IA32_XSS: {
> +		bool host_msr_reset = msr_info->host_initiated && data == 0;
> +
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
> +		    (!host_msr_reset || !msr_info->host_initiated))
>  			return 1;
>  		/*
>  		 * KVM supports exposing PT to the guest, but does not support
>  		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>  		 * XSAVES/XRSTORS to save/restore PT MSRs.
>  		 */
Just in case.... TODO

> -		if (data & ~kvm_caps.supported_xss)
> +		if (data & ~vcpu->arch.guest_supported_xss)
>  			return 1;
> +		if (vcpu->arch.ia32_xss == data)
> +			break;
>  		vcpu->arch.ia32_xss = data;
>  		kvm_update_cpuid_runtime(vcpu);
>  		break;
> +	}
>  	case MSR_SMI_COUNT:
>  		if (!msr_info->host_initiated)
>  			return 1;







