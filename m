Return-Path: <kvm+bounces-227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 951087DD579
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C287B210DD
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDADB2230D;
	Tue, 31 Oct 2023 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VDMR/yKf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3B022308
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:51:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CFAB4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xbwj2dHsP/n+I+LAOQsG7ONUc0ESdKd5+R45/k2Elyo=;
	b=VDMR/yKf5BYIM2W26XRn1A85Ge5i75NcmySFwTjJJ/5BQp07QIbvS764VSg3yWcWatGMCB
	bwjyog/9aOf5XotQJjYN6xGwRNIE6i0m8tCSVBa5u8M6DL++MfcSyhxaPvIcRKwZ2F3sQL
	uKegb1Pw9X9z0mTDJ9XMeiV0DUdBb3w=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-jf8PWJj3MhidLfDRUQTRGg-1; Tue, 31 Oct 2023 13:51:48 -0400
X-MC-Unique: jf8PWJj3MhidLfDRUQTRGg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-507a3ae32b2so6687100e87.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774707; x=1699379507;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xbwj2dHsP/n+I+LAOQsG7ONUc0ESdKd5+R45/k2Elyo=;
        b=WYodDXrdbwn2PfEMk8FBbtAZTwnM63XwWWaz2fFFtfq1E/l1s1IpY+phIq6DMBUIm2
         3sOVynU/Xy96CwqH0cLE/3luqNfEUNi8/HesD8KuCNsJMpRHSS4kPrgwIaXw70PnAm0U
         Z8X+YbPxDCHyEu9FN0nzIbo8RZSH48xX96eDR7Xx9AL9Xc1HrRm8zEW1DbMVVn4uDimh
         Zoem0nSNbVfh6tYTlT/3jtElfqd+U9MhsGDloS4dECp58bSPOwDKms1GXUna7x7XAD0P
         T6+99O6vtjG+zDb3oOW5eK911LSdH17KCG0sD3TDolctD8qPFgCwo3fQaPfRum9SRen/
         dxig==
X-Gm-Message-State: AOJu0Yz90XYWL+uxZf3gVd/s/lP/YBOuYMs9/EY+bx6mDRROfNvStOTJ
	aZH5GEtLd3PR6OSpTK176nS/OEJUsz3JZqiyO+bAaQUF+Dr9qeYffDQAnxU24v1+Y0GwGhw/NQq
	y8/EXukOyI/Jf
X-Received: by 2002:a05:6512:2244:b0:500:9a45:62f with SMTP id i4-20020a056512224400b005009a45062fmr13447424lfu.8.1698774707303;
        Tue, 31 Oct 2023 10:51:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/mKI2hI672a/XC9nfk/tDqx1adzvdlvFxrfqaU6yv9qO6rsdPtvQ8KNgldfudTeaeOOBwHQ==
X-Received: by 2002:a05:6512:2244:b0:500:9a45:62f with SMTP id i4-20020a056512224400b005009a45062fmr13447401lfu.8.1698774706896;
        Tue, 31 Oct 2023 10:51:46 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id y17-20020adff6d1000000b0032f7d7ec4adsm2013882wrp.92.2023.10.31.10.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:51:46 -0700 (PDT)
Message-ID: <2b1973ee44498039c97d4d11de3a93b0f3b1d2d8.camel@redhat.com>
Subject: Re: [PATCH v6 14/25] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:51:44 +0200
In-Reply-To: <20230914063325.85503-15-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-15-weijiang.yang@intel.com>
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
> From: Sean Christopherson <seanjc@google.com>
> 
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
> to facilitate access to such kind of MSRs.
> 
> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
> the guest MSRs are swapped with host's before vCPU exits to userspace and
> after it re-enters kernel before next VM-entry.
> 
> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
> explicitly check @vcpu is non-null before attempting to load guest state.
> The XSS supporting MSRs cannot be retrieved via the device ioctl() without
> loading guest FPU state (which doesn't exist).
> 
> Note that guest_cpuid_has() is not queried as host userspace is allowed to
> access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 30 +++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.h | 24 ++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 66edbed25db8..a091764bf1d2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -133,6 +133,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>  static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>  
>  static DEFINE_MUTEX(vendor_module_lock);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> +
>  struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  
>  #define KVM_X86_OP(func)					     \
> @@ -4372,6 +4375,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>  
> +static const u32 xstate_msrs[] = {
> +	MSR_IA32_U_CET, MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP,
> +	MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
> +};
> +
> +static bool is_xstate_msr(u32 index)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(xstate_msrs); i++) {
> +		if (index == xstate_msrs[i])
> +			return true;
> +	}
> +	return false;
> +}

The name 'xstate_msr' IMHO is not clear.

How about naming it 'guest_fpu_state_msrs', together with adding a comment like that:

"These msrs are context switched together with the rest of the guest FPU state,
on exit/entry to/from userspace

There is also an assumption that loading guest values while the host kernel runs,
doesn't cause harm to the host kernel"


But if you prefer something else, its fine with me, but I do appreciate to have some
comment attached to 'xstate_msr' at least.

> +
>  /*
>   * Read or write a bunch of msrs. All parameters are kernel addresses.
>   *
> @@ -4382,11 +4401,20 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
>  		    int (*do_msr)(struct kvm_vcpu *vcpu,
>  				  unsigned index, u64 *data))
>  {
> +	bool fpu_loaded = false;
>  	int i;
>  
> -	for (i = 0; i < msrs->nmsrs; ++i)
> +	for (i = 0; i < msrs->nmsrs; ++i) {
> +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
> +		    is_xstate_msr(entries[i].index)) {

A comment here about why this is done, will also be appreciated:

"Userspace requested us to read a MSR which value resides in the guest FPU state.
Load this state temporarily to CPU to read/update it."

> +			kvm_load_guest_fpu(vcpu);
> +			fpu_loaded = true;
> +		}
>  		if (do_msr(vcpu, entries[i].index, &entries[i].data))
>  			break;
> +	}

And maybe here too:

"If KVM loaded the guest FPU state, unload to it to restore the original userspace FPU state
and to update the guest FPU state in case it was modified."

> +	if (fpu_loaded)
> +		kvm_put_guest_fpu(vcpu);
>  
>  	return i;
>  }
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 1e7be1f6ab29..9a8e3a84eaf4 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -540,4 +540,28 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>  
> +/*
> + * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
> + * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
> + * guest FPU should have been loaded already.
> + */
> +
> +static inline void kvm_get_xstate_msr(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr_info)
> +{
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +	kvm_fpu_get();
> +	rdmsrl(msr_info->index, msr_info->data);
> +	kvm_fpu_put();
> +}
> +
> +static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr_info)
> +{
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +	kvm_fpu_get();
> +	wrmsrl(msr_info->index, msr_info->data);
> +	kvm_fpu_put();
> +}

These functions are not used in the patch. I think they should be added later
when used.

Best regards,
	Maxim Levitsky

> +
>  #endif






